import Base: replace!, iterate, show, insert!, eltype
import Base.==

abstract type AbstractBinaryNode end

mutable struct BinaryNode{T} <: AbstractBinaryNode
  data::T
  left::AbstractBinaryNode
  right::AbstractBinaryNode
end

mutable struct BinaryNil{T} <: AbstractBinaryNode end
BinaryNil(T::DataType) = BinaryNil{T}()
BinaryNode(data::T) where T = BinaryNode(data, BinaryNil(T), BinaryNil(T))

copy(node::BinaryNode{T}) where T = BinaryNode(dataof(node))
copy(::BinaryNil{T}) where T = BinaryNil{T}()
# property
eltype(::BinaryNode{T}) where T = T
==(leftnode::BinaryNode{T}, rightnode::BinaryNode{T}) where T = begin
  return dataof(leftnode) == dataof(rightnode) && 
    left(leftnode) == left(rightnode) &&
    right(leftnode) == right(rightnode)
end

==(leftnode::BinaryNil, rightnode::BinaryNil) = true
==(leftnode::BinaryNode, rightnode::BinaryNil) = false
==(leftnode::BinaryNil, rightnode::BinaryNode) = false

dataof(node::BinaryNode) = node.data
left(node::BinaryNode) = node.left
right(node::BinaryNode) = node.right
hasleft(node::BinaryNode) = !isnil(left(node))
hasright(node::BinaryNode) = !isnil(right(node))
isleaf(node::BinaryNode) = isa(left(node), BinaryNil) && isa(right(node), BinaryNil)
isnil(node::AbstractBinaryNode) = isa(node, BinaryNil)
replace!(node::BinaryNode, data::T) where T = node.data = data

insert!(::BinaryNil{T}, data::T, compare::Function = <) where T = BinaryNode(data)
insert!(node::BinaryNode{T}, data::T, compare::Function = <) where T = begin
  if compare(data, dataof(node)) 
    node.left = insert!(left(node), data, compare)
  else
    node.right = insert!(right(node), data, compare)
  end
  
  return node
end

iterate(::BinaryNil) = nothing

function iterate(node::BinaryNode)
  queue = AbstractBinaryNode[]
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

function iterate(::BinaryNode, queue::Vector{AbstractBinaryNode})
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

show(io::IO, node::BinaryNode) =  print(io, "treenode: ", dataof(node))
show(io::IO, ::BinaryNil) =  print(io, "treenil")