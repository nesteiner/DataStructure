---
export_file_name: 'README.md'
title: 数据结构需求设计
---

`List.jl`
=========

**介绍** 最近参考了下其他人用 `Rust` 写的链表，里面有

``` {.rust}
enum List {
    Node(i32, List),
    Nil
}
```

这样不用判断链表节点是否为空值，也防止了调用函数时遇到空值，通过保证类型安全，保证了内存安全
这里试了一下用 `Julia` 写一遍，用 **抽象类型分派** 来模拟 `Rust` 中的
`enum`

链表节点类型
------------

### 类型说明

1.  `ListNode` 抽象类型，表示所有链表节点的父类
2.  `ListNext` 继承自 `ListNode` 抽象类型，表示有 `next` 字段的
    `ListNode` 节点
3.  `ListCons` 继承自 `ListNext` 抽象类型，表示有 `data` 字段的
    `ListNext` 节点

### 类型扩展

1.  `ListNode` 分发 `NilNode` 表示空节点

    ``` {.julia}
    mutable struct NilNode{T} <: ListNode end
    ```

2.  `ListNext` 分发 `DummyNode` 表示哑节点

    ``` {.julia}
    mutable struct DummyNode{T} <: ListNext
      next::ListNode
      DummyNode(E::DataType)  = new{E}(NilNode{E}())
    end
    ```

3.  `ListCons` 分发 `ConsNode` 表示单链表节点， `ConsDouble`
    表示双链表节点

    ``` {.julia}
    mutable struct ConsNode{T} <: ListCons 
      data::T
      next::ListNode

      ConsNode(data::T) where T = new{T}(data, NilNode{T}())
    end
    ```

    ``` {.julia}
    mutable struct ConsDouble{T} <: ListCons
      data::T
      next::ListNode
      prev::ListNode

      ConsDouble(data::T) where T = new{T}(data, NilNode{T}(), NilNode{T}())
    end
    ```

链表操作
--------

### 接口

1.  链表构造

    -   单链表 `createSingleList(T)`
    -   双链表 `createDoubleList(T)`

2.  添加数据

    -   `push!(list, data)` 新建一个值为 `data` 的链表节点到 `list` 中
    -   `push_next!(list, iter, data)` 新建一个值为 `data` 的链表节点到
        `节点iter` 后面

3.  删除数据

    -   `pop!(list)` 删除链表 `list` 的最后一个节点
    -   `popat!(list, iter)` 删除链表的 `iter` 节点

4.  修改数据

    -   `replace!(iter, data)` 修改 `链表节点iter` 的值为 `data`

5.  查找节点

    -   `findfirst(testf, list)`
        返回第一个符合条件的链表节点，这个节点的值能够匹配 `testf` 其他
        `find` 系列函数也可以参考 `findfirst` 用法
    -   `filter(testf, list)`

6.  链表属性

    -   `first(list)`
    -   `last(list)`
    -   `isempty(list)`
    -   `length(list)`

7.  链表遍历

    `iterate(list)`

8.  基于遍历的操作

    `map(func, list)`

9.  [TODO]{.todo .TODO} 切面

### 测试案例

-   `push!`

    ``` {.julia}
    list = createSingleList(Int)
    # or list = createDoubleList(Int)
    for i in 1:10
      push!(list, i)
    end
    ```

-   `push_next!`

    ``` {.julia}
    iter = findfirst(isequal(2), list)
    push_next!(list, iter, 2)
    ```

-   `pop!`

    ``` {.julia}
    # pop until empty, don't try that
    while !isempty(list)
      pop!(list)
    end
    ```

-   `popat!`

    ``` {.julia}
    iter = findfirst(isequal(2), list)
    popat!(list, iter)
    ```

-   `replace!`

    ``` {.julia}
    iter = findfirst(isequal(2), list)
    replace!(iter, -2)
    ```

-   属性

    ``` {.julia}
    @info "first of list is " first(list)
    @info "last of list is " last(list)
    @info "isempty: " isempty(list)
    @info "length: " length(list)
    ```
