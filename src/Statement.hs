{-# LANGUAGE QuasiQuotes #-}

module Statement (module Statement) where

import Data.Int
import Data.Text
import Data.Vector (Vector)
import Hasql.Statement (Statement (..))
import Hasql.TH

selectToday :: Statement Text (Maybe Int32)
selectToday =
  [maybeStatement| 
    select value :: int from "testtbl" t1
    where 
        name = $1 :: text and 
        value >= all(select value :: int from "testtbl" t2 where t1.name = t2.name)
    |]

selectAll :: Statement () (Vector (Text, Int32))
selectAll =
  [vectorStatement|
    select name :: text, value :: int from "testtbl"|]

insert :: Statement (Text, Int32) ()
insert =
  [resultlessStatement|
    insert into "testtbl" (name, value) values ($1 :: text, $2 ::int) 
    |]
