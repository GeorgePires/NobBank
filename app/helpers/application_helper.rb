module ApplicationHelper
  def color_status(status)
    color = status == true ? 'green' : 'red'
    "px-2 py-1 font-semibold leading-tight text-#{color}-700 bg-#{color}-100 rounded-full"
  end

  def color_transaction(transaction_type)
    if transaction_type == 'credit'
      "px-2 py-1 font-semibold leading-tight text-green-700 bg-green-100 rounded-full"
    elsif transaction_type == 'debit'
      "px-2 py-1 font-semibold leading-tight text-red-700 bg-red-100 rounded-full"
    else
      "px-2 py-1 font-semibold leading-tight text-blue-700 bg-blue-100 rounded-full"
    end
  end
end
