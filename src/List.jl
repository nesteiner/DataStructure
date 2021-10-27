import Base: push!, popat!, pop!,
  show, iterate,
  isempty, length,
  first, last,
  replace!, filter, keys

include("ListNode.jl")

mutable struct List{T}
  dummy::DummyNode
  current::ListNode
  length::Int

  insert_fn::Function
  remove_fn::Function
  
  List(E::DataType) = begin
    list = new{E}()
    list.current = list.dummy = DummyNode(E)
    list.length = 0
    
    list.insert_fn = insert_data_next_1!
    list.remove_fn = remove_next!
    
    return list
  end

  List(E::DataType, insert_fn::Function, remove_fn::Function) = begin
    list = List(E)
    list.insert_fn = insert_fn
    list.remove_fn = remove_fn

    return list
  end
end

keys(list::List) = next(list.dummy)

function push!(list::List{T}, data::T) where T
  list.length += 1
  list.insert_fn(list.current, data)
  
  list.current = next(list.current)
end

# ATTENTION to test push_next!, you should override the `findfirst` first.

function push_next!(list::List{T}, node::ListCons, data::T) where T
  list.length += 1
  unlink = next(node)
  list.insert_fn(node, data)
  newnode = next(node)
  # FIXME here, I need to insert node
  # list.insert_fn(newnode, unlink)
  insert_next!(newnode, unlink)
end

function pop!(list::List) 
  list.length -= 1
  prevnode = prev(list.current, list.dummy, list.current)
  list.remove_fn(prevnode)
  list.current = prevnode
end

function popat!(list::List, iter::ListNext)
  list.length -= 1
  prevnode = prev(iter, list.dummy, list.current)
  unlinknode = next(iter)
  list.remove_fn(prevnode)
  insert_next!(prevnode, unlinknode)
end

replace!(node::ListCons, data::T) where T = node.data = data

function iterate(list::List)
  firstnode = next(list.dummy)
  if isa(firstnode, NilNode)
    return nothing
  else
    return dataof(firstnode), next(firstnode)
  end
end

function iterate(::List, state::ListNode)
  if isa(state, NilNode)
    return nothing
  else
    return dataof(state), next(state)
  end
end

first(list::List) = begin
  firstnode = next(list.dummy)
  if isa(firstnode, NilNode)
    @error "there is no data in list"
  else
    return dataof(firstnode)
  end
end

last(list::List) = begin
  lastnode = list.current
  if isa(lastnode, NilNode)
    @error "there is no data in list"
  else
    return dataof(lastnode)
  end
end

isempty(list::List) = list.length == 0
length(list::List) = list.length

function show(io::IO, list::List)
  print(io, "list: ")
  for value in list
    print(io, value, ' ')
  end
end

function filter(testf::Function, list::List{T}) where T
  result = List{T}()

  for data in list
    if testf(data)
      push!(result, data)
    end
  end

  return result
end




























# abstract type ListNode end
# abstract type ListNext <: ListNode end
# abstract type ListCons <: ListNext end

# import Base: push!, popat!, pop!,
#   show, iterate,
#   isempty, length,
#   first, last,
#   replace!, filter, keys

# mutable struct NilNode{T} <: ListNode end

# mutable struct DummyNode{T} <: ListNext
#   next::ListNode

#   DummyNode(T::DataType) = new{T}(NilNode{T}())
# end

# mutable struct ConsNode{T} <: ListCons
#   data::T
#   next::ListNode

#   ConsNode(data::T) where T = new{T}(data, NilNode{T}())
# end

# # TODO their interface
# next(node::ListNext) = node.next
# dataof(node::ListCons) = node.data
# _insert_next!(node::ListNext, next::ListNode) = node.next = next
# _remove_next!(node::ListNext) = begin
#   target = next(node)
#   unlinked = next(target)
#   node.next = unlinked
# end


# mutable struct List{T}
#   dummy::DummyNode{T}
#   current::ListNode
#   length::Int
#   List{T}() where T = begin
#     list = new()
#     list.current = list.dummy = DummyNode(T)
#     list.length = 0
#     return list
#   end
# end

# # MODULE iterate

# # MODULE capacity
# isempty(list::List) = list.length == 0
# length(list::List) = list.length

# # MODULE element access
# first(list::List) = begin
#   firstnode = next(list.dummy)
#   if isa(firstnode, NilNode)
#     @error "there is no data in list"
#   else
#     return dataof(firstnode)
#   end
# end

# last(list::List) = begin
#   lastnode = list.current
#   if isa(lastnode, NilNode)
#     @error "there is no data in list"
#   else
#     return dataof(lastnode)
#   end
# end

# # MODULE modifiers
# # TODO 1. push
# function push!(list::List{T}, data::T) where T
#   list.length += 1
#   newnode = ConsNode(data)
#   unlink = next(list.current)
#   _insert_next!(newnode, unlink)
#   _insert_next!(list.current, newnode)
#   list.current = next(list.current)
# end

# function push_next!(list::List{T}, node::ConsNode{T}, data::T) where T
#   list.length += 1
#   newnode = ConsNode(data)
#   unlink = next(node)
#   _insert_next!(newnode, unlink)
#   _insert_next!(node, newnode)
# end

# # TODO 2. delete
# """
# this is auto delete at back
# """
# function pop!(list::List)
#   cursor = next(list.dummy)
#   prev = list.dummy

#   # locate
#   while cursor != list.current
#     prev = cursor
#     cursor = next(cursor)
#   end

#   _remove_next!(prev)
#   list.current = prev
#   list.length -= 1
# end

# function popat!(list::List, node::ListCons) 
#   # locate the prev node
#   cursor = next(list.dummy)
#   prev = list.dummy
#   while cursor != node
#     prev = cursor
#     cursor = next(cursor)
#   end

#   _remove_next!(prev)
#   list.length -= 1
# end

# # TODO 3. replace
# replace!(list::List{T}, node::ConsNode{T}, data::T) where T = node.data = data

# # TODO 4. query
# keys(list::List) = next(list.dummy)
# iterate(node::ConsNode) = node, next(node)
# iterate(node::ConsNode, nextnode::ConsNode) = nextnode, next(nextnode)
# iterate(node::ConsNode, nextnode::NilNode) = nothing
# iterate(node::NilNode) = nothing

# # TODO show

