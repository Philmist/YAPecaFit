require 'date'
require 'time'
require 'cgi'
require 'yaml'

Yapecafit::App.controllers :project do
  
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
    @project = Project.all
    render 'project/index'
  end

  get :create do
    @res = {}
    render 'project/create'
  end

  post :create do
    @error_list = []
    @res = {}
    @proj_type = ""
    # error check
    unless @res['project_name'] = (CGI.escapeHTML(CGI.unescapeHTML(CGI.escapeHTML(request[:project_name])))) rescue nil
      @error_list.push("プロジェクト名が不正です")
    end
    unless @res['start_date'] = (Date.iso8601(request[:start_date])) rescue nil
      @error_list.push("開始日が不正です")
    end
    unless @res['end_date'] = (Date.iso8601(request[:end_date])) rescue nil
      @error_list.push("終了日が不正です")
    end
    if @res['start_date'] and @res['end_date']
      if @res['start_date'] >= @res['end_date']
        @error_list.push('終了日は開始日よりあとでなくてはなりません')
      end
    end
    if @res['project_open'] and @res['project_open'] == 'true'
      @proj_type = @proj_type + "|" + "open"
    end

    @res['project_type'] = @proj_type
    unless current_account
      @res['twitter_name'] = "てすと"
      @res['twitter_id'] = 7144
    else
      @res['twitter_name'] = current_account.name
      @res['twitter_id'] = current_account.uid
    end
    p = Project.all(:creator_twitter_id => @res['twitter_id'])
    # check unfinished project
    if p
      for i in p
        unless i[:project_type]["completed"]
          @error_list.push("まだ終了していないプロジェクトがあります")
          break
        end
      end
    end
    if @error_list.length > 0
      render 'project/create'
    elsif request['project_confirmed']
      p = Project.new(:project_name => @res['project_name'],
                      :project_type => @res['project_type'],
                      :creator_twitter_id => @res['twitter_id'],
                      :creator_twitter_name => @res['twitter_name'],
                      :start_date => @res['start_date'],
                      :end_date => @res['end_date']
                     )
      p.save
      render 'project/proj_created'
    else
      render 'project/confirm'
    end
  end
end
