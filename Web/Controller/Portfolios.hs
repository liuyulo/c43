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
        user <- fetch currentUserId
        render IndexView { .. }

    action NewPortfolioAction { userId } = do
        user <- fetch userId
        let portfolio = newRecord |> set #username user.email
        render NewView { .. }

    action ShowPortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        accessDeniedUnless (portfolio.username == currentUser.email)
        let user = currentUser
        render ShowView { .. }

    action EditPortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        accessDeniedUnless (portfolio.username == currentUser.email)
        render EditView { .. }

    action UpdatePortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        accessDeniedUnless (portfolio.username == currentUser.email)
        portfolio
            |> buildPortfolio
            |> ifValid \case
                Left portfolio -> render EditView { .. }
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
