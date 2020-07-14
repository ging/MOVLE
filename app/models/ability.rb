class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    #Users
    can :read, User
    
    unless user.id.nil?
      #Registered users
      can :manage, User do |u|
        u.id === user.id
      end
    end

  end
end
