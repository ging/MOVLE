class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    #Users
    can :read, User
    can :read, [Presentation, Pdfp, Document, Scormfile, Embed, Link] do |r|
      r.public?
    end
    
    unless user.id.nil?
      #Registered users
      can :manage, User do |u|
        u.id === user.id
      end

      can :create, [Presentation, Pdfp, Document, Scormfile, Embed, Link]

      can :manage, [Presentation, Pdfp, Document, Scormfile, Embed, Link] do |p|
        p.owner_id === user.id
      end
    end

  end
end
