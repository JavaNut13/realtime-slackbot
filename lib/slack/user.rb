module SlackBot
  class User
    def initialize(data)
      @data = data
    end
    
    def to_s
      "#{real_name} (#{name})"
    end
    
    def pretty_name
      real_name || name
    end
    
    def pretty_first_name
      (real_name && real_name.split(' ').first) || name
    end
    
    def [](key)
      @data[key]
    end
    
    # Helper methods for getting info
    def id; @data['id'] end
    def name; @data['name'] end
    def deleted; @data['deleted'] end
    def real_name; @data['real_name'] end
    def admin?; @data['admin'] end
    def owner?; @data['owner'] end
    def primary_owner?; @data['primary_owner'] end
    def bot?; @data['is_bot'] end
    def presence; @data['presence'] end
  end
end