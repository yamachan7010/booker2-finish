class BookCommentsController < ApplicationController
  def create
    book_comment = current_user.book_comments.new(book_comment_params)
    if book_comment.save
      redirect_back(fallback_location: root_path)  #コメント送信後は、一つ前のページへリダイレクトさせる。
    else
      redirect_back(fallback_location: root_path)  #同上
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    book_comment = @book.book_comments.find(params[:id])
    if current_user.id == book_comment.user.id
      book_comment.destroy
      redirect_back(fallback_location: root_path)
    else
      render "records/show"
    end
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment).merge(book_id: params[:book_id])
  end

  def ensure_correct_user
    book_comment = BookComment.find(params[:id])
    return if book_comment.user_id == current_user.id
    flash[:danger] = '権限がありません'
    redirect_back fallback_location: root_path
  end
end
