module Web.View.Friends.Index where
import Web.View.Prelude

-- data IndexView = IndexView { friends :: [Friend] }
data IndexView = IndexView {
    accepted :: [Friend], incoming :: [Friend], outgoing :: [Friend]
    }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Friends for <span class="text-primary">{currentUser.email}</span><a href={pathTo NewFriendAction} class="btn btn-primary ms-4 float-right">+ Add Friend</a></h1>
        <h2>Current friends</h2>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>At</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach accepted renderFriend}</tbody>
            </table>
             <h2>Incoming requests</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>From</th>
                        <th>Status</th>
                        <th>At</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach incoming renderI}</tbody>
            </table>
            <h2>Outgoing requests</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>To</th>
                        <th>Status</th>
                        <th>At</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach outgoing renderO}</tbody>
            </table>
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Profile" ShowUserAction,
                    breadcrumbLink "Friends" FriendsAction
                ]

renderFriend :: Friend -> Html
renderFriend friend = [hsx|
    <tr>
        <td>{friend.userTo}</td>
        <td>{showTime friend.createdAt}</td>
        <td><a href={RejectFriendAction friend.userTo} class="btn btn-danger">Reject</a></td>
    </tr>
|]

renderI :: Friend -> Html
renderI friend = [hsx|
    <tr>
        <td>{friend.userFrom}</td>
        <td>{friend.status}</td>
        <td>{showTime friend.createdAt}</td>
        <td>{reject}</td>
        <td><a href={AcceptFriendAction friend.userFrom} class="btn btn-primary">Accept</a></td>
    </tr>
|]
    where
        reject | friend.status == Rejected = ""
               | otherwise = [hsx| <a href={RejectFriendAction friend.userFrom} class="btn btn-danger">Reject</a> |]

renderO :: Friend -> Html
renderO friend = [hsx|
    <tr>
        <td>{friend.userTo}</td>
        <td>{friend.status}</td>
        <td>{showTime friend.createdAt}</td>
        <td>{button}</td>
    </tr>
|]
    where
        button
            | friend.status == Rejected = [hsx|
                <a href={RequestAgainAction friend.userTo} class="btn btn-primary">Request Again</a>
            |]
            | otherwise = [hsx|
                <a href={DeleteFriendAction friend.userTo} class="js-delete btn btn-danger">Recall</a>
            |]


showTime t = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S" zoned
  where
    zoned = utcToZonedTime (hoursToTimeZone (- 4)) t