import Base: push!, popat!, pop!,
  show, iterate,
  isempty, length,
  first, last,
  replace!, filter, keys

include("ListNode.jl")

createSingleList(T::DataType) = BaseList(T)
createDoubleList(T::DataType) = BaseList(T, insert_data_next_2!)

mutable struct BaseList{T}
  dummy::DummyNode
  current::ListNode
  length::Int

  insert_fn::Function
  
  BaseList(E::DataType) = begin
    list = new{E}()
    list.current = list.dummy = DummyNode(E)
    list.length = 0
    
    list.insert_fn = insert_data_next_1!
    
    return list
  end

  BaseList(E::DataType, insert_fn::Function) = begin
    list = BaseList(E)
    list.insert_fn = insert_fn

    return list
  end
end

keys(list::BaseList) = next(list.dummy)

function push!(list::BaseList{T}, data::T) where T
  list.length += 1
  list.insert_fn(list.current, data)
  
  list.current = next(list.current)
end

# ATTENTION to test push_next!, you should override the `findfirst` first.

function push_next!(list::BaseList{T}, node::ListCons, data::T) where T
  list.length += 1
  unlink = next(node)
  list.insert_fn(node, data)
  newnode = next(node)
  # FIXME here, I need to insert node
  # list.insert_fn(newnode, unlink)
  insert_next!(newnode, unlink)
end

function pop!(list::BaseList) 
  list.length -= 1
  prevnode = prev(list.current, list.dummy)
  remove_next!(prevnode)
  list.current = prevnode
end

function popat!(list::BaseList, iter::ListNext)
  list.length -= 1
  prevnode = prev(iter, list.dummy)
  unlinknode = next(iter)
  remove_next!(prevnode)
  insert_next!(prevnode, unlinknode)
end

replace!(node::ListCons, data::T) where T = node.data = data

function iterate(list::BaseList)
  firstnode = next(list.dummy)
  if isa(firstnode, NilNode)
    return nothing
  else
    return dataof(firstnode), next(firstnode)
  end
end

function iterate(::BaseList, state::ListNode)
  if isa(state, NilNode)
    return nothing
  else
    return dataof(state), next(state)
  end
end

first(list::BaseList) = begin
  firstnode = next(list.dummy)
  if isa(firstnode, NilNode)
    @error "there is no data in list"
  else
    return dataof(firstnode)
  end
end

last(list::BaseList) = begin
  lastnode = list.current
  if isa(lastnode, NilNode)
    @error "there is no data in list"
  else
    return dataof(lastnode)
  end
end

isempty(list::BaseList) = list.length == 0
length(list::BaseList) = list.length

function show(io::IO, list::BaseList)
  print(io, "list: ")
  for value in list
    print(io, value, ' ')
  end
end

function filter(testf::Function, list::BaseList{T}) where T
  result = BaseList{T}()

  for data in list
    if testf(data)
      push!(result, data)
    end
  end

  return result
end
