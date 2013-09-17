
# Helper methods defined here can be accessed in any controller or view in the application

Yapecafit::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def show_project()
    @project = []
    for i in Project.sort(:created_at.desc)
      if i.project_type['open']
        @project.push(i)
      end
      if current_account
        if (not i.project_type['open']) and (i.creator_twitter_id == current_account.uid.to_i or current_account.role["admin"])  # uid is STRING, and author or admin can see forbidden project
          @project.push(i)
        end
      end
    end
    @title = "プロジェクト一覧"
  end

end
