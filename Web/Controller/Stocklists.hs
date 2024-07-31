module Web.Controller.Stocklists where

import Web.Controller.Prelude
import Web.View.Stocklists.Edit
import Web.View.Stocklists.Index
import Web.View.Stocklists.New
import Web.View.Stocklists.Show

instance Controller StocklistsController where
    beforeAction = ensureIsUser

    action StocklistsAction = do
        stocklists <- query @Stocklist |> findManyBy #username currentUser.email
        uuids :: [Only UUID] <- sqlQuery "SELECT list_id FROM accesses WHERE username = ?" $ Only currentUser.email
        let listIds = uuids |> map (\(Only uuid) -> Id uuid :: Id Stocklist)
        shared <- fetch listIds
        public <- query @Stocklist
            |> filterWhereNot (#username, currentUser.email)
            |> findManyBy #isPublic True
        render IndexView { .. }

    action NewStocklistAction = do
        let stocklist = newRecord |> set #username currentUser.email
        render NewView { .. }

    action ShowStocklistAction { stocklistId } = do
        stocklist <- fetch stocklistId
        access <- query @Access
            |> filterWhere (#username, currentUser.email)
            |> filterWhere (#listId, stocklistId)
            |> fetchExists
        accessDeniedUnless $ stocklist.isPublic ||  access || stocklist.username == currentUser.email
        stocks <- query @ListContain |> findManyBy #listId stocklistId
        reviews <- query @Review |> findManyBy #listId stocklistId
        render ShowView { .. }

    action EditStocklistAction { stocklistId } = do
        stocklist <- fetch stocklistId
        accessDeniedUnless $ stocklist.username == currentUser.email
        stocks <- query @ListContain |> findManyBy #listId stocklistId
        shared <- fetchSharedUsers stocklistId
        render EditView { .. }

    action UpdateStocklistAction { stocklistId } = do
        stocklist <- fetch stocklistId
        stocklist
            |> buildStocklist
            |> ifValid \case
                Left stocklist -> redirectTo EditStocklistAction { stocklistId }
                Right stocklist -> do
                    stocklist <- stocklist |> updateRecord
                    setSuccessMessage "Stock list updated"
                    redirectTo StocklistsAction

    action CreateStocklistAction = do
        let stocklist = newRecord @Stocklist
        stocklist
            |> buildStocklist
            |> ifValid \case
                Left stocklist -> render NewView { .. }
                Right stocklist -> do
                    stocklist <- stocklist |> createRecord
                    setSuccessMessage "Stock list created"
                    redirectTo StocklistsAction

    action DeleteStocklistAction { stocklistId } = do
        stocklist <- fetch stocklistId
        deleteRecord stocklist
        setSuccessMessage "Stock list deleted"
        redirectTo StocklistsAction

    action DeleteAccessAction {stocklistId, userTo} = do
        access <- query @Access
            |> filterWhere (#username, userTo)
            |> filterWhere (#listId, stocklistId)
            |> fetchOne
        reviews <- query @Review
            |> filterWhere (#username, userTo)
            |> filterWhere (#listId, stocklistId)
            |> fetch
        deleteRecords reviews
        deleteRecord access
        redirectTo EditStocklistAction {..}

    action CreateAccessAction  = do
        let access = newRecord @Access
        access <- access
            |> fill @'["listId", "username"]
            |> createRecord
        setSuccessMessage "Add new user"
        redirectTo EditStocklistAction {stocklistId = access.listId}



buildStocklist stocklist = stocklist
    |> fill @'["username", "listName", "isPublic", "category"]
    |> validateField #listName nonEmpty
    |> validateField #category nonEmpty
