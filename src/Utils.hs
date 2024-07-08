module Utils where

import Control.Monad.Trans.Except
import Hasql.Connection (Connection)
import Hasql.Session (QueryError)
import qualified Hasql.Session as Session
import Hasql.Statement (Statement)

-- | monadic generalisation of either
eitherM :: (Monad m) => (e -> m b) -> (a -> m b) -> m (Either e a) -> m b
eitherM l r x = either l r =<< x

-- | run a SQL query
runQ :: Connection -> params -> Statement params a -> ExceptT QueryError IO a
runQ conn params stmt = ExceptT $ Session.run (Session.statement params stmt) conn

-- | run a successful computation
runM :: (Monad m) => m a -> ExceptT e m a
runM = ExceptT . fmap Right
