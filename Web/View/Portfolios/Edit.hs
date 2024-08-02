module Web.View.Portfolios.Edit where
import Web.View.Prelude

data EditView = EditView 
    { portfolio :: Portfolio
    }

instance View EditView where
    html EditView { .. } = [hsx|
        <h1>Edit Portfolio</h1>
        {renderForm portfolio}

        <h2>Record New Transaction</h2>
<blockquote>Positive for buy, negative for sell, zero not allowed</blockquote>
        {renderTran $ newRecord |> set #portfolioId portfolio.id}
    |]

renderForm :: Portfolio -> Html
renderForm portfolio = formFor portfolio [hsx|
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