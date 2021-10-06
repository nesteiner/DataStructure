abstract type ListNode end
abstract type ListNext <: ListNode end
abstract type ListCons <: ListNext end

import Base: push!, show, iterate

mutable struct Nil <: ListNode

end

mutable struct Dummy <: ListNext
  next::ListNode

  Dummy() = new(Nil())
end

mutable struct Cons <: ListCons
  data::Int
  next::ListNode

  Cons(data::Int) = new(data, Nil())
end

# TODO their interface
next(node::ListNext) = node.next
data(node::ListCons) = node.data
insert_next!(node::ListNext, next::ListNode) = node.next = next

mutable struct List
  dummy::Dummy
  current::ListNode

  List() = begin
    list = new()
    list.current = list.dummy = Dummy()
    return list
  end
end

function iterate(list::List)
  firstnode = next(list.dummy)
  if isa(firstnode, Nil)
    return nothing
  else
    return data(firstnode), next(firstnode)
  end
end

function iterate(list::List, state::ListNode)
  if isa(state, Nil)
    return nothing
  else
    return data(state), next(state)
  end
end

# TODO 1. push
function push!(list::List, data::Int)
  newnode = Cons(data)
  unlink = next(list.current)
  insert_next!(newnode, unlink)
  insert_next!(list.current, newnode)
  list.current = next(list.current)
end
# TODO 2. show
function show(io::IO, list::List)
  print(io, "list: ")
  for value in list
    print(io, value, ' ')
  end
end

