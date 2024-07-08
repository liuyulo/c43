module Example (example) where

import Control.Monad.Trans.Except
import Data.Int
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format.ISO8601 (iso8601Show)
import Data.Vector (Vector)
import Hasql.Connection (Connection)
import Hasql.Session (QueryError)
import qualified Statement
import Text.Printf (printf)
import Utils

-- | test run
example :: Connection -> ExceptT QueryError IO ()
example conn = do
  -- today in YYYY-MM-DD format
  today <- runM $ Text.pack . take 10 . iso8601Show <$> getCurrentTime
  value <- runQ conn today Statement.selectToday

  -- next value
  let n = maybe 0 (+ 1) value
  -- add new row
  runQ conn (today, n) Statement.insert
  runM $ printf "Inserted (%s, %d)\n" today n

  -- get all rows and print them
  rows <- runQ conn () Statement.selectAll
  runM $ printRows rows

-- | print each row
printRows :: Vector (Text, Int32) -> IO ()
printRows = mapM_ $ uncurry $ printf "%s\t%d\n"
