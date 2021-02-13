class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1} - [#{recipe.done ? 'X' : ' '}] #{recipe.name} (#{recipe.rating} / 5)"
      puts "\t#{recipe.description}"
    end
  end

  def ask_user_for(something)
    puts "Please enter the #{something}"
    print "> "
    gets.chomp
  end

  def ask_user_for_index_to(something)
    puts "Please select a recipe to #{something}"
    gets.chomp.to_i - 1
  end
end
