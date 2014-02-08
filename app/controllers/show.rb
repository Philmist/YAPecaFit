#
# vim: fileencoding=utf-8
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
    #@user = User.find(BSON::ObjectId.from_string(params[:id]))
    @user = User.first(:twitter_id => params[:id].to_i)
    if @user #and not (@user.type and @user.type['forbidden'])
      @name = @user[:username]
      @twitter_id = @user[:twitter_id]
      @weights = Weights.all(:twitter_id => @user[:twitter_id], :order => :tweet_id.asc)
      render 'show/user'
    else
      pass
    end
  end

  get :index, :map => '/show/*' do
    render 'show/notfound'
  end

end

