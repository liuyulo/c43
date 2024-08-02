module Web.View.Portfolios.Show where

import Web.View.Prelude
import Database.PostgreSQL.Simple.Time

data ShowView = ShowView
  { portfolio :: Portfolio,
    holds :: [(Id Stock, Float, Float, Day)],
    trans :: [(UTCTime, Id Stock, Float, Float)]
  }

instance View ShowView where
  html ShowView {..} = [hsx|
        {breadcrumb}
        <h1>Portfolio  {renderStat}</h1>
        <table class="table">
            <tbody>
                <tr>
                    <td><strong>Owner</strong></td>
                    <td>{currentUser.email}</td>
                </tr>
                <tr>
                    <td><strong>Name</strong></td>
                    <td>{portfolio.portfolioName}</td>
                </tr>
                <tr>
                    <td><strong>Cash Amount</strong></td>
                    <td>${portfolio.cash}</td>
                </tr>
                <tr>
                    <td><strong>Total Value (Holdings)</strong></td>
                    <td>${total}</td>
                </tr>
            </tbody>
        </table>


        <h2>Holdings</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Symbol</th>
                    <th>Amount</th>
                    <th>Current Value</th>
                </tr>
            </thead>
            <tbody>
                {forEach holds renderHold}
            </tbody>
        </table>

        <h2>Transactions</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Symbol</th>
                    <th>Amount</th>
                    <th>Unit Price</th>
                </tr>
            </thead>
            <tbody>
                {forEach trans renderTran}
            </tbody>
        </table>
    |]
    where
      -- holds :: [(Id Stock, Float, Float)]
        total = sum $ (\(_, a, b, _) -> a * b) <$> holds
        breadcrumb = renderBreadcrumb [
                breadcrumbLink "Profile" ShowUserAction,
                breadcrumbLink "Portfolios" PortfoliosAction,
                breadcrumbText "Portfolio"
            ]
        days = (\(_, _, _, d) -> d) <$> holds
        end = if null days then "2024-08-03" else (show $ minimum days)
        start = if null days then "2024-08-03" else (show $ addDays (-5) $ minimum days)
        renderStat = [hsx|
            <a href={MatrixPorfolioAction portfolio.id start end} class="float-right btn btn-primary">View Statistics</a>
        |]
        
renderHold :: (Id Stock, Float, Float, Day) -> Html
renderHold (symbol, amount, value, day) = [hsx|
    <tr>
        <td>{renderSymbol symbol day}</td>
        <td>{amount}</td>
        <td>${value}</td>
    </tr>
    |]

renderTran :: (UTCTime, Id Stock, Float, Float) -> Html
renderTran (date, symbol, amount, price) = [hsx|
    <tr>
        <td>{date}</td>
        <td>{please symbol}</td>
        <td>{amount}</td>
        <td>${price}</td>
    </tr>
    |]
