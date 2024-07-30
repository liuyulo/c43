module Web.View.Portfolios.Edit where
import Web.View.Prelude

data EditView = EditView { portfolio :: Portfolio }

instance View EditView where
    html EditView { .. } = [hsx|
        <h1>Edit Portfolio</h1>
        {renderForm portfolio}
    |]

renderForm :: Portfolio -> Html
renderForm portfolio = formFor portfolio [hsx|
    {(hiddenField #userId)}
    {(textField #portfolioName)}
    {(numberField #cash)}
    {submitButton}

|]