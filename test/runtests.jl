using DataStructure, Test

@testset "test datastructure" begin
  @testset "test binary search tree" begin
    tree = BinarySearchTree()
    for i in 1:10
      push!(tree, i)
    end

    @test bfsiterate(tree) == collect(1:10)
  end


  @testset "test graph" begin
    graph = Graph()
    vertexs = map(Vertex, 1:5)

    for vertex in vertexs
      push_vertex!(graph, vertex)
    end

    for vertex in vertexs[2:4]
      push_edge!(graph, vertexs[1], vertex)
    end

    push_edge!(graph, vertexs[2], vertexs[5])
    
    @test bfsiterate(graph) == vertexs

  end

end