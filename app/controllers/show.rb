Yapecafit::App.controllers :show do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :index, :with => :id do
    @user = User.first(:twitter_id => params[:id].to_i)
    if @user
      @name = @user[:username]
      @twitter_id = @user[:twitter_id]
      @weights = Weights.all(:twitter_id => @user[:twitter_id], :order => :tweet_id.asc)
      render 'show/user'
    end
  end

end
