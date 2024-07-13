module Config where

import IHP.Prelude
import IHP.Environment
import IHP.FrameworkConfig

config :: ConfigBuilder
config = do
    -- See https://ihp.digitallyinduced.com/Guide/config.html
    -- for what you can do here
    -- option (DatabaseUrl "postgresql://postgres@127.0.0.1:5432/c43")
    pure ()