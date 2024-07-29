module Web.Controller.Friends where

import Web.Controller.Prelude
import Web.View.Friends.Index
import Web.View.Friends.New
import Web.View.Friends.Edit
import Web.View.Friends.Show

instance Controller FriendsController where
    beforeAction = ensureIsUser
    action FriendsAction = do
        friends <- query @Friend |> fetch
        render IndexView { .. }

    action NewFriendAction = do
        let friend = newRecord
                |> set #userFrom currentUserId
                |> set #status (Just Pending)
        render NewView { .. }

    action ShowFriendAction { friendId } = do
        friend <- fetch friendId
        render ShowView { .. }

    action EditFriendAction { friendId } = do
        friend <- fetch friendId
        render EditView { .. }

    action UpdateFriendAction { friendId } = do
        friend <- fetch friendId
        friend
            |> buildFriend
            |> ifValid \case
                Left friend -> render EditView { .. }
                Right friend -> do
                    friend <- friend |> updateRecord
                    setSuccessMessage "Friend updated"
                    redirectTo EditFriendAction { .. }

    action CreateFriendAction = do
        let friend = newRecord @Friend
        friend
            |> buildFriend
            |> ifValid \case
                Left friend -> render NewView { .. }
                Right friend -> do
                    friend <- friend |> createRecord
                    setSuccessMessage "Friend created"
                    redirectTo FriendsAction

    action DeleteFriendAction { friendId } = do
        friend <- fetch friendId
        deleteRecord friend
        setSuccessMessage "Friend deleted"
        redirectTo FriendsAction

buildFriend friend = friend
    |> fill @'["userFrom", "userTo", "status"]
    |> validateField #userTo nonEmpty

