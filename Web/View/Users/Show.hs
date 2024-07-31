module Web.View.Users.Show where
import Web.View.Prelude

data ShowView = ShowView

instance View ShowView where
    html ShowView = [hsx|
    {breadcrumb}
        <h1>Hello <span class="text-primary">{currentUser.email}</span>
         <a class="btn btn-primary js-delete js-delete-no-confirm float-right" href={DeleteSessionAction}>Logout</a></h1>
        <ul>
            <li><a href={PortfoliosAction}>Portfolios</a></li>
            <li><a href={FriendsAction}>Friends</a></li>
            <li><a href={StocklistsAction}>Stock lists</a></li>
        </ul>

    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbText [hsx| <a href="/">Welcome</a> |]
                , breadcrumbText "Profile"
                ]