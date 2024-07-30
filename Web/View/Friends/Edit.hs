module Web.View.Friends.Edit where
import Web.View.Prelude

data EditView = EditView { friend :: Friend }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Friend</h1>
        {renderForm friend}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Friends" FriendsAction
                , breadcrumbText "Edit Friend"
                ]

renderForm :: Friend -> Html
renderForm friend = formFor friend [hsx|
    {(textField #status)}
    {submitButton}

|]