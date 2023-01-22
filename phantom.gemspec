Gem::Specification.new do |s|
  s.name        = "phantom"
  s.version     = "0.0.1"
  s.summary     = "Phantom!"
  s.description = "Start any other processes along with your minitest testing stack!"
  s.authors     = ["Vivek"]
  s.files       = ["lib/phantom.rb"]
  s.homepage    = "https://github.com/unicorn-av/phantom.git"
  s.license     = "MIT"

  s.add_dependency "minitest", ">= 5.1"
end
