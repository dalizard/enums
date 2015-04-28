module FakeEnumerable
  def map
    [].tap { |out| each { |e| out << yield(e) } }
  end

  def sort_by
    map { |a| [yield(a), a] }.sort.map { |a| a[1] }
  end

  def select
    [].tap { |out| each { |e| out << e if yield(e) } }
  end

  def reduce(operation_or_value=nil)
    case operation_or_value
    when Symbol
      return reduce { |s,e| s.send(operation_or_value, e) }
    when nil
      acc = nil
    else
      acc = operation_or_value
    end

    each do |a|
      if acc.nil?
        acc = a
      else
        acc = yield(acc, a)
      end
    end

    return acc
  end
end

class FakeEnumerator
  def next
  end

  def with_index
  end

  def rewind
  end
end

class SortedList
  include FakeEnumerable

  def initialize
    @data = []
  end

  def <<(new_element)
    @data << new_element
    @data.sort!

    self
  end

  def each
    if block_given?
      @data.each { |e| yield(e) }
    else
      FakeEnumerator.new(self, :each)
    end
  end
end
