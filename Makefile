all:
	julia --project=. test/runtests.jl
list:
	julia --project=. test/test_list.jl
all_list:
	julia --project=. test/test_all_list.jl

practise: 
	julia --project=. test/practise.jl
tree:
	julia --project=. test/test_tree.jl
practise_tree:
	julia --project=. test/practise_binarytree.jl
eltype:
	julia --project=. test/test_eltype.jl