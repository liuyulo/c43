module Web.Controller.Friends where

import Debug.Trace
import Web.Controller.Prelude
import Web.View.Friends.Index
import Web.View.Friends.New
instance Controller FriendsController where
    beforeAction = ensureIsUser
    action FriendsAction = do
        accepted <- query @Friend
                |> filterWhere (#userFrom, currentUser.email)
                |> filterWhere (#status, Accepted)
                |> fetch
        incoming <- query @Friend
                |> filterWhere (#userTo, currentUser.email)
                |> filterWhere (#status, Pending)
                |> fetch
        outgoing <- query @Friend
                |> filterWhere (#userFrom, currentUser.email)
                |> filterWhereNot (#status, Accepted)
                |> fetch
        render IndexView { .. }

    action NewFriendAction = do
        let friend = newRecord
                |> set #userFrom currentUser.email
                |> set #status Pending
        render NewView { .. }


    action AcceptFriendAction { userFrom } = do
        now <- getCurrentTime
        friend <- queryFriend userFrom currentUser.email |> fetchOne
        friend
            |> set #status Accepted
            |> set #createdAt now
            |> updateRecord
        newRecord @Friend
            |> set #userFrom currentUser.email
            |> set #userTo userFrom
            |> set #createdAt now
            |> set #status Accepted
            |> createRecord
        redirectTo FriendsAction

    action RejectFriendAction { userFrom } = do
        friend <- queryFriend userFrom currentUser.email |> fetchOne
        now <- getCurrentTime
        friend
            |> set #status Rejected
            |> set #createdAt now
            |> updateRecord
        -- in case we are rejecting an accepted friend
        friends <- queryFriend currentUser.email userFrom |> fetch
        deleteRecords friends
        redirectTo FriendsAction

    action CreateFriendAction = do
        let friend = newRecord @Friend
        friend
            |> buildFriend
            |> validateField #userTo nonEmpty
            |> validateField #userTo (\userTo -> if userTo == currentUser.email then Failure "You can't befriend yourself!" else Success)
            |> \model -> do
                result <- query @User |> findMaybeBy #email model.userTo
                case result of
                    Just value -> pure (attachValidatorResult #userTo Success model)
                    Nothing -> pure (attachValidatorResult #userTo (Failure "User doesn't exist") model)
            >>= \model -> do
                result <- queryFriends model.userFrom model.userTo |> fetchOneOrNothing
                case result of
                    Just value -> pure (attachValidatorResult #userTo (Failure "Request already exists") model)
                    Nothing -> pure (attachValidatorResult #userTo Success model)
            >>= ifValid \case
                Left friend -> render NewView { .. }
                Right friend -> do
                    friend <- friend |> createRecord
                    setSuccessMessage "Friend created"
                    redirectTo FriendsAction

    action RequestAgainAction { userTo } = do
        friend <- queryFriend currentUser.email userTo |> fetchOne
        now <- getCurrentTime
        let (seconds, _) = properFraction $  diffUTCTime now friend.createdAt
        if seconds < fst threshold
            then setErrorMessage $ "Please wait for " ++ snd threshold
            else do
                friend
                    |> set #status Pending
                    |> set #createdAt now
                    |> updateRecord
                setSuccessMessage "Requested!"
        redirectTo FriendsAction
    action DeleteFriendAction { userTo } = do
        friend <- queryFriend currentUser.email userTo |> fetchOne
        deleteRecord friend
        redirectTo FriendsAction


threshold = (5 * 60, "5 minutes!")

-- get any relationship between users
queryFriends userA userB = queryUnion friendsA friendsB
    where
        friendsA = query @Friend
                |> filterWhere (#userTo, userA)
                |> filterWhere (#userFrom, userB)
        friendsB = query @Friend
                |> filterWhere (#userFrom, userA)
                |> filterWhere (#userTo, userB)

queryFriend userFrom userTo = query @Friend
        |> filterWhere (#userFrom, userFrom)
        |> filterWhere (#userTo, userTo)

buildFriend friend = friend
    |> fill @'["userFrom", "userTo", "status"]
