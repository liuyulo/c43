module Web.View.Friends.New where
import Web.View.Prelude

data NewView = NewView { friend :: Friend }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>Send Friend Request from <span class="text-primary">{friend.userFrom}</span></h1>
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
    {(hiddenField #userFrom)}
    {(textField #userTo) { fieldLabel = "Username", additionalAttributes = [ ("autocomplete", "off") ] }}
    {(hiddenField #status)}
    {submitButton}

|]