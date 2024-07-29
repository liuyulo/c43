module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|

        <h1>{renderUser currentUserOrNothing}</h1>

        <h2>Getting Started</h2>

        <ol>
        <li><a href={NewUserAction}>Create</a> a new user</li>
        <li><a href={NewSessionAction}>Login</a> as a user</li>
        </ol>
        <h2>User Profile</h2>

        {renderProfile currentUserOrNothing}
    |]
        where
            renderUser (Just User {email})  = [hsx| Hi {email} <span style="float: right"><a class="js-delete js-delete-no-confirm" href={DeleteSessionAction}>Logout</a></span>|]
            renderUser Nothing = [hsx| Please login|]
            renderProfile (Just User {id}) = [hsx| Go to my <a href={ShowUserAction id}>profile</a> |]
            renderProfile Nothing = [hsx| Nothing to see here |]