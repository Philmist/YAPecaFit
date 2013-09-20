
# fileencoding: utf-8

Yapecafit::App.controllers :admin do
  
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
    mongo_stats = MongoMapper.database.collection('fs.chunks').stats
    @storage_size = (mongo_stats.storageSize.to_f / 1024.0).round(2)
    render 'admin/index'
  end

  get :userrole do
    @title = "ユーザーロール指定"
    @users = []
    @role = [["users", :users],["admin", :admin]]
    accounts = Account.all()
    for i in accounts
      @users.push [i.name, i.uid]
    end
    render 'admin/userrole'
  end

  post :userrole do
    @title = "ユーザーロール指定結果"
    sel_acc = Account.all(:uid => request[:user])
    unless sel_acc
      redirect url(:admin, :userrole)
    end
    Account.set({:uid => request[:user]}, :role => request[:role])
    @user = Account.first(:uid => request[:user])
    render 'admin/userrole_confirmed'
  end


end
