require "csv"
require_relative "recipe"

class Cookbook
  def initialize(csv_file)
    @recipes = []
    @csv_file = csv_file
    load_from_csv
  end

  def add(recipe)
    @recipes << recipe
    save_to_csv
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_to_csv
  end

  def mark_recipe(index)
    @recipes[index].done = true
    save_to_csv
  end

  def all
    @recipes
  end

  private

  def load_from_csv
    CSV.foreach(@csv_file) do |row|
      @recipes << Recipe.new(name: row[0], description: row[1], rating: row[2], done: row[3])
    end
  end

  def save_to_csv
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.done]
      end
    end
  end
end
