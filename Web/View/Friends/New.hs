module Web.View.Friends.New where
import Web.View.Prelude

data NewView = NewView { friend :: Friend }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>Send Friend Request</h1>
        {renderForm friend}
    |]
        where
            breadcrumb = renderBreadcrumb
                [
                     breadcrumbLink "Profile" ShowUserAction
                ,breadcrumbLink "Friends" FriendsAction
                , breadcrumbText "Friend Request"
                ]

renderForm :: Friend -> Html
renderForm friend = formFor friend [hsx|
    {(textField #userFrom)}
    {(textField #userTo)}
    {(textField #status)}
    {submitButton}

|]