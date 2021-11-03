module DataStructure

include("List.jl")
export push!, pop!,
  show, keys,
  push_next!, popat!, replace!, first, last, isempty, length, filter, top, 
  createList, createQueue, createStack, ConsNode, ConsDouble


include("BinarySearchTree.jl")
export BinarySearchTree
export push!, show, iterate, data, assign_data!

include("Graph.jl")
export Graph, Vertex
export data, push_vertex!, push_edge!, delete_vertex!, delete_edge!, replace_weight!, replace_vertex!,
  find_edges, find_weight, count_vertex, bfsiterate, show
end # module
