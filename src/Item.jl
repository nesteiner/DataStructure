import Base: iterate

abstract type AbstractItem end

struct Item{T} <: AbstractItem
  value::T
end

main = function()
  item = Item{Int}(1)
  print(item)
end

main()