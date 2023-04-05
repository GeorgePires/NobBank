module ApplicationHelper
  def color_status(status)
    color = status == true ? 'green' : 'red'
    "px-2 py-1 font-semibold leading-tight text-#{color}-700 bg-#{color}-100 rounded-full"
  end
end
