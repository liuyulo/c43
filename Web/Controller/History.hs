module Web.Controller.History where

import Web.Controller.Prelude
import Web.View.History.Index
import Web.View.History.New

import IHP.Log as Log

instance Controller HistoryController where
    action HistoriesAction = do
        (historyQ, pagination) <- query @History
                |> orderByDesc #timestamp
                |> orderByAsc #symbol
                |> paginate
        history <- historyQ |> fetch
        render IndexView { .. }

    action NewHistoryAction = do
        now <- getCurrentTime
        let history = newRecord |> set #timestamp (utctDay $ now)
        render NewView { .. }

    action CreateHistoryAction = do
        let history = newRecord @History
        history
            |> buildHistory
            |> ifValid \case
                Left history -> render NewView { .. }
                Right history -> do
                    hasStock <- query @Stock |> filterWhere (#symbol, textToId history.symbol) |> fetchExists
                    Log.debug $ show hasStock
                    unless hasStock $ do
                        newRecord @Stock |> set #symbol (textToId history.symbol) |> createRecord
                        return ()
                    history <- history |> createRecord
                    setSuccessMessage $ if hasStock then "History created" else "History created (new stock symbol)"
                    redirectTo HistoriesAction

buildHistory history = history
    |> fill @'["timestamp", "open", "high", "low", "close", "volume", "symbol"]
