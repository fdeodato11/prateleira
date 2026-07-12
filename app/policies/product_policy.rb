class ProductPolicy < ApplicationPolicy
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

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.with_discarded
    end
  end
end
