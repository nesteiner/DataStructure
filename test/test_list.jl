using DataStructure, Test

@testset "test single list" begin
  list = List(Int)
  for i in 1:10
    push!(list, i)
  end
  
  @testset "push next" begin
    iter = findfirst(isequal(2), list)
    push_next!(list, iter, 2)
    
    @show list
  end

  @testset "pop at" begin
    iter = findfirst(isequal(2), list)
    popat!(list, iter)
    
    @show list
  end

  @testset "replace" begin
    iter = findfirst(isequal(2), list)
    replace!(iter, -2)

    @show list
  end

  @testset "other property" begin
    @info "first of list is " first(list)
    @info "last of list is " last(list)
    @info "isempty: " isempty(list)
    @info "length: " length(list)
  end


end

@testset "test double list" begin
  list = List(Int, insert_data_next_2!, remove_next!)
  @testset "push element into list" begin
    for i in 1:10
      push!(list, i)
    end
    
    for value in list
      @show value
    end
  end
  
  @testset "push next " begin
    iter = findfirst(isequal(2), list)
    push_next!(list, iter, -2)
  end
  @testset "pop at" begin
    iter = findfirst(isequal(2), list)
    popat!(list, iter)
    
    @show list
  end

  @testset "replace" begin
    iter = findfirst(isequal(3), list)
    replace!(iter, -2)

    @show list
  end

  @testset "other property" begin
    @info "first of list is " first(list)
    @info "last of list is " last(list)
    @info "isempty: " isempty(list)
    @info "length: " length(list)
  end


end