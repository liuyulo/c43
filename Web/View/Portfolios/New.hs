module Web.View.Portfolios.New where
import Web.View.Prelude

data NewView = NewView { portfolio :: Portfolio }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Portfolio for <span class="text-primary">{currentUser.email}</span></h1>
        {renderForm portfolio}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Profile" ShowUserAction
                , breadcrumbText "New Portfolio"
                ]

renderForm :: Portfolio -> Html
renderForm portfolio = formFor portfolio [hsx|
    {(hiddenField #username)}
    {(textField #portfolioName)}
    {submitButton}
|]