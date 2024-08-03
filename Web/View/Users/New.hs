module Web.View.Users.New where
import Web.View.Prelude

data NewView = NewView { user :: User }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New User</h1>
        {renderForm user}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbText [hsx| <a href="/">Welcome</a> |]
                , breadcrumbText "Create account"
                ]

renderForm :: User -> Html
renderForm user = formFor user [hsx|
    {(textField #email) {fieldLabel="Username", required=True}}
    {(passwordField #passwordHash) {fieldLabel = "Password", required = True}}

    {(passwordField #passwordHash) { required = True, fieldLabel = "Password confirmation", fieldName = "passwordConfirmation", validatorResult = Nothing }}

    {submitButton}
|]