class HelloDockerController < ApplicationController

  def index

    @display_message = Message.first.display_message

  end


end
