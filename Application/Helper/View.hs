module Application.Helper.View where

import IHP.ViewPrelude
import Data.Text

-- Here you can add functions which are available in all your views

please ::Show a => a -> Text
please = dropAround (== '"') . show