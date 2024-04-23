class ErrorSerializer
  def self.serialize(error)
    {
      errors:
        {message: error.message}
    }
  end
end 