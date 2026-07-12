module Admin
  class BaseController < ApplicationController
    include Pundit::Authorization

    layout "admin"

    before_action :require_authentication
    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :not_authorized

    private

    def not_authorized
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
