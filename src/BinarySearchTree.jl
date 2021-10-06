import Base: push!, show
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
end

TreeNode(data::Int) = TreeNode(data, TreeNil(), TreeNil())
BinarySearchTree() = BinarySearchTree(TreeNil(), <)

isleaf(node::TreeNode) = isa(node.left, TreeNil) && isa(node.right, TreeNil)
isnil(node::AbstractTreeNode) = isa(node, TreeNil)

function insert_node!(node::AbstractTreeNode, data::Int, compare::Function = <)
  if(isnil(node))
    return TreeNode(data)
pppp  else

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
end

function bfsiterate(tree::BinarySearchTree)
  result = []
  queue = []
  push!(queue, tree.root)

  while(!isempty(queue))
    current = first(queue)
    # print(current.data, " ")
    push!(result, current.data)
    if !isnil(current.left)
      push!(queue, current.left)
    end

    if !isnil(current.right)
      push!(queue, current.right)
    end

    popfirst!(queue)
  end

  return result
end
