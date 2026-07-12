class DashboardPolicy < ApplicationPolicy
  def show?
    user.administrator?
  end
end
