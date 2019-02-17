Gem::Specification.new do |s|
  s.name        = 'pry-hier'
  s.version     = '0.0.0'
  s.date        = '2019-02-17'
  s.summary     = 'Shows an ascii art tree of the descendants of a class.'
  s.description = <<~EOS
  Given an class or module name hier command shows an ascii tree (similar to
  the tree shell command) of the descendants of the given class.
  #  TODO: example
  EOS
  s.authors     = ['Paul Sonkoly']
  s.email       = 'sonkoly.pal@gmail.com'
  s.files       = ["lib/pry-hier.rb"]
  s.homepage    = 'http://github.com/phaul/pry-hier'
  s.license     = 'MIT'
end
