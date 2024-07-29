module Web.View.Portfolios.Show where
import Web.View.Prelude

data ShowView = ShowView { portfolio :: Portfolio, user :: User }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Portfolio</h1>
<table>
    <tbody>
        <tr>
            <td><strong>Owner</strong></td>
            <td>{user.email}</td>
        </tr>
        <tr>
            <td><strong>Name</strong></td>
            <td>{portfolio.portfolioName}</td>
        </tr>
        <tr>
            <td><strong>Cash amount</strong></td>
            <td>{portfolio.cash}</td>
        </tr>
    </tbody>
</table>

    |]
        where
            breadcrumb = renderBreadcrumb
                [
                    breadcrumbLink "Profile" ShowUserAction {userId = user.id},
                    breadcrumbLink "Portfolios" PortfoliosAction ,
                    breadcrumbText "Portfolio"
                ]
