module Kangaroo
  module Model
    class Field
      module Readonly
        def readonly?
          !!readonly
        end
      
        def eventually_readonly?
          !!readonly || (states.present? && states.any? { |key, value|
            !!value['readonly']
          })
        end
      
        def always_readonly?
          readonly? && (states.blank? || states.all? { |key, value|
            value['readonly'].nil? || value['readonly'] == true
          })
        end
      
        def readonly_in? state
          return true if always_readonly?
        
          s = states && states[state.to_s]
        
          if readonly?
            return true unless s
          
            s['readonly'] == true
          else
            return false unless s
          
            s['readonly'] == false
          end
        end
      end
    end
  end
end