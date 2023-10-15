class ChurpPolicy < ApplicationPolicy
  attr_reader :current_user, :churp

  def initialize(current_user, churp)
    super
    @current_user = current_user
    @churp = churp
  end

  def create?
    # current_user.admin?
  end

  def index?
    # current_user.admin?
  end

  def show?
    current_user.admin? || current_user.churps.exists?(id: churp.id)
  end

  def update?
    current_user.admin?
  end

  def destroy?
    current_user.admin?
  end
end