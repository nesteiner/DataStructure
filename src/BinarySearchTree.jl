import Base: push!, show, iterate, length, filter, keys
abstract type AbstractTreeNode end

mutable struct TreeNode <: AbstractTreeNode
  data::Int
  left::AbstractTreeNode
  right::AbstractTreeNode
end

mutable struct TreeNil <: AbstractTreeNode end

mutable struct BinarySearchTree
  root::AbstractTreeNode
  compare::Function
  length::Int
end

TreeNode(data::Int) = TreeNode(data, TreeNil(), TreeNil())
BinarySearchTree() = BinarySearchTree(TreeNil(), <, 0)

data(node::TreeNode) = node.data
left(node::TreeNode) = node.left
right(node::TreeNode) = node.right
isleaf(node::TreeNode) = isa(left(node), TreeNil) && isa(right(node), TreeNil)
isnil(node::AbstractTreeNode) = isa(node, TreeNil)
length(tree::BinarySearchTree) = tree.length
assign_data!(node::TreeNode, data::Int) = node.data = data

insert_left!(node::TreeNode, other::AbstractTreeNode) = begin
  node.left = other
  return node
end

insert_right!(node::TreeNode, other::AbstractTreeNode) = begin
  node.right = other
  return node
end

function insert_node!(node::AbstractTreeNode, data::Int, compare::Function = <)
  if isnil(node)
    return TreeNode(data)
  else

    if compare(data, node.data)
      node.left = insert_node!(node.left, data, compare)
    else
      node.right = insert_node!(node.right, data, compare)
    end

  end

  return node
end

push!(tree::BinarySearchTree, data::Int) = begin
  tree.root = insert_node!(tree.root, data, tree.compare)
  tree.length += 1
end


"""
function findfirst(testf::Function, A)
    for (i, a) in pairs(A)
        testf(a) && return i
    end
    return nothing
end
"""
keys(tree::BinarySearchTree) = tree.root

iterate(node::TreeNil) = nothing
function iterate(node::TreeNode)
  queue = AbstractTreeNode[]
  push!(queue, node)
  current = popfirst!(queue)

  if !isnil(current.left)
    push!(queue, current.left)
  end

  if !isnil(current.right)
    push!(queue, current.right)
  end

  return current, queue
end

function iterate(node::TreeNode, queue::Vector{AbstractTreeNode})
  if !isempty(queue)
    current = popfirst!(queue)
    if !isnil(current.left)
      push!(queue, current.left)
    end

    if !isnil(current.right)
      push!(queue, current.right)
    end

    return current, queue

  else
    return nothing
  end
  
end

function iterate(tree::BinarySearchTree)
  if isnil(tree.root)
    return nothing
  else
    queue = AbstractTreeNode[]
    push!(queue, tree.root)
    current = popfirst!(queue)

    if !isnil(current.left)
      push!(queue, current.left)
    end

    if !isnil(current.right)
      push!(queue, current.right)
    end

    return data(current), queue
  end
end

function iterate(tree::BinarySearchTree, queue::Vector{AbstractTreeNode})
  if !isempty(queue)
    current = popfirst!(queue)
    if !isnil(current.left)
      push!(queue, current.left)
    end

    if !isnil(current.right)
      push!(queue, current.right)
    end

    return data(current), queue

  else
    return nothing
  end
end

function filter(f::Function, tree::BinarySearchTree)
  result = []
  for value in tree
    if f(value)
      push!(result, value)
    end
  end

  return result
end

function show(io::IO, node::TreeNode)
  print(io, "treenode: ", data(node))
end

function show(io::IO, node::TreeNil)
  print(io, "treenil")
end