source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"

gem "rails", "~> 6.1.7", ">= 6.1.7.8"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "bootsnap", ">= 1.4.4", require: false
gem "devise"
gem "devise-jwt"
gem "dotenv"
gem "active_model_serializers"

group :development, :test do
  gem "standard"
  gem "standard-rails"
  gem "pry-byebug"
  gem "rspec-rails", "~> 4.1.2"
  gem "ruby-lsp"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Rabbit
gem "bunny", ">= 2.19.0"
gem "sneakers"

group :test do
  gem "bunny-mock"
  gem "database_cleaner-active_record"
end
