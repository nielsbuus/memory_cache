# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'memory_cache'

Gem::Specification.new do |spec|
  spec.name          = "memory_cache"
  spec.version       = MemoryCache::VERSION
  spec.authors       = ["Niels Buus"]
  spec.email         = ["nielsbuus@gmail.com"]
  spec.summary       = "Cache the results of expensive code for a fixed time in memory. Handy for slow web services."
  spec.description   = "Cache the result of a ruby block within the ruby process for a finite period. Useful when you want to cache a few things, but don't want to bother with setting up a separate caching service like memcached."
  spec.homepage      = "https://github.com/nielsbuus/memory_cache"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

end
