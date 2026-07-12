class CategoryPolicy < ApplicationPolicy
  def index?
    user.administrator?
  end

  def show?
    user.administrator?
  end

  def create?
    user.administrator?
  end

  def new?
    create?
  end

  def update?
    user.administrator?
  end

  def edit?
    update?
  end

  def destroy?
    user.administrator?
  end

  def restore?
    user.administrator?
  end
end
