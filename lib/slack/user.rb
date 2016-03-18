module SlackBot
  DEFAULT_ATTRS = [
    :id,
    :team_id,
    :name,
    :deleted,
    :status,
    :color,
    :real_name,
    :tz,
    :tz_label,
    :tz_offset,
    :profile,
    :is_admin,
    :is_owner,
    :is_primary_owner,
    :is_restricted,
    :is_ultra_restricted,
    :is_bot,
    :presence
  ]
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
    
    def method_missing(sym)
      if @data.has_key? sym.to_s
        return @data[sym.to_s]
      elsif DEFAULT_ATTRS.include? sym.to_sym
        return nil
      else
        super
      end
    end
  end
end