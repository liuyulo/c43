module Web.Controller.Portfolios where

import Web.Controller.Prelude
import Web.View.Portfolios.Index
import Web.View.Portfolios.New
import Web.View.Portfolios.Edit
import Web.View.Portfolios.Show

instance Controller PortfoliosController where
    beforeAction = ensureIsUser

    action PortfoliosAction = do
        portfolios <- query @Portfolio |> filterWhere (#userId, currentUserId) |> fetch
        user <- fetch currentUserId
        render IndexView { .. }

    action NewPortfolioAction { userId } = do
        let portfolio = newRecord |> set #userId userId
        user <- fetch userId
        render NewView { .. }

    action ShowPortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        user <- query @User
                |> filterWhere (#id, portfolio.userId)
                |> fetchOne
        render ShowView { .. }

    action EditPortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        render EditView { .. }

    action UpdatePortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        portfolio
            |> buildPortfolio
            |> ifValid \case
                Left portfolio -> render EditView { .. }
                Right portfolio -> do
                    portfolio <- portfolio |> updateRecord
                    setSuccessMessage "Portfolio updated"
                    redirectTo PortfoliosAction

    action CreatePortfolioAction = do
        let portfolio = newRecord @Portfolio |> set #userId currentUser.id
        portfolio
            |> buildPortfolio
            |> ifValid \case
                Left portfolio -> do
                        user <- fetch $ get #userId portfolio
                        render NewView { .. }
                Right portfolio -> do
                    portfolio <- portfolio |> createRecord
                    setSuccessMessage "Portfolio created"
                    redirectTo PortfoliosAction

    action DeletePortfolioAction { portfolioId } = do
        portfolio <- fetch portfolioId
        deleteRecord portfolio
        setSuccessMessage "Portfolio deleted"
        redirectTo PortfoliosAction

buildPortfolio portfolio = portfolio
    |> fill @'["userId", "portfolioName", "cash"]
    |> validateField #portfolioName nonEmpty
