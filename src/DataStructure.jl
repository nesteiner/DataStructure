module DataStructure

include("List.jl")
export List
export push!, pop!, insert_data_next_1!, insert_data_next_2!, remove_next!,
  show, keys,
  push_next!, popat!, replace!, first, last, isempty, length, filter
# export push!, show, iterate, isempty, length, first, last,
#   show,
#   replace!,
#   filter,
#   keys,
#   # push_next!,
#   dataof,
#   popat!, pop!


include("BinarySearchTree.jl")
export BinarySearchTree
export push!, show, iterate, data, assign_data!

include("Graph.jl")
export Graph, Vertex
export data, push_vertex!, push_edge!, delete_vertex!, delete_edge!, replace_weight!, replace_vertex!,
  find_edges, find_weight, count_vertex, bfsiterate, show
end # module
