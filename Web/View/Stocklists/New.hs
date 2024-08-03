module Web.View.Stocklists.New where
import Web.View.Prelude

data NewView = NewView { stocklist :: Stocklist }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Stock List for <span class="text-primary">{currentUser.email}</span></h1>
        {renderForm stocklist}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Profile" ShowUserAction
                , breadcrumbLink "Stock Lists" StocklistsAction
                , breadcrumbText "New Stock List"
                ]
renderForm :: Stocklist -> Html
renderForm stocklist = formFor stocklist [hsx|
    {(hiddenField #username)}
    {(textField #listName) { additionalAttributes = [ ("autocomplete", "off") ] }}
    {(checkboxField #isPublic) { fieldLabel = "Public"}}
    {(textField #category){ additionalAttributes = [ ("autocomplete", "off") ] }}
    {submitButton}
|]