module Web.View.Stocklists.Matrix where
import Web.View.Prelude

data MatrixView = MatrixView
    { stocklist :: Stocklist
    , corcov :: [(Id Stock, Id Stock, Double, Double)]
    , start :: Text
    , end :: Text
    , symbols::[Id Stock]
    }

instance View MatrixView where
    html MatrixView { .. } = [hsx|
        {breadcrumb}
        <h1>Stock List <span class="text-secondary">{stocklist.listName}</span> ({start} to {end})</h1>

        <form method="GET" action={pathTo (MatrixListAction stocklist.id start end)}>
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
                breadcrumbLink "Stock Lists" StocklistsAction,
                breadcrumbText "Stock List Matrix" ]
