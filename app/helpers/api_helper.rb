# Helper methods defined here can be accessed in any controller or view in the application

Yapecafit::App.helpers do
  # def simple_helper_method
  #  ...
  # end
  
  def calculate_bmi(height, weight)
    return (weight / ((height / 100.0)**2.0))
  end
end
