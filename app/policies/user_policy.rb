class UserPolicy < ApplicationPolicy
  def index?
    user.administrator?
  end

  def show?
    user.administrator?
  end

  def edit?
    user.administrator?
  end

  def update?
    user.administrator? && record != user
  end
end
