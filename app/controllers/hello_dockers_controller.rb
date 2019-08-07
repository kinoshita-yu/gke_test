class HelloDockersController < ApplicationController

  def index
    @messages = Message.all

    @test = ENV['APP_DATABASE_HOST']

  end

  def index_add
    Message.create(display_message: params[:display_message]).save
    redirect_to root_path
  end

  def index_destroy
    Message.find(params[:format]).destroy!
    redirect_to root_path
  end

end
