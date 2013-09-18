# coding: utf-8
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
    @title = "トップページ"
    @updatetime = Getlog.all.last.created_at.to_s
    render 'main/index'
  end

  get :about, :map => '/about' do
    @title = "YAPecaFitについて"
    render 'main/about'
  end

  get :user, :map => '/user' do
    #current_account.to_yaml
    @weight_list = []
    if Weights.first(:twitter_id => current_account.uid.to_i)
      @weight_list = Weights.all(:twitter_id => current_account.uid.to_i, :order => :tweet_id.desc)
    end
    @title = (self.current_account.name ? (current_account.name + "さんの") : "名無しさんの" ) + "記録"
    @user_twitter_id = current_account.uid.to_s
    @name = (self.current_account.name ? (current_account.name) : "名無し" ) 
    u = User.first(:twitter_id => current_account.uid.to_i)
    @type = u.type ? u.type : ""
    @comment = u.comment ? u.comment : ""
    render 'main/user'
  end

  get :destroy, :map => '/logout' do
    set_current_account(nil)
    redirect url(:main, :index)
  end

  get :auth, :map => '/auth/:provider/callback' do
    auth = request.env["omniauth.auth"]
    account = Account.first(:provider => auth["provider"],
                            :uid => auth["uid"])
    unless account
      account = Account.create_with_omniauth(auth)
      tmpcl = Twitter::Client.new(:consumer_secret => Yapecafit::App.staff_consumer_secret,
                                  :consumer_key => Yapecafit::App.staff_consumer_key,
                                  :oauth_token => Yapecafit::App.staff_access_token,
                                  :oauth_secret => Yapecafit::App.staff_access_secret)
      begin
        account.name = tmpcl.user(auth["uid"].to_i).name
      rescue => e
        account.name = ""
      end
      account.save
    end
    set_current_account(account)
    redirect "http://" + request.env["HTTP_HOST"] + url(:main, :user)
  end

end
