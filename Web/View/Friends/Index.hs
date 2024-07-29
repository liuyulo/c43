module Web.View.Friends.Index where
import Web.View.Prelude

data IndexView = IndexView { friends :: [Friend] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Friends<a href={pathTo NewFriendAction} class="btn btn-primary ms-4">+ Add</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Friend</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach friends renderFriend}</tbody>
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
        <td><a href={EditFriendAction friend.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteFriendAction friend.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]