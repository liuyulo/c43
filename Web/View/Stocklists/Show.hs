module Web.View.Stocklists.Show where
import Web.View.Prelude
data ShowView = ShowView { stocklist :: Stocklist, stocks :: [(Id Stock, Float, Day)] , reviews::[Review]}

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Stock List: {stocklist.listName}  {renderStat}</h1>
        <p><strong>Owner: </strong> <span class="text-primary">{stocklist.username}</span></p>
        <p><strong>Category:</strong> {stocklist.category}</p>
        <p><strong>Public:</strong> {stocklist.isPublic}</p>

        <h2>Stocks</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Symbol</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>{forEach stocks renderStock}</tbody>
        </table>

        <h2>Reviews</h2>
        <div class="container">
            <div class="row">
                <div class="col">Username</div>
                <div class="col-6">Review</div>
                <div class="col"></div>
            </div>
        {forEach reviews renderReview}
        </div>
        {renderReviewForm newRecord}
    |]
      where
        breadcrumb = renderBreadcrumb
            [ breadcrumbLink "Profile" ShowUserAction
            , breadcrumbLink "Stock Lists" StocklistsAction
            , breadcrumbText "Show Stock List"
            ]

        names :: [Text]
        names = (get #username) <$> reviews
        renderReviewForm :: Review -> Html
        renderReviewForm review
            | currentUser.email `notElem` names  = formFor (review |> set #listId stocklist.id |> set #username currentUser.email) [hsx|
                    {(hiddenField #listId)}
                    {(hiddenField #username)}
                    {(textareaField #content) {fieldLabel ="New Review"}}
                    {submitButton {label="Create View"}}
                |]
            | otherwise = ""

        renderReview Review {..} =[hsx|
            <div class="row">
                <div class="text-primary col">{username}</div>
                <div class="col-6">{content}</div>
                <div class="col">
                    {editButton stocklist username}
                    {deleteButton stocklist username}
                    </div>
            </div> |]
        latest = minimum $ (\(_,_,d)->d) <$> stocks
        renderStat = [hsx|
            <a href={MatrixListAction stocklist.id (show $ addDays (-5) latest) (show latest)} class="float-right btn btn-primary">View Statistics</a>
        |]
deleteButton :: Stocklist -> Text -> Html
deleteButton list username
    | username == currentUser.email || list.username == currentUser.email = [hsx|
    <a href={DeleteReviewAction list.id username} class="btn btn-danger js-delete js-delete-no-confirm">Delete</a>
    |]
    | otherwise = ""

editButton :: Stocklist -> Text -> Html
editButton list username
    | username == currentUser.email = [hsx|
    <a href={EditReviewAction list.id username} class="btn btn-primary">Edit</a>
    |]
    | otherwise = ""

renderStock (symbol, amount, day) = [hsx|
    <tr>
        <td>{renderSymbol symbol day}</td>
        <td>{amount}</td>
    </tr>
|]
