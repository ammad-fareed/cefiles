class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      cannot [:approve, :reject], User, company: { approved: true }
      can [:approve, :reject], User, company_id: user.company_id
    elsif user.company.present?
      can [:read, :update], user
      can [:approve, :reject], User, company_id: user.company_id, approved: nil
      can :read, User, company_id: user.company_id
      can [:create, :read, :update], Product, company_id: user.company_id
      can [:read, :update,:edit_card,:update_card], Company, id: user.company_id
      can [:read, :index, :per_product], Directive
      can [:read, :index, :per_product], Standard
      # can :manage, Document, product_id: user.company.product_ids
    end
  end
end
