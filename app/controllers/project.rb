#
# vim: fileencoding=utf-8
require 'date'
require 'time'
require 'cgi'

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
    show_project()
    render 'project/index'
  end

  get :show, :with => [:id] do
    @project = Project.find(BSON::ObjectId.from_string(params[:id])
    @title = @project.project_name + " | " + "プロジェクト詳細"
    unless @project
      pass
    end
    render 'project/list'
  end

  get :show do
    @alert = "そのプロジェクトは存在しません"
    show_project()
    render 'project/index'
  end

  get :create do
    @res = {}
    @title = "プロジェクト作成"
    render 'project/create'
  end

  post :create do
    @error_list = []
    @res = {}
    @proj_type = "|"
    @title = "プロジェクト作成"

    # error check
    unless @res['project_name'] = (CGI.escapeHTML(CGI.unescapeHTML(CGI.escapeHTML(request[:project_name])))) rescue nil
      @error_list.push("プロジェクト名が不正です")
    end
    unless @res['start_date'] = (DateTime.iso8601(request[:start_date]).new_offset("+0900")) rescue nil
      @error_list.push("開始日が不正です")
    end
    unless @res['end_date'] = (DateTime.iso8601(request[:end_date]).new_offset("+0900")) rescue nil
      @error_list.push("終了日が不正です")
    end
    if @res['start_date'] and @res['end_date']
      if @res['start_date'] >= @res['end_date']
        @error_list.push('終了日は開始日よりあとでなくてはなりません')
      end
    end
    if request[:project_open] and request[:project_open]
      @proj_type = @proj_type + "open|"
    end
    @res['project_type'] = @proj_type

    unless current_account  # test code
      @res['twitter_name'] = "てすと"
      @res['twitter_id'] = 7144
    else
      @res['twitter_name'] = current_account.name
      @res['twitter_id'] = current_account.uid.to_i
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
      pj = Project.new(:project_name => @res['project_name'],
                      :project_type => @res['project_type'],
                      :creator_twitter_id => @res['twitter_id'],
                      :creator_twitter_name => @res['twitter_name'],
                      :start_date => @res['start_date'],
                      :end_date => @res['end_date'],
                      :project_results => []
                     )
      if pj.save
        puts "New project created."
        render 'project/proj_created'
      else
        @error_list = ["プロジェクトの作成に失敗しました"]
        render 'project/create'
      end
    else
      render 'project/confirm'
    end
  end
end

