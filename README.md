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

### 节点方法

-   插入下一个节点 `next`
    放心，对于单链表节点和双链表节点的插入方法我已经分发好了

    ``` {.julia}
    insert_next!(node::ListNext, nextnode::ListNode) = node.next = nextnode

    insert_next!(node::ListNext, nextnode::ConsDouble) = begin
      node.next = nextnode
      nextnode.prev = node
    end
    ```

-   删除下一个节点 `next` 有了上面的 `insert_next!` 对 `nextnode`
    的分发，删除节点就不用判断节点类型了 当前节点会连接剩下的节点

    ``` {.julia}
    remove_next!(node::ListNext) = begin
      targetnode = next(node)
      unlinknode = next(targetnode)

      insert_next!(node, unlinknode)
    end
    ```

-   查找上一个节点 这里也需要对类型进行分发，虽然 `ConsDouble`
    类型用不到后面的 `ListNode` ，但这么写是为了统一写法

    ``` {.julia}
    prev(node::ConsDouble, ::ListNode) = node.prev
    prev(node::ConsNode, startnode::ListNext) = begin
      cursor = next(startnode)
      prev = startnode

      # locate
      while cursor != node 
        prev = cursor
        cursor = next(cursor)
      end

      return prev

    end
    ```

-   查找下一个节点

    ``` {.julia}
    next(node::ListNext) = node.next
    ```

-   获取数据

    ``` {.julia}
    dataof(node::ListCons) = node.data
    ```

统一的链表说明
--------------

这里

-   统一了 单，双链表
-   统一了 链表，队列，栈
-   认为 队列，栈都是一种链表

单双链表的不同在于节点，这个通过指定链表内部的 `节点类型` 即可
链表，队列，栈之间的不同在于 `插入方法` 与 `删除方法`
由此，抽离其中的异同部分，构造链表和其基本操作方法

### 链表结构

``` {.julia}
mutable struct BaseList{T}
  dummy::DummyNode
  current::ListNode
  length::Int

  insertfn::Function           # insertfn(list, data)
  removefn::Function           # removefn(list)
  nodetype::DataType           # consnode, consdouble

  BaseList(T::DataType, N::DataType, insertfn, removefn) = begin
    dummy = DummyNode(T)
    list = new{T}()
    list.dummy = list.current = dummy
    list.length = 0

    list.nodetype = N
    list.insertfn = insertfn
    list.removefn = removefn
    return list
  end

end
```

### 添加数据

-   在 `push!` 方法中，可以使用 `BaseList` 的 `insertfn`
    实现不同的插入方式

    ``` {.julia}
    function push!(list::BaseList{T}, data::T) where T
      list.length += 1
      list.insertfn(list, data)
    end
    ```

-   在 `push_next!` 方法中，由于抽象类的存在和 `BaseList` 的 `nodetype`
    ，可以判断插入节点类型

    ``` {.julia}
    function push_next!(list::BaseList{T}, node::ListCons, data::T) where T
      list.length += 1
      unlink = next(node)
      newnode = list.nodetype(data)
      insert_next!(node, newnode)
      insert_next!(newnode, unlink)
    end
    ```

### 删除数据

同上，通过 `removefn` 来实现不同的删除方法

``` {.julia}
function pop!(list::BaseList) 
  if isempty(list) 
    @error "the list is empty"
  else 
    list.length -= 1
    list.removefn(list)
  end
end
```

链表操作
--------

### 接口

1.  链表构造

    -   链表 `createList(T; nodetype)`
    -   队列 `createQueue(T; nodetype)`
    -   栈 `createStack(T; nodetype)`

2.  添加数据

    -   `push!(list, data)` 新建一个值为 `data` 的链表节点到 `list` 中
    -   `push_next!(list, iter, data)` 新建一个值为 `data` 的链表节点到
        `节点iter` 后面

3.  删除数据

    -   `pop!(list)` 通过调用 `list.removefn` 来删除节点，这个方法可以是
        -   链表的删除
        -   队列的删除
        -   栈的删除
    -   `popat!(list, iter)` 删除链表的 `iter` 节点

4.  修改数据

    -   `replace!(iter, data)` 修改 `链表节点iter` 的值为 `data`

5.  查找节点

    -   `findfirst(testf, list)`
        返回第一个符合条件的链表节点，这个节点的值能够匹配 `testf` 其他
        `find` 系列函数也可以参考 `findfirst` 用法
    -   `filter(testf, list)` 
		**目前只支持 链表和队列，不要使用栈**

6.  链表属性

    -   `first(list)`
    -   `last(list)` 
		**不支持栈**
    -   `isempty(list)`
    -   `length(list)`

7.  链表遍历

    `iterate(list)`

8.  基于遍历的操作

    `map(func, list)` 
	**不支持栈**

### 测试案例

-   `push!`

    ``` {.julia}
    list = createList(Int)
    # or list = createList(Int; nodetype = ConsDouble)
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
