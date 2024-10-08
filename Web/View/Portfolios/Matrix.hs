module Web.View.Portfolios.Matrix where
import Web.View.Prelude
import Data.List.Split

data MatrixView = MatrixView
    { portfolio :: Portfolio
    , corcov :: [(Id Stock, Id Stock, Double, Double)]
    , start :: Text
    , end :: Text
    }

instance View MatrixView where
    html MatrixView { .. } = [hsx|
        {breadcrumb}

        <h1>Portfolio <span class="text-secondary">{portfolio.portfolioName}</span> ({start} to {end})</h1>

        <form method="GET" action={pathTo (MatrixPorfolioAction portfolio.id start end)}>
        <div class="w-50">
            <label for="start">Start</label>
            <input type="date" name="start" id="start" class="form-control" value={start}/>
            <label for="end">End</label>
            <input type="date" name="end" id="end" class="form-control" value={end}/>
        </div>
        <button class="my-1 btn btn-primary">Refresh</button>
        </form>
{matrix corcov start end}
    |]
        where
            breadcrumb = renderBreadcrumb [
                breadcrumbLink "Profile" ShowUserAction,
                breadcrumbLink "Portfolios" PortfoliosAction,
                breadcrumbText "Portfolio Matrix" ]
