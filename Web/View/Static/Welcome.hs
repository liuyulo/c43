module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|

        <h1>{renderUser currentUserOrNothing}</h1>

        <h2>Getting Started</h2>

        <ol>
        <li>Create a new user <a href={NewUserAction}>here</a></li>
        <li>Login as a user <a href={NewSessionAction}>here</a></li>
        </ol>
    |]
        where
            renderUser (Just User {email})  = [hsx| Hi {email} <span style="float: right"><a class="js-delete js-delete-no-confirm" href={DeleteSessionAction}>Logout</a></span>|]
            renderUser Nothing = [hsx| Please <a href={NewSessionAction}>login</a>|]