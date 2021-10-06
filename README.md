
# Table of Contents

1.  [二叉搜索树](#org557c1f9)
    1.  [数据结构](#org0e474af)
        1.  [节点类型](#org341fecb)
        2.  [二叉树类型](#org7a87fe0)
    2.  [接口](#org4dbb539)
        1.  [二叉树](#org4fd54b1)
        2.  [节点](#org9bc2058)
    3.  [测试案例](#orgfa5fd52)
2.  [图 邻接表](#orgcd6b4b1)
    1.  [数据结构](#org68eea8c)
        1.  [节点类型 `Vertex`](#orgfa498a9)
        2.  [边的单元类型 `EdgeUnit`](#org120535e)
        3.  [邻接表类型 `AdjustList`](#org4e39558)
        4.  [图 类型 `Graph`](#org1d53f42)
    2.  [接口](#org753ba87)
        1.  [构造函数](#orgb1a25ff)
        2.  [添加 点](#orgae7c0af)
        3.  [添加 边](#org5675f65)
        4.  [查看 点 数量](#orgb99a43d)
        5.  [查看 点 对应 边](#orgf75fa83)
    3.  [测试案例](#org3802903)
3.  [实现功能](#org955b38d)
    1.  [基本方法](#orga5f6d8f)
        1.  [二叉树](#org59651b4)
        2.  [图](#orga18cbf8)
    2.  [算法实现](#orgfb3a544)



<a id="org557c1f9"></a>

# 二叉搜索树

[file path](./src/BinarySearchTree.jl)  


<a id="org0e474af"></a>

## 数据结构


<a id="org341fecb"></a>

### 节点类型

-   抽象类 `AbstractTreeNode`
-   派生类 `TreeNode`
-   派生类 `TreeNil`


<a id="org7a87fe0"></a>

### 二叉树类型

-   二叉搜索树 `BinarySearchTree`


<a id="org4dbb539"></a>

## 接口


<a id="org4fd54b1"></a>

### 二叉树

-   构造函数  
    `BinarySearchTree() = BinarySearchTree(TreeNil(), <)`
-   增  
    `push!(tree::BinarySearchTree, data::Int)`
-   打印  
    `bfsiterate(tree::BinarySearchTree)`


<a id="org9bc2058"></a>

### 节点

-   判断叶子节点  
    `isleaf(node::TreeNode)`
-   判断空节点  
    `isnil(node::AbstractTreeNode)`


<a id="orgfa5fd52"></a>

## 测试案例

    @testset "test binary search tree" begin
      tree = BinarySearchTree()
      for i in 1:10
        push!(tree, i)
      end
    
      @test bfsiterate(tree) == collect(1:10)
    end


<a id="orgcd6b4b1"></a>

# 图 邻接表

[file path](./src/Graph.jl)  


<a id="org68eea8c"></a>

## 数据结构


<a id="orgfa498a9"></a>

### 节点类型 `Vertex`

    mutable struct Vertex
      data::Int
    end

需要为其重载 **=** 运算符  


<a id="org120535e"></a>

### 边的单元类型 `EdgeUnit`

    mutable struct EdgeUnit
      vertex::Vertex
      weight::Int
    
      EdgeUnit(vertex::Vertex) = new(vertex, 0)
      EdgeUnit(vertex::Vertex, weight::Int) = new(vertex, weight)
    end


<a id="org4e39558"></a>

### 邻接表类型 `AdjustList`

    mutable struct AdjustList
      vertex::Vertex
      edge::Vector{EdgeUnit}
    end


<a id="org1d53f42"></a>

### 图 类型 `Graph`

    mutable struct Graph
      adjlists::Vector{AdjustList}
    end


<a id="org753ba87"></a>

## 接口


<a id="orgb1a25ff"></a>

### 构造函数

`Graph()`  


<a id="orgae7c0af"></a>

### 添加 点

`push!(graph::Graph, vertex::Vertex)`  


<a id="org5675f65"></a>

### 添加 边

`push!(graph::Graph, target::Vertex, other::Vertex)`  
需要两个点都存在  


<a id="orgb99a43d"></a>

### 查看 点 数量

`count_vertex(graph::Graph)`  


<a id="orgf75fa83"></a>

### 查看 点 对应 边

`findedge(graph::Graph, vertex::Vertex)`  
如果没有对应的边，返回空数组  


<a id="org3802903"></a>

## 测试案例

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


<a id="org955b38d"></a>

# TODO 实现功能


<a id="orga5f6d8f"></a>

## 基本方法


<a id="org59651b4"></a>

### 二叉树

-   [ ] 增
-   [ ] 删
-   [ ] 改
-   [ ] 查


<a id="orga18cbf8"></a>

### 图

-   [ ] 增
-   [ ] 删
-   [ ] 改
-   [ ] 查


<a id="orgfb3a544"></a>

## 算法实现

-   [ ] 遍历方法
-   [ ] 迭代器
-   [ ] AVL
-   [ ] 最短路径

