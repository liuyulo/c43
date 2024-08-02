module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController = WelcomeAction deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data UsersController
    = UsersAction
    | NewUserAction
    | ShowUserAction
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)


data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)
data PortfoliosController
    = PortfoliosAction
    | NewPortfolioAction
    | ShowPortfolioAction { portfolioId :: !(Id Portfolio) }
    | CreatePortfolioAction
    | EditPortfolioAction { portfolioId :: !(Id Portfolio) }
    | UpdatePortfolioAction { portfolioId :: !(Id Portfolio) }
    | DeletePortfolioAction { portfolioId :: !(Id Portfolio) }
    deriving (Eq, Show, Data)

data FriendsController
    = FriendsAction
    | NewFriendAction
    | CreateFriendAction
    | RequestAgainAction { userTo :: Text }
    | DeleteFriendAction { userTo :: Text }
    | AcceptFriendAction { userFrom :: Text }
    | RejectFriendAction { userFrom :: Text }
    deriving (Eq, Show, Data)

data StocklistsController
    = StocklistsAction
    | NewStocklistAction
    | ShowStocklistAction { stocklistId :: !(Id Stocklist) }
    | CreateStocklistAction
    | CreateAccessAction
    | DeleteAccessAction {stocklistId :: !(Id Stocklist), userTo :: Text}
    | EditStocklistAction { stocklistId :: !(Id Stocklist) }
    | UpdateStocklistAction { stocklistId :: !(Id Stocklist) }
    | DeleteStocklistAction { stocklistId :: !(Id Stocklist) }
    deriving (Eq, Show, Data)

data ListContainController
    = CreateListContain
    | UpdateListContainAction { stocklistId :: !(Id Stocklist) }
    | DeleteListContainAction{ stocklistId :: !(Id Stocklist), symbol :: Text }
    deriving (Eq, Show, Data)

data ReviewsController
    = CreateReviewAction
    | EditReviewAction { listId :: !(Id Stocklist), username ::Text }
    | UpdateReviewAction { listId :: !(Id Stocklist), username ::Text }
    | DeleteReviewAction { listId :: !(Id Stocklist), username ::Text }
    deriving (Eq, Show, Data)

data TransactionsController
    =  CreateTransactionAction
    deriving (Eq, Show, Data)
