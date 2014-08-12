# MemoryCache

Cache the result of a ruby block within the ruby process for a finite period. Useful when you want to cache a few things, but don't want to bother with setting up a separate caching service like memcached.

Example:

    # In an initializer
    JsonCache = MemoryCache.new(minutes: 5)

    # In your code
    JsonCache.get(url) do
      raw_json = open(url).read
      JSON.parse(raw_json)
    end
    
The block will be invoked the first time, but any subsequent calls to `get`in the next 5 minutes will ignore the block and just return the same value as the first invocation did.
    

## Installation

Add this line to your application's Gemfile:

    gem 'memory_cache'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install memory_cache

## Usage

Load the gem and create a cache. Specify the cache duration through the initializer. `seconds`, `minutes`, `hours` and `days` are valid options.

    cache = MemoryCache.new(minutes: 2, seconds: 30)

This creates a cache where objects expire after 150 seconds.

If you fail to provide any of the above keys, the initializer will raise an ArgumentError.

Unlike other cache libraries, memory_cache doesn't have a `set` method. Instead the `get` method also acts as a `set` method by passing a block.

    cache.get('the_game')
    => nil
    cache.get('the_game') { "you just lost it".upcase }
    => "YOU JUST LOST IT"
    cache.get('the_game')
    => "YOU JUST LOST IT"

    # 2 minutes and 31 seconds later
    cache.get('the_game')
    => nil

## Keep in mind

MemoryCache does nothing to clean up the cache. Expired values will remain the internal hash of MemoryCache until they are replaced by new invocation with a block.

If your key set is massive or your block return values are fatty, consider calling `clear` on the cache now and then or go for a more advanced caching solution.
