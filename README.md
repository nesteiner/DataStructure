
# Table of Contents

1.  [`List.jl`](#org535b16a)
    1.  [链表节点类型](#org3b234b3)
        1.  [类型说明](#org248a759)
        2.  [类型扩展](#orgabd549c)
    2.  [链表操作](#org51100fa)
        1.  [链表构造](#org0bd47db)
        2.  [添加数据](#org409320c)
        3.  [删除数据](#orgb722e43)
        4.  [修改数据](#org136e2dc)
        5.  [查找节点](#org4daf321)
        6.  [链表属性](#org2c4e7d6)
        7.  [链表遍历](#org424a628)



<a id="org535b16a"></a>

# `List.jl`


<a id="org3b234b3"></a>

## 链表节点类型


<a id="org248a759"></a>

### 类型说明

1.  `ListNode`  
    抽象类型，表示所有链表节点的父类
2.  `ListNext`  
    继承自 `ListNode` 抽象类型，表示有 `next` 字段的 `ListNode` 节点
3.  `ListCons`  
    继承自 `ListNext` 抽象类型，表示有 `data` 字段的 `ListNext` 节点


<a id="orgabd549c"></a>

### 类型扩展

1.  `ListNode` 分发 `NilNode` 表示空节点  
    
        mutable struct NilNode{T} <: ListNode end
2.  `ListNext` 分发 `DummyNode` 表示哑节点  
    
        mutable struct DummyNode{T} <: ListNext
          next::ListNode
          DummyNode(E::DataType)  = new{E}(NilNode{E}())
        end
3.  `ListCons` 分发 `ConsNode` 表示单链表节点，分发 `ConsDouble` 表示双链表节点  
    
        mutable struct ConsNode{T} <: ListCons 
          data::T
          next::ListNode
        
          ConsNode(data::T) where T = new{T}(data, NilNode{T}())
        end
        
        
        mutable struct ConsDouble{T} <: ListCons
          data::T
          next::ListNode
          prev::ListNode
        
          ConsDouble(data::T) where T = new{T}(data, NilNode{T}(), NilNode{T}())
        end


<a id="org51100fa"></a>

## 链表操作


<a id="org0bd47db"></a>

### 链表构造

-   单链表 `createSingleList(T)`
-   双链表 `createDoubleList(T)`


<a id="org409320c"></a>

### 添加数据

-   `push!(list, data)`
-   `push_next!(list, iter, data)`


<a id="orgb722e43"></a>

### 删除数据

-   `pop!(list)`
-   `popat!(list, iter)`


<a id="org136e2dc"></a>

### 修改数据

-   `replace!(iter, data)`


<a id="org4daf321"></a>

### 查找节点

-   `findfirst(testf, list)` 以及其他 `find` 系列函数
-   `filter(testf, list)`


<a id="org2c4e7d6"></a>

### 链表属性

-   `first(list)`
-   `last(list)`
-   `isempty(list)`
-   `length(list)`


<a id="org424a628"></a>

### 链表遍历

`iterate(list)`  

