module GiftsHelper
  # BEVERAGE_CATEGORIES = ['special', 'beer', 'wine', 'cocktail', 'shot']  
  def get_category(category)
    case category
    when 0
     "iconSpecialty.png"
    when 1
      "iconBeer.png"
    when 2
      "iconWine.png"
    when 3
      "iconCocktail.png"
    when 4
      "iconBottle.png"
    end    
  end
  
  def get_category_image(gift)
    category = gift.item.category
    get_category(category)
  end
  
  def get_category_from_item(item)
    category = item.category
    get_category(category)   
  end
  
  
end


