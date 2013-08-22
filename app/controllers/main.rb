require 'twitter'

Yapecafit::App.controllers :main do
  
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
  
  get :index, :map => '/' do
    render 'main/index'
  end

  get :user, :map => '/user' do
    content_type :text
    current_account.to_yaml
  end

  get :destroy, :map => '/logout' do
    set_current_account(nil)
    redirect url(:main, :index)
  end

  get :auth, :map => '/auth/:provider/callback' do
    auth = request.env["omniauth.auth"]
    account = Account.find(:provider => auth["provider"],
                           :uid => auth["uid"])
    unless account
      account = Account.create_with_omniauth(auth)
      account.save
    end
    set_current_account(account)
    redirect "http://" + request.env["HTTP_POST"] + url(:main, :user)
  end

end
