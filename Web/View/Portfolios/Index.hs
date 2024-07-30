module Web.View.Portfolios.Index where
import Web.View.Prelude

data IndexView = IndexView { portfolios :: [Portfolio], user:: User }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Portfolios for
            <span class="text-primary">{user.email}</span>
            <a href={NewPortfolioAction user.id} class="btn btn-primary ms-4 float-right">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Cash</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach portfolios renderPortfolio}</tbody>
            </table>

        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [
                    breadcrumbLink "Profile" ShowUserAction,
                    breadcrumbText "Portfolios"
                ]

renderPortfolio :: Portfolio -> Html
renderPortfolio portfolio = [hsx|
    <tr>
        <td>{portfolio.portfolioName}</td>
        <td>{portfolio.cash}</td>
        <td><a href={ShowPortfolioAction portfolio.id}>Show</a></td>
        <td><a href={EditPortfolioAction portfolio.id} class="text-muted">Edit</a></td>
        <td><a href={DeletePortfolioAction portfolio.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]