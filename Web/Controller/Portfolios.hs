module Web.Controller.Portfolios where

import Web.Controller.Prelude
import Web.View.Portfolios.Index
import Web.View.Portfolios.New
import Web.View.Portfolios.Edit
import Web.View.Portfolios.Show

instance Controller PortfoliosController where
    beforeAction = ensureIsUser

    action PortfoliosAction = do
        portfolios <- query @Portfolio |> filterWhere (#username, currentUser.email) |> fetch
        render IndexView { .. }

    action NewPortfolioAction = do
        let portfolio = newRecord |> set #username currentUser.email
        render NewView { .. }

    action ShowPortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        accessDeniedUnless (portfolio.username == currentUser.email)
        holds :: [(Id Stock, Float, Float)] <- sqlQuery "SELECT symbol, amount, value FROM portfolio_holds NATURAL JOIN stocks WHERE portfolio_id = ?" (Only portfolioId)
        trans :: [(UTCTime, Id Stock, Float, Float)] <- sqlQuery "SELECT created_at, symbol, amount, price FROM transactions WHERE portfolio_id = ?" $ Only portfolioId
        render ShowView { .. }

    action EditPortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        accessDeniedUnless (portfolio.username == currentUser.email)
        holds :: [(Id Stock, Float)] <- sqlQuery "SELECT symbol, amount FROM portfolio_holds WHERE portfolio_id = ?" $ Only portfolioId
        render EditView { .. }

    action UpdatePortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        accessDeniedUnless (portfolio.username == currentUser.email)
        portfolio
            |> buildPortfolio
            |> ifValid \case
                Left portfolio -> redirectTo EditPortfolioAction { .. }
                Right portfolio -> do
                    portfolio <- portfolio |> updateRecord
                    setSuccessMessage "Portfolio updated"
                    redirectTo PortfoliosAction

    action CreatePortfolioAction = do
        let portfolio = newRecord @Portfolio |> set #username currentUser.email
        portfolio
            |> buildPortfolio
            |> ifValid \case
                Left portfolio -> do
                        let user = currentUser
                        render NewView { .. }
                Right portfolio -> do
                    portfolio <- portfolio |> createRecord
                    setSuccessMessage "Portfolio created"
                    redirectTo PortfoliosAction

    action DeletePortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        accessDeniedUnless (portfolio.username == currentUser.email)
        deleteRecord portfolio
        setSuccessMessage "Portfolio deleted"
        redirectTo PortfoliosAction

buildPortfolio portfolio = portfolio
    |> fill @'["username", "portfolioName", "cash"]
    |> validateField #portfolioName nonEmpty
