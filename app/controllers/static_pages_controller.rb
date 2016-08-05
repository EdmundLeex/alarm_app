class StaticPagesController < ApplicationController
  before_action :authenticate_user!

  def test
  end
end
