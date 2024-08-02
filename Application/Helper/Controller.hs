module Application.Helper.Controller where

import Generated.Types
import IHP.ControllerPrelude
import Web.Types

-- Here you can add functions which are available in all your controllers

fetchSharedUsers :: (?modelContext :: ModelContext) => Id Stocklist -> IO [User]
fetchSharedUsers listId = do
    names :: [Only Text] <- sqlQuery "SELECT username FROM accesses WHERE list_id = ?" (Only listId)
    let users :: [Text] = names |> map (\(Only name) -> name)
    users :: [User] <- query @User |> filterWhereIn (#email, users) |> fetch
    return users

-- fetchHoldings :: Id Portfolio -> IO [(Id Stock, Int, Float)]
-- fetchHoldings portId = do
--     holds :: [(Id Stock, Int, Float)] <- sqlQuery "SELECT symbol, amount, value FROM portfolio_holds NATURAL JOIN stocks WHERE portfolio_id = ?" (Only portId)
--     return holds
