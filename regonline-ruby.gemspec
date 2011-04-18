Gem::Specification.new do |gem|
  gem.name    = 'regonline-ruby'
  gem.version = '0.0.1'
  
  gem.summary = "A library for accessing a custom report on in RegOnline"
  gem.description = "A library for accessing a custom report on in RegOnline"
  
  gem.authors  = ['Ryan Senior', 'Mario Aquino']
  gem.email    = 'ryan@thestrangeloop.com'
  gem.homepage = 'http://github.com/strangeloop/regonline-ruby'
  
  gem.files = Dir['Rakefile', '{bin,lib,man,test,spec}/**/*',
                  'README*'] & `git ls-files -z`.split("\0")
end

