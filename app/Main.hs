{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Monad.Trans.Except
import Data.Int
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Time.Clock (getCurrentTime)
import Data.Time.Format.ISO8601 (iso8601Show)
import Data.Vector (Vector)
import Hasql.Connection (Connection)
import qualified Hasql.Connection as Connection
import Hasql.Session (QueryError)
import qualified Hasql.Session as Session
import Hasql.Statement (Statement)
import qualified Statement
import Text.Printf (printf)
import Prelude

type QueryException = ExceptT QueryError IO

settings :: Connection.Settings
settings = Connection.settings "localhost" 5432 "postgres" "" "mydb"

main :: IO ()
main = do
  Right conn <- Connection.acquire settings
  res <- runExceptT $ example conn
  -- print error if it happens
  either print return res

-- | test run
example :: Connection -> QueryException ()
example conn = do
  -- today in YYYY-MM-DD format
  today <- run $ Text.pack . take 10 . iso8601Show <$> getCurrentTime
  value <- run_ today Statement.selectToday

  -- next value
  let n = maybe 0 (+ 1) value
  -- add new row
  run_ (today, n) Statement.insert
  run $ printf "Inserted (%s, %d)\n" today n

  -- get all rows and print them
  rows <- run_ () Statement.selectAll
  run $ printRows rows
  where
    run_ = runStmt conn

-- | run a SQL statement
runStmt :: Connection -> params -> Statement params a -> QueryException a
runStmt conn params stmt = ExceptT $ Session.run (Session.statement params stmt) conn

-- | run a successful computation
run :: IO a -> QueryException a
run = ExceptT . fmap Right

-- | print each row
printRows :: Vector (Text, Int32) -> IO ()
printRows = mapM_ $ uncurry $ printf "%s\t%d\n"
