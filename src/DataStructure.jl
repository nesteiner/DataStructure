module DataStructure

include("List.jl")
export push!, pop!,
  show, keys,
  push_next!, popat!, replace!, first, last, isempty, length, filter, top, eltype,
  createList, createQueue, createStack, ConsNode, ConsDouble,
  copy, ==


include("BinarySearchTree.jl")
export createBSTree, BinarySearchTree, BinaryNode, AbstractBinaryNode
export insert!, show, iterate, dataof, replace!, filter, keys, popat!,
  isleaf, left, right, isnil, eltype,
  bfsiterate, preorder, inorder, postorder, hasleft, hasright

include("Graph.jl")
export Graph, Vertex
export data, push_vertex!, push_edge!, delete_vertex!, delete_edge!, replace_weight!, replace_vertex!,
  find_edges, find_weight, count_vertex, bfsiterate, show
end # module
