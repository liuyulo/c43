module Web.View.Stocklists.Edit where
import Web.View.Prelude
import Data.Text

data EditView = EditView { 
    stocklist :: Stocklist, 
    stocks :: [ListContain], 
    shared :: [User]
}

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Stock List for <span class="text-primary">{currentUser.email}</span></h1>
        <h2>General Information</h2>
        {renderForm stocklist}
        
        <br>
        <h2>Entries</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>Symbol</th>
                    <th>Amount</th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            {forEach stocks renderStock}
            {renderNewStock newRecord}
            </tbody>
        </table>
        <br>
        <h2>Shared Users</h2>

        <table class="table">
            <thead>
            <tr>
                <th>Username</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            {forEach shared renderUser}
            {renderNewUser newRecord}
            </tbody>
        </table>
    |]
      where
        breadcrumb = renderBreadcrumb
            [ breadcrumbLink "Profile" ShowUserAction
            , breadcrumbLink "Stock Lists" StocklistsAction
            , breadcrumbText "Edit Stock List"
            ]

        renderNewUser :: Access -> Html
        renderNewUser access = formFor (access |> set #listId stocklist.id) [hsx|
        <td>
            {(hiddenField #listId)}
            {(textField #username) {disableLabel=True}}
            </td>
            <td> {submitButton {label="Add"}}</td>
        |]

        renderUser :: User -> Html
        renderUser user = [hsx|
        <tr>
            <td>{user.email}</td>
            <td><a href={DeleteAccessAction stocklist.id user.email} class="btn btn-danger js-delete js-delete-no-confirm">Delete</a></td>
        </tr>
        |]

        renderNewStock :: ListContain -> Html
        renderNewStock stock = formFor (stock |> set #listId stocklist.id) [hsx|
            <td>
                {(hiddenField #listId)}
                {(textField #symbol) {disableLabel= True}}
                </td>
            <td>{(numberField #amount) {disableLabel=True}}</td>
            <td>{submitButton {label="Create"}}</td>
        |]


        renderStock :: ListContain -> Html
        renderStock stock = [hsx|
        <tr>
            {renderStockForm stock}
            <td><a href={DeleteListContainAction stocklist.id (please stock.symbol)} class="js-delete js-delete-no-confirm btn btn-danger">Delete</a></td>
        </tr>
        |]

        renderStockForm :: ListContain -> Html
        renderStockForm stock = formForWithOptions stock options [hsx|
            <td>{(textField #symbol) { fieldClass="border-0", additionalAttributes = [ ("readonly", "readonly") ], disableLabel = True }}</td>
            <td>{(numberField #amount) {disableLabel=True} }</td>
            <td>{submitButton { label = "Save" }}</td>
        |]

        options :: FormContext ListContain -> FormContext ListContain
        options formContext = formContext
            |> set #formAction (pathTo UpdateListContainAction {stocklistId = stocklist.id})



renderForm :: Stocklist -> Html
renderForm stocklist = formFor stocklist [hsx|
    {(hiddenField #username)}
    {(textField #listName)}
    {(checkboxField #isPublic)}
    {(textField #category)}
    {submitButton}
|]