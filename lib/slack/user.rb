module SlackBot
  class User
    def initialize(data)
      @data = data
    end
    
    def to_s
      "@#{name}"
    end
    
    def pretty_name
      real_name || name
    end
    
    def pretty_first_name
      first_name || name
    end
    
    def [](key)
      @data[key]
    end
    
    # Helper methods for getting info
    def profile; @data['profile'] || {} end
    def real_name; profile['real_name'] end
    def first_name; profile['first_name'] end
    def last_name; profile['last_name'] end
    
    def id; @data['id'] end
    def name; @data['name'] end
    def deleted; @data['deleted'] end
    def admin?; @data['admin'] end
    def owner?; @data['owner'] end
    def primary_owner?; @data['primary_owner'] end
    def bot?; @data['is_bot'] end
    def presence; @data['presence'] end
  end
end