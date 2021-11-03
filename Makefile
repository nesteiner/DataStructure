all:
	julia --project=. test/runtests.jl
list:
	julia --project=. test/test_list.jl
all_list:
	julia --project=. test/test_all_list.jl