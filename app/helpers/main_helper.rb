# Helper methods defined here can be accessed in any controller or view in the application
require 'moji'

Yapecafit::App.helpers do
  # def simple_helper_method
  #  ...
  # end

  def utc_to_jststr(t)
    DateTime.rfc2822( t.rfc2822 ).new_offset("+0900").rfc2822
  end
end
