module Web.Controller.Transactions where

import Web.Controller.Prelude

instance Controller TransactionsController where
    action CreateTransactionAction = do
        let transaction = newRecord @Transaction
        transaction
            |> buildTransaction
            |> ifValid \case
                Left transaction -> redirectTo EditPortfolioAction { portfolioId = transaction.portfolioId } 
                Right transaction -> do
                    transaction <- withTransaction do
                        portfolio <- fetch transaction.portfolioId
                        portfolio 
                            |> set #cash (portfolio.cash - transaction.amount * transaction.price) 
                            |> updateRecord
                        transaction |> createRecord
                    setSuccessMessage "Transaction created"
                    redirectTo ShowPortfolioAction { portfolioId = transaction.portfolioId }

buildTransaction transaction = transaction
    |> fill @'["amount", "price", "portfolioId", "symbol"]
