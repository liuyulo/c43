module Web.View.Stocklists.Index where
import Web.View.Prelude

data IndexView = IndexView
    { stocklists :: [Stocklist]
    , shared :: [Stocklist]
    , public :: [Stocklist]}

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Stock Lists for <span class="text-primary">{currentUser.email}</span> <a href={pathTo NewStocklistAction} class="float-right btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Stocklist</th>
                        <th>Category</th>
                        <th>Public</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach stocklists renderStocklist}</tbody>
            </table>
        </div>

        <h2>Accessible Stock Lists</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Owner</th>
                        <th>List name</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach shared renderShared}</tbody>
            </table>
        <h2>Public Stock Lists</h2>
        <table class="table">
                <thead>
                    <tr>
                        <th>Owner</th>
                        <th>List name</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach public renderShared}</tbody>
        </table>
    |]
        where
            breadcrumb = renderBreadcrumb
                [
                    breadcrumbLink "Profile" ShowUserAction,
                    breadcrumbText "Stock Lists"
                ]

renderShared :: Stocklist -> Html
renderShared list = [hsx|
    <tr>
        <td>{list.username}</td>
        <td>{list.listName}</td>
        <td><a href={ShowStocklistAction list.id} class="btn btn-primary">View</a></td>
    </tr>
|]

renderStocklist :: Stocklist -> Html
renderStocklist stocklist = [hsx|
    <tr>
        <td>{stocklist.listName}</td>
        <td>{stocklist.category}</td>
        <td>{stocklist.isPublic}</td>
        <td><a href={ShowStocklistAction stocklist.id} class="btn btn-primary">Show</a></td>
        <td><a href={EditStocklistAction stocklist.id} class="btn btn-primary">Edit</a></td>
        <td><a href={DeleteStocklistAction stocklist.id} class="btn btn-danger js-delete js-delete-no-confirm">Delete</a></td>
    </tr>
|]