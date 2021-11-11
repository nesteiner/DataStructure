using DataStructure, Test

# @testset "test list" begin
#   list = createStack(Int; nodetype = ConsDouble)
  
#   for i in 1:10
#     push!(list, i)    
#   end  

#   @test first(list) == 10
#   @test last(list) == 10
#   @test length(list) == 10
#   @test isempty(list) == false
  
#   @testset "test pop" begin
#     while !isempty(list)
#       pop!(list)
#       @show list
#     end
#   end

#   last(list)
# end


# @testset "test queue" begin
#   queue = createQueue(Int; nodetype = ConsDouble)
  
#   for i in 1:10
#     push!(queue, i)    
#     @show queue
#   end  


#   @test first(queue) == 1
#   @test last(queue) == 10
#   @test length(queue) == 10
#   @test isempty(queue) == false


#   @testset "test pop" begin
#     while !isempty(queue)
#       pop!(queue)
#       @show queue
#     end
#   end

# end

@testset "test stack" begin
  stack = createStack(Int; nodetype = ConsDouble)
  
  for i in 1:10
    push!(stack, i)
  end
  
  @testset "test pop" begin
    while !isempty(stack)
      pop!(stack)
      @show stack
    end
  end

end





