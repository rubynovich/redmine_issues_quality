class RatingsController < ApplicationController
  unloadable
  layout 'admin'
  before_filter :require_admin
  before_filter :new_rating, :only => [:new, :create]
  before_filter :find_rating, :only => [:edit, :update, :destroy]
  
  helper :sort
  include SortHelper
  
  def index
    @ratings = Rating.all(:order => :position)
  end
  
  def show
    sort_init 'updated_on', 'desc'
    sort_update 'start_date', 'due_date', 'updated_on'

    @scope = Issue.open(false).
      with_rating.
      eql_field(:project_id, params[:project_id]).
      eql_field(:author_id, params[:author_id]).
      eql_field(:assigned_to_id, params[:assigned_to_id]).
      eql_field(:rating_id, params[:id])
      
    @count = @scope.count
    @limit = per_page_option    
    @pages = Paginator.new self, @count, @limit, params[:page]
    @offset ||= @pages.current.offset
    @issues =  @scope.find  :all,
                            :order => sort_clause,
                            :limit  =>  @limit,
                            :offset =>  @offset     
  end
  
  def new
  end
  
  def create
    if @rating.save
      flash[:notice] = l(:notice_successful_create)    
      redirect_to :action => :index
    else    
      render :action => :edit
    end
  end
  
  def edit
  end
  
  def update
    if @rating.update_attributes(params[:rating])
      flash[:notice] = l(:notice_successful_update)        
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
  
  def destroy
    if @rating.destroy
      flash[:notice] = l(:notice_successful_delete)    
    end
    redirect_to :action => :index
  end
    
  private
    def new_rating
      @rating = Rating.new(params[:rating])
    end
    
    def find_rating
      @rating = Rating.find(params[:id])
    end
end
