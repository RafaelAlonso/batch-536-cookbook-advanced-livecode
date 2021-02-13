require_relative 'view'
require_relative 'recipe'
require_relative 'scrape_service'

require 'nokogiri'
require 'open-uri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    display_recipes
  end

  def create
    name = @view.ask_user_for("name")
    description = @view.ask_user_for("description")
    rating = @view.ask_user_for("rating")

    recipe = Recipe.new(name: name, description: description, rating: rating, done: false)
    @cookbook.add(recipe)
  end

  def destroy
    display_recipes
    index = @view.ask_user_for_index_to('delete')
    @cookbook.remove_recipe(index)
    display_recipes
  end

  def import_from_internet
    # Ask a user for a keyword to search
    keyword = @view.ask_user_for('keyword you want to search online')

    # Make an HTTP request to the recipe's website with our keyword
    url = "https://www.allrecipes.com/search/results/?wt=#{keyword}"
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')

    # Parse the HTML document to extract the first 5 recipes suggested and store them in an Array
    # pegamos 5 cards de receitas
    recipes_from_internet = []

    recipe_cards = doc.search('.fixed-recipe-card').take(5)

    # para cada card de receita que temos
    recipe_cards.each do |card|
      # pegar o nome da receita de dentro do card
      name = card.search('.fixed-recipe-card__title-link').first.text.strip
      # pegar a descricao da receita de dentro do card
      desc = card.search('.fixed-recipe-card__description').first.text.strip
      # pegar o rating da receita de dentro do card
      rate = card.search('.stars').attribute('data-ratingstars').value

      recipes_from_internet << Recipe.new(name: name, description: desc, rating: rate, done: false)
    end

    recipes_from_internet

    # Display them in an indexed list
    @view.display(recipes_from_internet)

    # Ask the user which recipe they want to import (ask for an index)
    index = @view.ask_user_for_index_to('import')

    # Add it to the Cookbook
    @cookbook.add(recipes_from_internet[index])
  end

  def mark_as_done
    # mostrar a lista por usuario
    display_recipes

    # perguntar o indice da receita que ele quer marcar
    index = @view.ask_user_for_index_to('mark as done')

    # marcar a receita correta
    @cookbook.mark_recipe(index)

    # mostrar a lista de novo
    display_recipes
  end

  private

  def display_recipes
    recipes = @cookbook.all
    @view.display(recipes)
  end
end
