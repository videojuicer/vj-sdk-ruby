class BeEqualTo
  def initialize(expectation)
    @expectation = expectation
  end
  
  def matches?(instance)
    @instance = instance
    return @instance == @expectation
  end
  
  def description
    "be equal to #{@expectation}"
  end
  
  def failure_message
    " expected to be equal to #{@expectation}, but was not, and had the following errors:\n #{@instance}"
  end
  
  def negative_failure_message
    " expected to not be valid, but was. (Are you missing a validation?)"
  end
end

def be_equal_to(expectation)
  BeEqualTo.new(expectation)
end
