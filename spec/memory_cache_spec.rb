require_relative "../lib/memory_cache"
require "timecop"

describe MemoryCache do

  let(:cache) { MemoryCache.new(minutes: 2) }
  let(:slow_object) { double("slow").as_null_object }

  it "caches the result of passed block when reading" do
    expect(slow_object).to receive(:query).exactly(1).times

    3.times do
      cache.get "slow_key" do
        slow_object.query
      end
    end
  end

  it "invokes block when cached object has expired" do
    Timecop.freeze

    expect(slow_object).to receive(:query).exactly(2).times

    cache.get "slow_key" do
      slow_object.query
    end

    Timecop.travel(60) do
      cache.get "slow_key" do
        slow_object.query # Should use the cache
      end
    end

    Timecop.travel(300) do
      cache.get "slow_key" do
        slow_object.query # Should bust the cache
      end
    end

  end

  it "returns the result of the first block until expiration" do
    Timecop.freeze
    result = cache.get("slow_key") { 9000 + 1 }
    expect(result).to eql 9001

    Timecop.travel(60) do
      result = cache.get("slow_key") { "ignore me" }
      expect(result).to eql 9001
    end

    Timecop.travel(180) do
      result = cache.get("slow_key") { "try me" }
      expect(result).to eql "try me"
    end
  end

  it "fails if initiates without duration" do
    expect {
      MemoryCache.new({})
    }.to raise_error(ArgumentError)
  end
  
  context "with no block" do
    
    context "it reads from the cache even if no block is provided" do
      
      it "returns nil when the cache key holds no value" do
        expect(cache.get("something_slow")).to be_nil
      end
      
      it "returns the value, when the cache key holds a value" do
        cache.get("something_slow") { "result" }
        expect(cache.get("something_slow")).to eql "result"        
      end
      
    end
    
  end

end