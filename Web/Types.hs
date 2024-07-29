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
    | NewPortfolioAction { userId :: !(Id User)}
    | ShowPortfolioAction { portfolioId :: !(Id Portfolio) }
    | CreatePortfolioAction
    | EditPortfolioAction { portfolioId :: !(Id Portfolio) }
    | UpdatePortfolioAction { portfolioId :: !(Id Portfolio) }
    | DeletePortfolioAction { portfolioId :: !(Id Portfolio) }
    deriving (Eq, Show, Data)

data FriendsController
    = FriendsAction
    | NewFriendAction
    | ShowFriendAction { friendId :: !(Id Friend) }
    | CreateFriendAction
    | EditFriendAction { friendId :: !(Id Friend) }
    | UpdateFriendAction { friendId :: !(Id Friend) }
    | DeleteFriendAction { friendId :: !(Id Friend) }
    deriving (Eq, Show, Data)
