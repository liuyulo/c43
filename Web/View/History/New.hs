module Web.View.History.New where
import Web.View.Prelude

data NewView = NewView { history :: History }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New History</h1>
        {renderForm history}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Histories" HistoriesAction
                , breadcrumbText "New History"
                ]

renderForm :: History -> Html
renderForm history = formFor history [hsx|
    {(dateField #timestamp)}
    {(numberField #open)}
    {(numberField #high)}
    {(numberField #low)}
    {(numberField #close){required=True}}
    {(numberField #volume)}
    {(textField #symbol) {required=True}}
    {submitButton}

|]