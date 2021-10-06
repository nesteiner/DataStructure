import Base.:(==)

mutable struct Vertex
  data::Int
end

==(left::Vertex, right::Vertex) = left.data == right.data

mutable struct EdgeUnit
  vertex::Vertex
  weight::Int

  EdgeUnit(vertex::Vertex) = new(vertex, 0)
  EdgeUnit(vertex::Vertex, weight::Int) = new(vertex, weight)
end

mutable struct AdjustList
  vertex::Vertex
  edge::Vector{EdgeUnit}
end

mutable struct Graph
  adjlists::Vector{AdjustList}

  Graph() = new([])
end

#= TODO
1. push_vertex!
2. push_edge!
3. bfsprint
=#

function findedge(graph::Graph, vertex::Vertex)
  index = findfirst(adjlist::AdjustList -> adjlist.vertex == vertex, graph.adjlists)
  if !isnothing(index)
    return graph.adjlists[index].edge
  else
    return []
  end
end

function push_vertex!(graph::Graph, vertex::Vertex)
  push!(graph.adjlists, AdjustList(vertex, []))
end

function push_edge!(graph::Graph, target::Vertex, other::Vertex, weight::Int = 0)
  # find the adjlist
  index_left = findfirst(adjlist::AdjustList -> adjlist.vertex == target, graph.adjlists)
  index_right = findfirst(adjlist::AdjustList -> adjlist.vertex == other, graph.adjlists)

  if isnothing(index_left) || isnothing(index_right)
    throw("can't push edge into a non-exist vertex")
  else
    push!(graph.adjlists[index_left].edge,
          EdgeUnit(other, weight))
  end
  # then push the unit
end

function count_vertex(graph::Graph)
  return length(graph.adjlists)
end

function bfsiterate(graph::Graph)
  result = []
  visit(vertex::Vertex) = push!(result, vertex)

  visited = Dict{Vertex, Bool}()

  for adjlist in graph.adjlists
    vertex = adjlist.vertex
    visited[vertex] = false;
  end
  
  queue = []

  if count_vertex(graph) == 0
    return
  end

  first_vertex = first(graph.adjlists).vertex
  push!(queue, first_vertex)

  while !isempty(queue)
    vertex = popfirst!(queue)
    if !visited[vertex]
      visit(vertex)
      edge = findedge(graph, vertex)

      for unit in edge
        push!(queue, unit.vertex)
      end
    end

  end

  return result
end
