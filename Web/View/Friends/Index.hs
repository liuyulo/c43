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
                        <th></th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach accepted renderFriend}</tbody>
            </table>
            <h2>Incoming requests</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Status</th>
                        <th>Recieved at</th>
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
                        <th>ID</th>
                        <th>Status</th>
                        <th>Sent at</th>
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
                    breadcrumbText "Friends"
                ]

renderFriend :: Friend -> Html
renderFriend friend = [hsx|
    <tr>
        <td>{friend}</td>
        <td><a href={ShowFriendAction friend.id}>Show</a></td>
        <td><a href={DeleteFriendAction friend.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]

renderI :: Friend -> Html
renderI friend = [hsx|
    <tr>
        <td>{friend.userFrom}</td>
        <td>{friend.status}</td>
        <td>{friend.createdAt}</td>
        <td><a class="btn btn-primary">Accept</a></td>
        <td><a class="btn btn-danger">Reject</a></td>
    </tr>
|]

renderO :: Friend -> Html
renderO friend = [hsx|
    <tr>
        <td>{friend.userTo}</td>
        <td>{friend.status}</td>
        <td>{friend.createdAt}</td>
        <td><a href={DeleteFriendAction friend.id} class="js-delete btn btn-danger">Recall</a></td>
    </tr>
|]