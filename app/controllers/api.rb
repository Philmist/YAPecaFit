# encoding: utf-8
require 'date'
require 'time'
require 'json'

Yapecafit::App.controllers :api do
  
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
  
  get :weight, :provides => :json, :with => :id do
    weight_list = Weights.all(:twitter_id => params[:id].to_i, :order => :tweet_id.asc)
    unless weight_list or weight_list.length == 0
      res = [[0.0, 0]]
    else
      res = []
      for i in weight_list
        t = Time.rfc2822(i[:datetime]) rescue Time.parse(i[:datetime])
        res.push [(t.to_f * 1000), i[:weight]]
      end
    end
    JSON.generate(res)
  end

  get :bmi, :provides => :json, :with => :id do
    weight_list = Weights.all(:twitter_id => params[:id].to_i, :order => :tweet_id.asc)
    u = User.all(:twitter_id => params[:id].to_i).first
    unless weight_list or weight_list.length == 0 or u
      res = [[0.0, 0]]
    else
      res = []
      for i in weight_list
        t = Time.rfc2822(i[:datetime]) rescue Time.parse(i[:datetime])
        res.push [(t.to_f * 1000), calculate_bmi(u.height, i[:weight]).round(2)]
      end
    end
    JSON.generate(res)
  end

end
