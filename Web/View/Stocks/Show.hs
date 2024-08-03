module Web.View.Stocks.Show where

import Web.View.Prelude

data ShowView = ShowView
  { stock :: Stock
  , pasts :: [(Day, Float)]
  , futures :: [(Day, Float)]
  , cvar :: Double
  , beta :: Double
  , start :: Text
  , end :: Text
  }

instance View ShowView where
  html ShowView {..} = [hsx|
        {breadcrumb}
        <h1>Stock Information for <span class="text-secondary">{please stock.symbol}</span> </h1>
        <form method="GET" action={pathTo (ShowStockAction (please stock.symbol) start end)}>
        <div class="w-50">
            <label for="start">Start</label>
            <input type="date" name="start" id="start" class="form-control" value={start}/>
            <label for="end">End</label>
            <input type="date" name="end" id="end" class="form-control" value={end}/>
        </div>
        <button class="my-1 btn btn-primary">Refresh</button>
        </form>

        <table class="table">
          <tbody>
              <tr><td>Coefficient of Variation</td><td>{cvar}</td></tr>
              <tr><td>Beta</td><td>{beta}</td></tr>
          </tbody>
        </table>
        <h2>Historical Values and Future Predictions</h2>
        <section class="container">
            {forEach pasts renderPast}
            {forEach futures renderFuture}
        </section>
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Profile" ShowUserAction,
            breadcrumbText "Stock Information"
          ]
      h = maximum $ fmap snd $ pasts ++ futures
      w :: Float -> Text
      w v = "width: " ++ show (v / h * 100) ++ "%"
      renderPast :: (Day, Float) -> Html
      renderPast (d, v) = [hsx|
            <div class="row">
                <div class="col-2" style="text-align: right">{d}</div>
                <div class="col">
                <div class="progress w-100">
                <div class="progress-bar" style={w v} role="progressbar" aria-valuenow={show v} aria-valuemax={show h}>
                  </div>
                </div>
                </div>
                  ${v}
            </div>
        |]
      renderFuture :: (Day, Float) -> Html
      renderFuture (d, v) = [hsx|
            <div class="row">
                <div class="col-2" style="text-align: right">{d}</div>
                <div class="col">
                <div class="progress w-100">
                <div class="progress-bar progress-bar-striped" style={w v} role="progressbar" aria-valuenow={show v} aria-valuemax={show h}>
                  </div>
                </div>
                </div>
                  ${v}
            </div>
        |]
