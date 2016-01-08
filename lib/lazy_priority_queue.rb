module LazyPriorityQueue

  Node = Struct.new :element,
                    :key,
                    :rank,
                    :parent,
                    :left_child,
                    :right_sibling

  def initialize top_condition, &heap_property
    @roots = []
    @references = {}
    @top_condition = top_condition
    @heap_property = heap_property
  end

  def enqueue element, key
    raise 'The provided element already is in the queue.' if @references[element]

    node = Node.new element, key, 0

    @top = @top ? select(@top, node) : node
    @roots << node
    @references[element] = node

    element
  end

  def change_priority element, new_key
    node = @references[element]

    raise 'Element provided is not in the queue.' unless node


    node.key = new_key
    node = sift_up node
    @top = select(@top, node) unless node.parent

    element
  end

  def peek
    @top and @top.element
  end

  def dequeue
    return unless @top

    element = @top.element
    @references.delete element
    @roots.delete @top

    child = @top.left_child

    while child
      next_child = child.right_sibling
      child.parent = nil
      child.right_sibling = nil
      @roots << child
      child = next_child
    end

    @roots = coalesce @roots
    @top = @roots.inject { |top, node| select top, node }

    element
  end

  def delete element
    change_priority element, @top_condition
    dequeue
  end

  def empty?; @references.empty? end
  def size; @references.size end

  private

  def sift_up node
    return node unless node.parent and @heap_property[node, node.parent]

    node.parent.key, node.key = node.key, node.parent.key
    node.parent.element, node.element = node.element, node.parent.element

    @references[node.element] = node
    @references[node.parent.element] = node.parent

    sift_up node.parent
  end

  def select parent_node, child_node
    @heap_property[parent_node, child_node] ? parent_node : child_node
  end

  def coalesce trees
    coalesced_trees = []

    while tree = trees.pop
      if coalesced_tree = coalesced_trees[tree.rank]
        # This line must go before than...
        coalesced_trees[tree.rank] = nil
        # ...this one.
        trees << add(tree, coalesced_tree)
      else
        coalesced_trees[tree.rank] = tree
      end
    end

    coalesced_trees.compact
  end

  def add node_one, node_two
    raise 'Both nodes must hold the same rank.' if node_one.rank != node_two.rank
    raise 'Both nodes must be roots (no parents).' if node_one.parent || node_two.parent

    adder_node, addend_node = @heap_property[node_one, node_two] ? [node_one, node_two] : [node_two, node_one]

    addend_node.parent = adder_node

    # This line must go before than...
    addend_node.right_sibling = adder_node.left_child
    # ...this one.
    adder_node.left_child = addend_node

    adder_node.rank += 1

    adder_node
  end
end

class MinPriorityQueue
  include LazyPriorityQueue

  def initialize
    super(-Float::INFINITY) { |parent_node, child_node| parent_node.key <= child_node.key }
  end
end

class MaxPriorityQueue
  include LazyPriorityQueue

  def initialize
    super( Float::INFINITY) { |parent_node, child_node| parent_node.key >= child_node.key }
  end
end
