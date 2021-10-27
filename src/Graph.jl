import Base.:(==)
import Base: show, iterate
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

mutable struct AdjacencyList
  vertex::Vertex
  edges::Vector{EdgeUnit}

  AdjacencyList(vertex::Vertex) = new(vertex, EdgeUnit[])
end

mutable struct Graph
  adjacency_lists::Vector{AdjacencyList}

  Graph() = new(AdjacencyList[])
end

function show(io::IO, vertex::Vertex)
  print(io, "vertex(", data(vertex))
  print(io, ")")
end

function show(io::IO, unit::EdgeUnit)
  print(io, unit.vertex)
  print(io, " ", unit.weight)
  print(io, " ", "|")
end

function show(io::IO, adjacency_lists::AdjacencyList)
  println(io)
  print(io, adjacency_lists.vertex)
  print(io, "----|")

  for unit in adjacency_lists.edges
    print(io, unit, " ")
  end
end

data(vertex::Vertex) = vertex.data

function push_vertex!(graph::Graph, vertex::Vertex)
  push!(graph.adjacency_lists, AdjacencyList(vertex))
end

function push_edge!(graph::Graph, target::Vertex, other::Vertex, weight::Int = 0)
  # find the adjlist
  index_left = findfirst(adjlist::AdjacencyList -> adjlist.vertex == target, graph.adjacency_lists)
  index_right = findfirst(adjlist::AdjacencyList -> adjlist.vertex == other, graph.adjacency_lists)

  if isnothing(index_left) || isnothing(index_right)
    throw("can't push edge into a non-exist vertex")
  else
    push!(graph.adjacency_lists[index_left].edges,
          EdgeUnit(other, weight))
  end
  # then push the unit
end

function delete_vertex!(graph::Graph, vertex::Vertex)
  index = findfirst(adjlist::AdjacencyList -> adjlist.vertex == vertex, graph.adjacency_lists)
  if isnothing(index)
    throw("can't delete a non-exist vertex")
  else
    popat!(graph.adjacency_lists, index)
    # then delete the vertex in other adjacency list
    for adjacency_list in graph.adjacency_lists
      edges = adjacency_list.edges
      index = findfirst(unit::EdgeUnit -> unit.vertex == vertex, edges)
      if !isnothing(index)
        popat!(edges, index)
      end
    end
  end
end

function delete_edge!(graph::Graph, vertex::Vertex, other::Vertex)
  # find the adjlist
  index_left = findfirst(adjlist::AdjacencyList -> adjlist.vertex == vertex, graph.adjacency_lists)
  index_right = findfirst(adjlist::AdjacencyList -> adjlist.vertex == other, graph.adjacency_lists)
  @info "index_left is: " index_left
  @info "index_right is: " index_right
  if isnothing(index_left) || isnothing(index_right)
    throw("can't delete edge into a non-exist vertex")
  else
    edges = find_edges(graph, vertex)
    index = findfirst(unit::EdgeUnit -> unit.vertex == other, edges)
    if !isnothing(index)
      popat!(edges, index)
    end
  end
  
end

function replace_weight!(graph::Graph, vertex::Vertex, other::Vertex, weight::Int)
  index_left = findfirst(adjlist::AdjacencyList -> adjlist.vertex == vertex, graph.adjacency_lists)
  index_right = findfirst(adjlist::AdjacencyList -> adjlist.vertex == other, graph.adjacency_lists)

  if isnothing(index_left) || isnothing(index_right)
    throw("can't replace weight for a non-exist vertex")
  else
    edges = find_edges(graph, vertex)
    index = findfirst(unit::EdgeUnit -> unit.vertex == other, edges)
    if !isnothing(index)
      edges[index].weight = weight
    else
      throw("there is no connection between two vertex")
    end
  end
end

function replace_vertex!(graph::Graph, vertex::Vertex, other::Vertex)
  # first replace adjacency list
  index = findfirst(adjacency_list::AdjacencyList -> adjacency_list.vertex == vertex,
                    graph.adjacency_lists)
  if isnothing(index)
    throw("can't replace a non-exsit vertex")
  end

  graph.adjacency_lists[index].vertex = other
  # then replace the edges
  for adjacency_list in graph.adjacency_lists
    edges = adjacency_list.edges
    index = findfirst(unit::EdgeUnit -> unit.vertex == vertex, edges)

    if !isnothing(index)
      edges[index].vertex = other
    end
  end
end

function find_edges(graph::Graph, vertex::Vertex)
  index = findfirst(adjlist::AdjacencyList -> adjlist.vertex == vertex, graph.adjacency_lists)
  if !isnothing(index)
    return graph.adjacency_lists[index].edges
  else
    return EdgeUnit[]
  end
end

function find_weight(graph::Graph, vertex::Vertex, other::Vertex)
  index_left = findfirst(adjlist::AdjacencyList -> adjlist.vertex == vertex, graph.adjacency_lists)
  index_right = findfirst(adjlist::AdjacencyList -> adjlist.vertex == other, graph.adjacency_lists)

  if isnothing(index_left) || isnothing(index_right)
    throw("can't find the weight of a non-exist vertex")
  else
    edges = find_edges(graph, vertex)
    index = findfirst(unit::EdgeUnit -> unit.vertex == other, edges)
    if isnothing(index)
      throw("there is no connection between two vertex")
    end

    return edges[index].weight
  end
end

function count_vertex(graph::Graph)
  return length(graph.adjacency_lists)
end

function bfsiterate(graph::Graph)
  result = []
  visit(vertex::Vertex) = push!(result, vertex)

  visited = Dict{Vertex, Bool}()

  for adjlist in graph.adjacency_lists
    vertex = adjlist.vertex
    visited[vertex] = false;
  end
  
  queue = []

  if count_vertex(graph) == 0
    return
  end

  first_vertex = first(graph.adjacency_lists).vertex
  push!(queue, first_vertex)

  while !isempty(queue)
    vertex = popfirst!(queue)
    if !visited[vertex]
      visit(vertex)
      edge = find_edges(graph, vertex)

      for unit in edge
        push!(queue, unit.vertex)
      end
    end

  end

  return result
end
