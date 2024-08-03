module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)
import IHP.LoginSupport.Middleware
import Web.Controller.Sessions

-- Controller Imports
import Web.Controller.History
import Web.Controller.Transactions
import Web.Controller.Reviews
import Web.Controller.ListContain
import Web.Controller.Stocklists
import Web.Controller.Friends
import Web.Controller.Portfolios
import Web.Controller.Users
import Web.Controller.Static
import Web.Controller.Stocks

instance FrontController WebApplication where
    controllers =
        [ startPage WelcomeAction
        -- Generator Marker
        , parseRoute @HistoryController
        , parseRoute @TransactionsController
        , parseRoute @StocksController
        , parseRoute @ReviewsController
        , parseRoute @ListContainController
        , parseRoute @StocklistsController
        , parseRoute @FriendsController
        , parseRoute @PortfoliosController
        , parseRoute @UsersController
        , parseRoute @SessionsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User
