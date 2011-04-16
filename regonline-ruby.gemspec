Gem::Specification.new do |gem|
  gem.name    = 'regonline-ruby'
  gem.version = '0.0.1'
  
  gem.summary = "A library for accessing a custom report on in RegOnline"
  gem.description = "A library for accessing a custom report on in RegOnline"
  
  gem.authors  = ['Ryan Senior', 'Mario Aquino']
  gem.email    = 'ryan@thestrangeloop.com'
  gem.homepage = 'http://github.com/strangeloop/regonline-ruby'
  
  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*',
                  'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
end

