module Web.Controller.ListContain where

import Web.Controller.Prelude

instance Controller ListContainController where
    action CreateListContain = do
        let entry = newRecord @ListContain
        entry <- entry
            |> fill @'["listId", "symbol", "amount"]
            |> createRecord
        setSuccessMessage "Added new stock"
        redirectTo EditStocklistAction {stocklistId=entry.listId}

    action UpdateListContainAction { stocklistId } = do
        let symbol :: (Id Stock)= param "symbol"
        element <- query @ListContain
            |> filterWhere (#listId, stocklistId)
            |> filterWhere (#symbol, symbol)
            |> fetchOne
        element
            |> fill @'["listId", "symbol", "amount"]
            |> validateField #amount (isGreaterThan 0)
            |> updateRecord
        setSuccessMessage "Stock list updated"
        redirectTo ShowStocklistAction { .. }

    action DeleteListContainAction { stocklistId, symbol } = do
        element <- query @ListContain
            |> filterWhere (#listId, stocklistId)
            |> filterWhere (#symbol, Id symbol)
            |> fetchOne
        element |> deleteRecord
        redirectTo EditStocklistAction {..}
