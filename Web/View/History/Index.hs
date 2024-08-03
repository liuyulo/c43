module Web.View.History.Index where
import Web.View.Prelude

data IndexView = IndexView { history :: [History], pagination :: Pagination }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewHistoryAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Timestamp</th>
                        <th>Open</th>
                        <th>High</th>
                        <th>Low</th>
                        <th>Close</th>
                        <th>Volume</th>
                        <th>Symbol</th>
                    </tr>
                </thead>
                <tbody>{forEach history renderHistory}</tbody>
            </table>
            {renderPagination pagination}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbText [hsx| <a href="/">Welcome</a> |]
                    ,breadcrumbLink "Histories" HistoriesAction
                ]

renderHistory :: History -> Html
renderHistory history = [hsx|
    <tr>
        <td>{history.timestamp}</td>
        <td>{history.open}</td>
        <td>{history.high}</td>
        <td>{history.low}</td>
        <td>{history.close}</td>
        <td>{history.volume}</td>
        <td>{please $ history.symbol}</td>
    </tr>
|]