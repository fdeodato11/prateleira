class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend

  allow_browser versions: :modern

  helper_method :current_user

  private

  def current_user
    Current.session&.user
  end
end
