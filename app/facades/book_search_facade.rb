class BookSearchFacade
  def self.search_books(location, quantity, forecast)
    all_books = BookSearchService.find_books(location)
    total_books_found = all_books[:numFound]
    destination = location
    books = all_books[:docs]
    forecast = forecast
    BookSearch.new(destination, forecast, total_books_found, books)
  end
end