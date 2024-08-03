module Web.View.Portfolios.Edit where

import Web.View.Prelude

data EditView = EditView
  { portfolio :: Portfolio
  }

instance View EditView where
  html EditView {..} = [hsx|
        {breadcrumb}
        <h1>Edit Portfolio</h1>
        {renderForm portfolio}
        <br>
        <h2>Record New Transaction</h2>
        <p>Positive amount to buy, negative amount to sell</p>
        {renderTran $ newRecord |> set #portfolioId portfolio.id}
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Profile" ShowUserAction,
            breadcrumbLink "Portfolios" PortfoliosAction,
            breadcrumbText "Edit Portfolio"
          ]

renderForm :: Portfolio -> Html
renderForm portfolio =
  formFor
    portfolio
    [hsx|
    {(hiddenField #username)}
    {(textField #portfolioName)}
    {(numberField #cash) {fieldLabel="Cash ($)"}}
    {submitButton}
|]

renderTran :: Transaction -> Html
renderTran transaction = formFor transaction [hsx|
{(numberField #amount)}
{(numberField #price) {fieldLabel="Unit Price"}}
{(hiddenField #portfolioId)}
{(textField #symbol)}
{submitButton}
|]
