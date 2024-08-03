module Application.Helper.View where
import Database.PostgreSQL.Simple.Time

import IHP.ViewPrelude
import Generated.Types
import Web.Controller.Prelude
import Data.List.Split (chunksOf)
import Data.Text (dropAround)
-- Here you can add functions which are available in all your views

please ::Show a => a -> Text
please = dropAround (== '"') . show

renderSymbol_ :: Id Stock -> Text -> Text -> Html
renderSymbol_ symbol start end = [hsx|
        <a href={ShowStockAction (please symbol) start end}>{please symbol}</a>
    |]

renderSymbol :: Id Stock -> Day -> Html
renderSymbol symbol day = renderSymbol_ symbol (show $ addDays (-10) day) (show $ addDays 10 day)

matrix :: [(Id Stock, Id Stock, Double, Double)] -> Text -> Text -> Html
matrix corcov start end = [hsx|
<div class="text-secondary">(Some symbols might not be available due to insufficient data)</div>
        <h2>Correlations</h2>
        <table class="table">
            <tbody>
                <tr>
                    <td></td>
                    {forEach symbols renderS}
                </tr>
                {forEach (chunksOf (length symbols) cors) renderR}
            </tbody>
        </table>
        <h2>Covariances</h2>
        <table class="table">
            <tbody>
                <tr>
                    <td></td>
                    {forEach symbols renderS}
                </tr>
                {forEach (chunksOf (length symbols) covs) renderR}
            </tbody>
        </table>
    |]
  where
    cors, covs :: [(Id Stock, Id Stock, Double)]
    cors = (\(s1,s2,cor,_) -> (s1,s2,cor)) <$> corcov
    covs = (\(s1,s2,_,cov) -> (s1,s2,cov)) <$> corcov
    symbols = fmap (\(symbol:_) -> symbol) $ group $ (\(symbol, _, _, _) -> symbol) <$> corcov

    renderS symbol = [hsx| <td>{renderSymbol_ symbol start end}</td> |]
    renderR row@((symbol,_,_):_) = [hsx|
        <tr>
            {renderS symbol}
            {forEach row renderP}
        </tr>
    |]

    renderP (_,_,value) = [hsx|
        <td>{value}</td>
    |]