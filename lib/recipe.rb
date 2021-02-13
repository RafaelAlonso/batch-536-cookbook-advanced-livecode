class Recipe
  attr_reader :name, :description, :rating
  attr_accessor :done

  def initialize(args = {})
    @name = args[:name]
    @description = args[:description]
    @done = args[:done]
    @rating = args[:rating].to_f.round(2)
  end
end
