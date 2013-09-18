Yapecafit::App.controllers :setting do
  
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
  
  get :index do
    u = User.where(:twitter_id => current_account.uid.to_i).first
    unless u.type and u.type['forbidden']
      @page_open = true
    else
      @page_open = false
    end
    @comment = u.comment
    render 'setting/index'
  end

end
