# lisp parser for recurse center
# sllewely

class LispNode
  attr_accessor :op, :children, :parent

  @op
  @children
  @parent

  def initialize(op, parent)
    @op = op
    @parent = parent
    @children = []

  end

end

class LispParserTree

  @root

  Op_regex = /\((\+|\-|\w+) /
  Num_regex = /(\d+)[ \)]/

  def parse_string(str)

    # first get the op and make the root
    m = Op_regex.match(str)
    op = m.captures.first
    @root = LispNode.new(op, nil)

    # start of new substring
    i = m.end(0)
    substring = str[i, str.length]

    # puts substring
    #
    # puts op
    # puts @root.inspect

    current_node = @root

    while true do

      num = Num_regex.match(substring)

      puts substring

      if (substring[0] == '(')
        m = Op_regex.match(substring)
        op = m.captures.first

        puts op
        node = LispNode.new(op, current_node)
        current_node.children << node
        current_node = node

        i = m.end(0)
        substring = substring[i, substring.length]

        puts substring

      elsif num
        n = num.captures.first.to_i
        current_node.children << n

        i = m.end(0)
        if (substring[i - 1] == "0")
          current_node = current_node.parent
        end
        substring = substring[i, substring.length]

      else
        # neither op nor number found
        puts 'break'
        break
      end

      # if we encounter an op, create a node
      # add as child to the current node & set to new current
      # if we encounter int, add as child
      # if we encounter ), return to parent node as current

    end

    @root

  end

  def run_example

    # okay gotta traverse a tree

    example = "(first (list 1 (+ 2 3) 9))"

    tree = parse_string(example)

    puts tree.inspect

    # I think I want a tree with node and left, right, possibly more children
    # assumption: comprised of ops and ints
    # assumption: ops have children

    # I could parse with regex
  end

end

lp = LispParserTree.new

lp.run_example
