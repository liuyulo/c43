module Web.View.Review.Edit where

import Web.View.Prelude
import Web.Types

data EditView = EditView { review :: Review }

instance View EditView where
    html EditView {..} = [hsx|
        <h1>Edit Review</h1>
        {renderForm review}
    |]

renderForm :: Review -> Html
renderForm review = formFor' review (pathTo (UpdateReviewAction review.listId review.username)) [hsx|
    {(hiddenField #username)}
    {(hiddenField #listId)}
    {(textareaField #content)}
    {submitButton}
|]