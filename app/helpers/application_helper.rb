module ApplicationHelper
    def flash_class(level)
      case level
        when 'notice' then "bg-blue-500 text-white"
        when 'success' then "bg-green-500 text-white"
        when 'error' then "bg-red-500 text-white"
        when 'alert' then "bg-orange-500 text-white"
      end
    end
  end
  