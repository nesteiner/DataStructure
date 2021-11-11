import Base: insert!, keys, popat!, length, eltype
include("BinaryTree.jl")

mutable struct BinarySearchTree{T} <: AbstractBinaryTree
  root::AbstractBinaryNode
  compare::Function
  length::Int
end

eltype(::Type{BinarySearchTree{T}}) where T = T
keys(tree::BinarySearchTree) = tree.root
length(tree::BinarySearchTree) = tree.length

createBSTree(T::DataType, compare::Function = <) = BinarySearchTree{T}(BinaryNil(T), compare, 0)

insert!(tree::BinarySearchTree{T}, data::T) where T = begin
  tree.root = insert!(tree.root, data, tree.compare)
  tree.length += 1
end


# STUB find node
function _find_node(node::BinaryNode{T}, data::T) where T
  backfather = node
  status = 0
  
  while !isnil(node)
    if dataof(node) == data 
      return backfather, status
    else
      backfather = node

      if dataof(node) > data
        node = left(node)
        status = -1
      else
        node = right(node)
        status = 1
      end
    end
  end
  
  return BinaryNil(T)
end

function _popat!(tree::BinarySearchTree{T}, node::BinaryNode{T}) where T
  targetnode = node # target for delete

  backfather, status = _find_node(tree.root, node.data) 
  if isnil(backfather)
    return backfather
  end
  
  if status == -1
    targetnode = left(backfather)
  elseif status == 1
    targetnode = right(backfather)
  elseif status == 0
    targetnode = backfather
  end
  
  # 第一中情况，没有左子树
  if isnil(left(targetnode))
    if backfather != targetnode
      backfather.right = right(targetnode)
    else
      tree.root = right(tree.root)
    end
    
    targetnode = BinaryNil(T)
    return tree.root
  end
  
  # 第二种情况，没有右子树
  if isnil(right(targetnode))
    if backfather != targetnode
      backfather.left = left(targetnode)
    else
      tree.root = left(tree.root)
    end
    
    targetnode = BinaryNil(T)
    return tree.root
  end
  
  # 第三种情况，有左子树和右子树
  backfather = targetnode
  nextnode = left(targetnode)
  while !isnil(right(nextnode)) 
    backfather = nextnode
    nextnode = right(nextnode)
  end
  
  targetnode.data = dataof(nextnode)
  
  if left(backfather) == nextnode
    backfather.left = left(nextnode)
  else
    backfather.right = right(nextnode)
  end
  
  return tree.root
end

popat!(tree::BinarySearchTree, node::BinaryNode) = begin
  tree.length -= 1
  tree.root = _popat!(tree, node)
end