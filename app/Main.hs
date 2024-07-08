{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Monad.Trans.Except
import Example
import Hasql.Connection (Connection)
import qualified Hasql.Connection as Connection
import Utils
import Prelude

settings :: Connection.Settings
settings = Connection.settings "localhost" 5432 "postgres" "" "mydb"

main :: IO ()
main = eitherM pr run $ Connection.acquire settings
  where
    pr Nothing = putStrLn "Unknown Error Happened"
    pr (Just err) = print err
    -- either print error or run example
    run :: Connection -> IO ()
    run conn = eitherM print return $ runExceptT $ example conn
