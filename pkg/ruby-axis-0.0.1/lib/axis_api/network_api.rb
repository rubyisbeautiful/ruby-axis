module AxisAPI
  module NetworkAPI
    
    UP            = 1
    UNDEFINED     = 2048
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def statuses
        {
          UP          => :up,
          UNDEFINED   => :undefined
        }
      end
      
    end 
  end
  
end