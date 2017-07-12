class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, :authorize_user!, only: [:edit, :update, :destroy]

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all.order(id: :desc)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @articles }
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_user!
    unless current_user.id == @article.user_id
      flash[:notice] = 'You are not authorized for this action!'
      redirect_to articles_path
    end
  end
end
