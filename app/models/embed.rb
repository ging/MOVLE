class Embed < ActiveRecord::Base
    include Item
    belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  
    validates_presence_of :owner_id
    validates_presence_of :title
    validate :owner_validation
  
    def as_json(options = {})
        {
          id: id,
          title: title,
          description: description,
          iframe: iframe
        }
    end
      
end
  