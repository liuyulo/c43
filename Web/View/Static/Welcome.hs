module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
        <h1>{renderUser currentUserOrNothing}</h1>
        {renderP currentUserOrNothing}
    |]
        where
            renderUser (Just User {email})  = [hsx| You are logged in as
            <span class="text-primary">{email}</span>
            <a class="btn btn-primary js-delete js-delete-no-confirm float-right" href={DeleteSessionAction}>Logout</a>|]
            renderUser Nothing = "Getting Started"
            renderP (Just User { id }) = [hsx| View <a href={ShowUserAction}>profile</a> |]
            renderP Nothing = [hsx|
                <div style="display: flex; gap: 2em">
                <a class="btn btn-primary" href={NewUserAction}>Create account</a>
                <a class="btn btn-primary" href={NewSessionAction}>Login</a>
                <a class="btn btn-primary" href={HistoriesAction}>History</a>
            </div>
            |]