module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
        <h2>Getting Started</h2>

        <div style="display: flex; gap: 2em">
            <a class="btn btn-primary" href={NewUserAction}>Create account</a>
            <a class="btn btn-primary" href={NewSessionAction}>Login</a>
        </div>
    |]