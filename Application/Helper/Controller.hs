module Application.Helper.Controller where

import Generated.Types
import IHP.ControllerPrelude
import Web.Types
import Data.Graph

-- Here you can add functions which are available in all your controllers

fetchSharedUsers :: (?modelContext :: ModelContext) => Id Stocklist -> IO [User]
fetchSharedUsers listId = do
    names :: [Only Text] <- sqlQuery "SELECT username FROM accesses WHERE list_id = ?" (Only listId)
    let users :: [Text] = names |> map (\(Only name) -> name)
    users :: [User] <- query @User |> filterWhereIn (#email, users) |> fetch
    return users

fetchCorCov :: (?modelContext :: ModelContext) => [(Id Stock)] -> Text -> Text -> IO [(Id Stock, Id Stock, Double, Double)]
fetchCorCov stocks start end = sqlQuery"\
\ SELECT x.symbol, y.symbol, corr(x.diff, y.diff), covar_samp(x.diff, y.diff)\
\ FROM stock_changes AS x\
\ JOIN stock_changes AS y ON x.timestamp = y.timestamp\
\ WHERE x.symbol IN ?\
\   and y.symbol IN ?\
\  AND x.timestamp BETWEEN ? AND ?\
\ GROUP BY x.symbol, y.symbol\
\ ORDER BY x.symbol, y.symbol;" (In stocks, In stocks, start,end)

fetchCvarBeta :: (?modelContext :: ModelContext) => Text -> Text -> Text -> IO (Double, Double)
fetchCvarBeta symbol start end = sqlQuerySingleRow "\
        \ SELECT stddev_samp(close) / AVG(close), covar_samp(diff, market_diff) / (SELECT var_samp(market_diff) FROM market_changes)\
        \ FROM stock_changes NATURAL JOIN market_changes\
        \ WHERE symbol = ? AND timestamp BETWEEN ? AND ?" (symbol, start, end)