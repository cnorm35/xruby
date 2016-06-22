class CustomSetCase < OpenStruct
  def name
    'test_%s' % description.gsub(/ |-/, '_')
  end

  def test_body
    instance_eval section
  end

  def union
    "set1 = CustomSet.new #{set1}
    set2 = CustomSet.new #{set2}
    expected = CustomSet.new(#{expected})
    #{assert_or_refute}_equal set1.union(set2), expected"
  end

  def difference
    "set1 = CustomSet.new #{set1}
    set2 = CustomSet.new #{set2}
    expected = CustomSet.new(#{expected})
    #{assert_or_refute}_equal set1.difference(set2), expected"
  end

  def intersection
    "set1 = CustomSet.new #{set1}
    set2 = CustomSet.new #{set2}
    expected = CustomSet.new #{expected}
      #{assert_or_refute}_equal set2.intersection(set1), expected"
  end

  def add
    "set = CustomSet.new #{set}
    element = #{element}
    expected = CustomSet.new #{expected}
    #{assert_or_refute}_equal set.put(element), expected"
  end

  def equal
    "set1 = CustomSet.new #{set1}
    set2 = CustomSet.new #{set2}
    #{assert_or_refute}_equal set1, set2"
  end

  def disjoint
    "set1 = CustomSet.new #{set1}
    set2 = CustomSet.new #{set2}
    #{assert_or_refute} set1.disjoint? set2"
  end

  def subset
    "set1 = CustomSet.new #{set1}
    set2 = CustomSet.new #{set2}
    #{assert_or_refute} set2.subset? set1"
  end

  def empty
    "set = CustomSet.new #{set}
    #{assert_or_refute}_equal set, CustomSet.new"
  end

  def contains
    "set = CustomSet.new #{set}
    element = #{element}
    #{assert_or_refute} set.member? element"
  end

  def assert_or_refute
    expected ? 'assert' : 'refute'
  end

  def skipped
    index.zero? ? '# skip' : 'skip'
  end
end

CustomSetCases = proc do |data|
  i = 0
  json = JSON.parse(data)
  cases = []
  p json.keys
  (json.keys - ['#']).each do |section|
    json[section]['cases'].each do |row|
      row = row.merge(row.merge('index' => i, 'section' => section))
      cases << CustomSetCase.new(row)
      i += 1
    end
  end
  cases
end
