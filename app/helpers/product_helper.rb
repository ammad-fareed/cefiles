module ProductHelper
  def product_share_url(product)
    product_url(product, code: product.share_code)
  end

  def product_share_path(product)
    product_path(product, code: product.share_code)
  end
  def check_product_suppliers(p)
    Product.find(p).all_suppliers.present?
  end


  def eu_countries
    ary = ["Belgium", "Bulgaria", "Czech Republic","Germany", "Denmark", "Estonia", "Ireland"," Greece", "Spain"," France", "Croatia","Italy"," Cyprus", "Latvia"," Lithuania", "Luxembourg", "Hungary", "Malta", "Netherlands","Austria","Poland", "Portugal", "Romania", "Slovenia", "Slovakia", "Finland", "Sweden"," United Kingdom"]
  end
end