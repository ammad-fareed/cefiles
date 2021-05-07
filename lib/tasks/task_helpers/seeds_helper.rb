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