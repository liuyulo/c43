module Web.View.Friends.Show where
import Web.View.Prelude

data ShowView = ShowView { friend :: Friend }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Friend</h1>
        <p>{friend}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Friends" FriendsAction
                            , breadcrumbText "Show Friend"
                            ]