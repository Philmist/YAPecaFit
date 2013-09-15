
# Helper methods defined here can be accessed in any controller or view in the application

Yapecafit::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def show_project()
    @project = []
    for i in Project.all
      if i.project_type['open']
        @project.push(i)
      end
    end
    @title = "プロジェクト一覧"
  end

end
