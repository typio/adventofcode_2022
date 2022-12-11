class Tree
    def initialize(root)
        @root = root
        @answer_sum = 0
        @smallest_dir_size_for_delete = Float::INFINITY
    end

    def root
        @root
    end

    def answer_sum
        @answer_sum
    end

    def smallest_dir_size_for_delete
        @smallest_dir_size_for_delete
    end

    def depthfirst_traversal(mode="print")
        depthfirst_traversal_helper(@root, mode)
    end

    private

    def depthfirst_traversal_helper(node, mode)
        node.children.each do |child|
            depthfirst_traversal_helper(child, mode)
        end

        if mode == "build" and node.type == "dir"
            node.size = node.size_of_children
        elsif mode == "get_solution" and node.type == "dir"
            if node.size <= 100000
                @answer_sum += node.size
            end
        elsif mode == "get_solution2" and node.type == "dir"
            if 30000000 < 70000000 - root.size + node.size and node.size < @smallest_dir_size_for_delete
                @smallest_dir_size_for_delete = node.size
            end
        end

        puts "#{node.name} \t #{node.type} \t #{node.size}"
    end
end 

class Node
    def initialize(name, type, size, parent = nil)
        @name = name
        @type = type
        @size = size
        @parent = parent
        @children = []
    end

    def parent
        @parent
    end

    def name
        @name
    end

    def type
        @type
    end

    def size
        @size
    end

    def children
        @children
    end

    def parent=(new_parent)
        @parent = new_parent
    end

    def size=(new_size)
        @size = new_size
    end

    def add_child(child)
        child.parent = self
        @children << child
    end

    def has_child(name)
        @children.include?(name)
    end

    def size_of_children
        size = 0
        for child in @children do
            size += child.size
        end
        return size
    end
end

root = Node.new("/", "dir", 0, nil)
tree = Tree.new(root)

currentNode = root

File.foreach(ARGV[0]) do |line|
    tokens = line.split(" ")
    if tokens[0] == "$" and tokens[1] =="cd"
        path = tokens[2]
        if path == ".."
            if currentNode.parent != nil
                currentNode = currentNode.parent
            end
        elsif path == "/"
            currentNode = root
        else
            if !currentNode.children.find { |c| c.name == path }
                currentNode.add_child(Node.new(path, "dir", 0))
            end
            currentNode = currentNode.children.find { |c| c.name == path }
        end
    elsif line.start_with?("$ ls")
        
    else
        if tokens[0] == "dir"
            if !currentNode.children.find { |c| c.name == path }
                currentNode.add_child(Node.new(tokens[1], "dir", 0))
            end
        else
            currentNode.add_child(Node.new(tokens[1], "file", tokens[0].to_i))
        end
  end
end

tree.depthfirst_traversal(mode="build")

tree.depthfirst_traversal(mode="get_solution")
puts tree.answer_sum

tree.depthfirst_traversal(mode="get_solution2")
puts tree.smallest_dir_size_for_delete