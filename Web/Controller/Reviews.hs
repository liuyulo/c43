module Web.Controller.Reviews where

import Web.Controller.Prelude
import Web.View.Review.Edit

instance Controller ReviewsController where
    beforeAction = ensureIsUser

    action EditReviewAction { listId, username } =do
        review <- queryReview username listId
        accessDeniedUnless (username == currentUser.email)
        render EditView {..}

    action UpdateReviewAction { listId, username} = do
        review <- queryReview username listId
        review <- review |> buildReview |> updateRecord
        setSuccessMessage "Review updated"
        redirectTo ShowStocklistAction { stocklistId = review.listId }

    action CreateReviewAction = do
        let review = newRecord @Review
        review <- review |> buildReview |> createRecord
        setSuccessMessage "Review created"
        redirectTo ShowStocklistAction { stocklistId = review.listId}

    action DeleteReviewAction { listId, username} = do
        review <- query @Review
            |> filterWhere (#listId, listId)
            |> filterWhere (#username, username)
            |> fetchOne
        deleteRecord review
        setSuccessMessage "Review deleted"
        redirectTo ShowStocklistAction { stocklistId = review.listId}

queryReview username listId = query @Review
    |> filterWhere (#username, username)
    |> filterWhere (#listId, listId)
    |> fetchOne

buildReview review = review
    |> fill @'["listId", "username", "content"]
