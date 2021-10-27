all:
	julia --project=. test/runtests.jl
list:
	julia --project=. test/test_list.jl