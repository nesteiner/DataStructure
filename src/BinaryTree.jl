import Base: show, filter, iterate

include("BinaryNode.jl")
abstract type AbstractBinaryTree end
include("BinaryTreeIterate.jl")

function iterate(tree::AbstractBinaryTree)
  if isnil(tree.root)
    return nothing
  else
    queue = AbstractBinaryNode[]
    push!(queue, tree.root)
    current = popfirst!(queue)

    if !isnil(current.left)
      push!(queue, current.left)
    end

    if !isnil(current.right)
      push!(queue, current.right)
    end

    return dataof(current), queue
  end

end

function iterate(::AbstractBinaryTree, queue::Vector{AbstractBinaryNode})
  if !isempty(queue)
    current = popfirst!(queue)
    if !isnil(current.left)
      push!(queue, current.left)
    end

    if !isnil(current.right)
      push!(queue, current.right)
    end

    return dataof(current), queue

  else
    return nothing
  end
end

function show(io::IO, tree::AbstractBinaryTree) 
  for value in tree
    print(io, value, ", ")
  end
end

function filter(f::Function, tree::AbstractBinaryTree)
  result = []
  for value in tree
    if f(value)
      push!(result, value)
    end
  end

  return result
end
