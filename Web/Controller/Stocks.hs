module Web.Controller.Stocks where

import Web.Controller.Prelude
import Web.View.Stocks.Show

instance Controller StocksController where
  action ShowStockAction {symbol, start, end} = do
    stock <- query @Stock |> findBy #symbol (param "symbol")
    pasts <- sqlQuery "SELECT timestamp, close FROM history WHERE symbol = ? AND timestamp BETWEEN ? AND ? ORDER BY timestamp ASC" $ (symbol, start, end)
    futures <- sqlQuery "SELECT date, price FROM predictions WHERE symbol = ? AND date BETWEEN ? AND ? ORDER BY date ASC" $ (symbol, start, end)
    let latest  = maximum $ fmap fst pasts
    (cvar, beta) <- fetchCvarBeta symbol start $ show latest
    render ShowView {..}
