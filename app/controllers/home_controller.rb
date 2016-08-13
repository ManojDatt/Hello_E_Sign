class HomeController < ApplicationController
  def index
    # @account = HelloSign.get_account
  end

  def callbacks
  #    HelloSignEvents.new(params[:json]).process
  #   	respond_to do |format|
  #       format.json { render json: 'Hello API Event Received', status: 200 }
	 # end
     render :text => 'Hello API Event Received'
  end
end
