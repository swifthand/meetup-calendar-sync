class RootController < ApplicationController

  def index
    @page = RootPage.new
  end

end
