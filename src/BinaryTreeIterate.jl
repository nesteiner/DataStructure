abstract type AbstractBinaryTreeIterator end

struct BFSIterator <: AbstractBinaryTreeIterator
  node::AbstractBinaryNode
  length::Int
end

struct PreOrderIterator <: AbstractBinaryTreeIterator
  node::AbstractBinaryNode
  length::Int
end

struct InOrderIterator <: AbstractBinaryTreeIterator
  node::AbstractBinaryNode
  length::Int
end

struct PostOrderIterator <: AbstractBinaryTreeIterator
  node::AbstractBinaryNode
  length::Int
end

length(iterator::AbstractBinaryTreeIterator) = iterator.length
bfsiterate(tree::AbstractBinaryTree) = BFSIterator(tree.root, length(tree))
preorder(tree::AbstractBinaryTree) = PreOrderIterator(tree.root, length(tree))
inorder(tree::AbstractBinaryTree) = InOrderIterator(tree.root, length(tree))
postorder(tree::AbstractBinaryTree) = PostOrderIterator(tree.root, length(tree))

function iterate(iterator::BFSIterator)
  node = iterator.node
  
  if isnil(node)
    return nothing
  else
    queue = createQueue(AbstractBinaryNode)
    push!(queue, node)
    current = first(queue)
    
    if !isnil(left(current))
      push!(queue, left(current))
    end
    
    if !isnil(right(current))
      push!(queue, right(current))
    end
    
    pop!(queue)
    return current, queue
  end
  
end

function iterate(::BFSIterator, queue::BaseList{AbstractBinaryNode})
  if !isempty(queue)
    current = first(queue)
    
    if !isnil(left(current))
      push!(queue, left(current))
    end
    
    if !isnil(right(current))
      push!(queue, right(current))
    end
    
    pop!(queue)
    return current, queue
  else
    return nothing
  end
  
end

function iterate(iterator::PreOrderIterator)
  node = iterator.node
  if isnil(node)
    return nothing
  else
    stack = createStack(AbstractBinaryNode)
    push!(stack, node)
    
    current = first(stack)
    pop!(stack)

    if !isnil(right(current))
      push!(stack, right(current))
    end
    
    if !isnil(left(current))
      push!(stack, left(current))
    end

    return current, stack
  end
end

function iterate(::PreOrderIterator, stack::BaseList{AbstractBinaryNode})
  if !isempty(stack)
    current = first(stack)
    pop!(stack)

    if !isnil(right(current))
      push!(stack, right(current))
    end
    
    if !isnil(left(current))
      push!(stack, left(current))
    end
    

    return current, stack

  else
    return nothing
  end
end

function iterate(iterator::InOrderIterator)
  node = iterator.node
  if isnil(node)
    return nothing
  else
    stack = createStack(AbstractBinaryNode)
    current = node
    if hasright(current)
      push!(stack, right(current))
    end
    
    while hasleft(current)
      push!(stack, left(current))
      current = left(current)
    end

    return current, stack
  end
end

function iterate(::InOrderIterator, stack::BaseList{AbstractBinaryNode})
  if !isempty(stack)
    temp = current = first(stack)
    pop!(stack)

    if hasright(current)
      push!(stack, right(current))
    end

    while hasleft(current)
      push!(stack, left(current))
      current = left(current)
    end

    return temp, stack
  else
    return nothing
  end
end

function iterate(iterator::PostOrderIterator)
  node = iterator.node
  if isnil(node)
    return nothing
  else
    stack = createStack(AbstractBinaryNode)
    push!(stack, node)
    
    current = first(stack)
    pop!(stack)

    if !isnil(left(current))
      push!(stack, left(current))
    end
    
    if !isnil(right(current))
      push!(stack, right(current))
    end
    
    return current, stack
  end
end

function iterate(::PostOrderIterator, stack::BaseList{AbstractBinaryNode})
  if !isempty(stack) 
    current = first(stack)
    pop!(stack)
    
    if !isnil(left(current))
      push!(stack, left(current))
    end
    
    if !isnil(right(current))
      push!(stack, right(current))
    end
    
    return current, stack
  else
    return nothing
  end
end