require 'dm-core'
yaml = File.new(Rails.root + 'config' + 'database.yml')
hash = YAML.load(yaml)
DataMapper.setup(:default, hash[Rails.env])