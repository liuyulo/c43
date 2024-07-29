module Web.View.Users.Show where
import Web.View.Prelude

data ShowView = ShowView { user :: User }

instance View ShowView where
    html ShowView { .. } = [hsx|
    {breadcrumb}
        <h1>Hello <span class="text-primary">{user.email}</span></h1>
        <ul>
            <li><a href={PortfoliosAction user.id}>portfolios</a></li>
        </ul>

    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbText [hsx| <a href="/">Welcome</a> |]
                , breadcrumbText "Profile"
                ]