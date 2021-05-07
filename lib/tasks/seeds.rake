include SeedFormatter

def open_yaml file
  path = File.join "db", "seeds", "#{file}.yml"
  YAML.load_file path
end

def exists message
  output message, color: :cyan
end

def find_or_create name, find_lambda, build_lambda
  if find_lambda.()
    exists "#{name} already exists"
  else
    entity = build_lambda.()
    if entity.save
      success "#{name} created"
    else
      error "Failed to create #{name}: #{entity.errors.full_messages}"
    end
  end
end


namespace :db do
  namespace :seed do
    desc "Creates a set of countries in the database"
    task countries: :environment do
      message "Countries"
      open_yaml("countries").each do |country|
        Country.find_or_create_by(name:country)
      end
    end

    desc "Creates a set of CE Categories in the database"
    task ce_categories: :environment do
      message "CE Categories"
      open_yaml("ce_categories").each do |name|
        CeCategory.find_or_create_by(name:name)
      end
    end

    desc "Creates a set of product categories in the database"
    task product_categories: :environment do
      message "Product Categories"
      open_yaml("product_categories").each do |name|
        ProductCategory.find_or_create_by(name:name)
      end
    end

    desc "Creates a set of product industries in the database"
    task industries: :environment do
      message "Industries"
      open_yaml("industries").each do |name|
        Industry.find_or_create_by(name:name)
      end
    end
  end
end