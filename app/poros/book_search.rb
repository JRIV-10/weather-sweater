class BookSearch
  attr_reader :destination, 
              :forecast, 
              :total_books_found, 
              :books

  def initialize(destination, forecast, total_books_found, books)
    @destination = destination
    @forecast = forecast
    @total_books_found = total_books_found
    @books = books
    # require 'pry'; binding.pry
  end
end