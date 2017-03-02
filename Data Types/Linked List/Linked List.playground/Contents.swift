/**
 A linked list is a sequence of data items, just like an array. But where an array allocates a big block of memory to store the objects, the elements in a linked list are totally separate objects in memory and are connected through links:
 
 +--------+    +--------+    +--------+    +--------+
 |        |    |        |    |        |    |        |
 | node 0 |--->| node 1 |--->| node 2 |--->| node 3 |
 |        |    |        |    |        |    |        |
 +--------+    +--------+    +--------+    +--------+
 
 The elements of a linked list are referred to as nodes. The above picture shows a singly linked list, where each node only has a reference -- or a "pointer" -- to the next node. In a doubly linked list, shown below, nodes also have pointers to the previous node:
 
 +--------+    +--------+    +--------+    +--------+
 |        |--->|        |--->|        |--->|        |
 | node 0 |    | node 1 |    | node 2 |    | node 3 |
 |        |<---|        |<---|        |<---|        |
 +--------+    +--------+    +--------+    +--------+
 
 You need to keep track of where the list begins. That's usually done with a pointer called the head:
 
          +--------+    +--------+    +--------+    +--------+
 head --->|        |--->|        |--->|        |--->|        |---> nil
          | node 0 |    | node 1 |    | node 2 |    | node 3 |
  nil <---|        |<---|        |<---|        |<---|        |<--- tail
          +--------+    +--------+    +--------+    +--------+
 
 It's also useful to have a reference to the end of the list, known as the tail. Note that the "next" pointer of the last node is nil, just like the "previous" pointer of the very first node.
 
 Performance of linked lists
 
 Most operations on a linked list have O(n) time, so linked lists are generally slower than arrays. However, they are also much more flexible -- rather than having to copy large chunks of memory around as with an array, many operations on a linked list just require you to change a few pointers.
 
 The reason for the O(n) time is that you can't simply write list[2] to access node 2 from the list. If you don't have a reference to that node already, you have to start at the head and work your way down to that node by following the next pointers (or start at the tail and work your way back using the previous pointers).
 
 But once you have a reference to a node, operations like insertion and deletion are really quick. It's just that finding the node is slow.
 
 This means that when you're dealing with a linked list, you should insert new items at the front whenever possible. That is an O(1) operation. Likewise for inserting at the back if you're keeping track of the tail pointer.
 
 Singly vs doubly linked lists
 
 A singly linked list uses a little less memory than a doubly linked list because it doesn't need to store all those previous pointers.
 
 But if you have a node and you need to find its previous node, you're screwed. You have to start at the head of the list and iterate through the entire list until you get to the right node.
 
 For many tasks, a doubly linked list makes things easier.
 
 Why use a linked list?
 
 A typical example of where to use a linked list is when you need a queue. With an array, removing elements from the front of the queue is slow because it needs to shift down all the other elements in memory. But with a linked list it's just a matter of changing head to point to the second element. Much faster.
 
 But to be honest, you hardly ever need to write your own linked list these days. Still, it's useful to understand how they work; the principle of linking objects together is also used with trees and graphs.
 
 Note:
 
 Linked lists are flexible but many operations are O(n).
 
 When performing operations on a linked list, you always need to be careful to update the relevant next and previous pointers, and possibly also the head and tail pointers. If you mess this up, your list will no longer be correct and your program will likely crash at some point. 
 
 When processing lists, you can often use recursion: process the first element and then recursively call the function again on the rest of the list. You’re done when there is no next element. This is why linked lists are the foundation of functional programming languages such as LISP.
 */

public class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    public init(value: T) {
        self.value = value
    }
}

public class LinkedList<T> {
    /**
     Ideally, I'd like to put the LinkedListNode class inside LinkedList but Swift currently doesn't allow generic types to have nested types. Instead we're using a typealias so inside LinkedList we can write the shorter Node instead of LinkedListNode<T>.
     
     This linked list only has a head pointer, not a tail. Adding a tail pointer is left as an exercise for the reader. (I'll point out which functions would be different if we also had a tail pointer.)
     
     The list is empty if head is nil. Because head is a private variable, I've added the property first to return a reference to the first node in the list.
     */
    public typealias Node = LinkedListNode<T>
    
    fileprivate var head: Node?
    
    public init() {}
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node? {
        return head
    }
    
    /// A property that gives the last node in the list
    public var last: Node? {
        if var node = head {
            while case let next? = node.next {
                node = next
            }
            /*
             The loop also does some Swift magic. The while case let next? = node.next bit keeps looping until node.next is nil. You could have written this as follows:
             
             var node: Node? = head
             while node != nil && node!.next != nil {
                node = node!.next
             }
             */
            return node
        } else {
            return nil
        }
    }
    
    /**
     The append() method first creates a new Node object and then asks for the last node using the last property we've just added. If there is no such node, the list is still empty and we make head point to this new Node. But if we did find a valid node object, we connect the next and previous pointers to link this new node into the chain. A lot of linked list code involves this kind of next and previous pointer manipulation.
     */
    public func append(_ value: T) {
        let newNode = Node(value: value)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else { // The list is still empty and head is assigned to this new Node
            head = newNode
        }
    }
    
    /// Count how many nodes are in the list. It loops through the list in the same manner but this time increments a counter as well.
    /// Note: One way to speed up count from O(n) to O(1) is to keep track of a variable that counts how many nodes are in the list. Whenever you add or remove a node, you also update this variable.
    public var count: Int {
        if var node = head {
            var c = 1
            while case let next? = node.next {
                node = next
                c += 1
            }
            return c
        } else {
            return 0
        }
    }
    
    /**
     Find the node at a specific index in the list. With an array we can just write array[index] and it's an O(1) operation.
     
     The loop starts at head and then keeps following the node.next pointers to step through the list. We're done when we've seen index nodes, i.e. when the counter has reached 0.
     */
    public func nodeAt(_ index: Int) -> Node? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }
    
    /// Implement a subscript method
    public subscript(index: Int) -> T {
        let node = nodeAt(index)
        assert(node != nil)
        return node!.value
    }
    
    /**
     Helper function
     It returns a tuple containing the node currently at the specified index and the node that immediately precedes it, if any. The loop is very similar to nodeAt(), except that here we also keep track of what the previous node is as we iterate through the list.
     
     Let's look at an example. Suppose we have the following list:
     
     head --> A --> B --> C --> D --> E --> nil
     
     We want to find the nodes before and after index 3. As we start the loop, i = 3, next points at "A", and prev is nil.
     
     head --> A --> B --> C --> D --> E --> nil
             next
     
     We decrement i, make prev point to "A", and move next to the next node, "B":
     
     head --> A --> B --> C --> D --> E --> F --> nil
             prev  next
     
     Again, we decrement i and update the pointers. Now prev points to "B", and next points to "C":
     
     head --> A --> B --> C --> D --> E --> F --> nil
                   prev  next
     
     As you can see, prev always follows one behind next. We do this one more time and then i equals 0 and we exit the loop:
     
     head --> A --> B --> C --> D --> E --> F --> nil
                         prev  next
     
     The assert() after the loop checks whether there really were enough nodes in the list. If i > 0 at this point, then the specified index was too large.
     
     Note: If any of the loops in this article don't make much sense to you, then draw a linked list on a piece of paper and step through the loop by hand, just like what we did here.
     
     For this example, the function returns ("C", "D") because "D" is the node at index 3 and "C" is the one right before that.
     */
    private func nodesBeforeAndAfter(_ index: Int) -> (Node?, Node?) {
        assert(index >= 0)
        
        var i = index
        var next = head
        var prev: Node?
        
        while next != nil && i > 0 {
            i -= 1
            prev = next
            next = next!.next
        }
        assert(i == 0)  // If > 0, then specified index was too large
        
        return (prev, next)
    }
    
    /**
     Method for inserting nodesa method that lets you insert a new node at any index in the list.
     
     Some remarks about this method:
     
        1. First, we need to find where to insert this node. After calling the helper method, prev points to the previous node and next is the node currently at the given index. We'll insert the new node in between these two. Note that prev can be nil (index is 0), next can be nil (index equals size of the list), or both can be nil if the list is empty.
     
        2. Create the new node and connect the previous and next pointers. Because the local prev and next variables are optionals and may be nil, so we use optional chaining here.
     
        3. If the new node is being inserted at the front of the list, we need to update the head pointer. (Note: If the list had a tail pointer, you'd also need to update that pointer here if next == nil, because that means the last element has changed.)
     
     Note: The nodesBeforeAndAfter() and insert(atIndex) functions can also be used with a singly linked list because we don't depend on the node's previous pointer to find the previous element.
     */
    public func insert(_ value: T, atIndex index: Int) {
        let (prev, next) = nodesBeforeAndAfter(index)     // 1
        
        let newNode = Node(value: value)    // 2
        newNode.previous = prev
        newNode.next = next
        prev?.next = newNode
        next?.previous = newNode
        
        if prev == nil {                    // 3
            head = newNode
        }
    }
    
    /**
     Removing all nodes
     */
    public func removeAll() {
        head = nil
    }
    
    /**
     Functions that let you remove individual nodes. If you already have a reference to the node, then using remove() is the most optimal because you don't need to iterate through the list to find the node first.
     
     When we take this node out of the list, we break the links to the previous node and the next node. To make the list whole again we must connect the previous node to the next node.
     
     Don't forget the head pointer! If this was the first node in the list then head needs to be updated to point to the next node. (Likewise for when you have a tail pointer and this was the last node). Of course, if there are no more nodes left, head should become nil.
     */
    @discardableResult public func remove(_ node: Node) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev { // prev != nil
            prev.next = next
        } else { // prev == nil
            head = next
        }
        next?.previous = prev
        
        node.previous = nil
        node.next = nil
        return node.value
    }
    
    /**
     If you don't have a reference to the node, you can use removeLast() or removeAt()
     
     Note: For a singly linked list, removing the last node is slightly more complicated. You can't just use last to find the end of the list because you also need a reference to the second-to-last node. Instead, use the nodesBeforeAndAfter() helper method. If the list has a tail pointer, then removeLast() is really quick, but you do need to remember to make tail point to the previous node.
     */
    @discardableResult public func removeLast() -> T {
        assert(!isEmpty)
        return remove(last!)
    }
    
    @discardableResult public func removeAt(_ index: Int) -> T {
        let node = nodeAt(index)
        assert(node != nil)
        return remove(node!)
    }
}

/**
 It's handy to have some sort of readable debug output.
 */
extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.value)"
            node = node!.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
}

/**
 Reversing a list so that the head becomes the tail and vice versa.
 
 This loops through the entire list and simply swaps the next and previous pointers of each node. It also moves the head pointer to the very last element. (If you had a tail pointer you'd also need to update it.) You end up with something like this:
 
          +--------+    +--------+    +--------+    +--------+
 tail --->|        |<---|        |<---|        |<---|        |---> nil
          | node 0 |    | node 1 |    | node 2 |    | node 3 |
  nil <---|        |--->|        |--->|        |--->|        |<--- head
          +--------+    +--------+    +--------+    +--------+
 */
extension LinkedList {
    public func reverse() {
        var node = head
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
}

/**
 Equip linked lists with map() and filter() functions like arrays
 */
extension LinkedList {
    public func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while node != nil {
            result.append(transform(node!.value))
            node = node!.next
        }
        return result
    }
    
    public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while node != nil {
            if predicate(node!.value) {
                result.append(node!.value)
            }
            node = node!.next
        }
        return result
    }
}

extension LinkedList {
    convenience init(array: Array<T>) {
        self.init()
        
        for element in array {
            self.append(element)
        }
    }
}

// MARK: - Test
let list = LinkedList<String>()
list.isEmpty   // true
list.first     // nil

list.append("Hello")
list.isEmpty         // false
list.first!.value    // "Hello"
list.last!.value     // "Hello"

/**
 The list looks like this:
 
          +---------+
 head --->|         |---> nil
          | "Hello" |
  nil <---|         |
          +---------+
 */

list.append("World")
list.first!.value    // "Hello"
list.last!.value     // "World"

list.first!.previous          // nil
list.first!.next!.value       // "World"
list.last!.previous!.value    // "Hello"
list.last!.next               // nil

/**
 And the list looks like:
 
          +---------+    +---------+
 head --->|         |--->|         |---> nil
          | "Hello" |    | "World" |
  nil <---|         |<---|         |
          +---------+    +---------+
 */

list.nodeAt(0)!.value    // "Hello"
list.nodeAt(1)!.value    // "World"
list.nodeAt(2)           // nil

list[0]   // "Hello"
list[1]   // "World"
//list[2]   // It crashes because there is no node at that index

list.insert("Swift", atIndex: 1)
list[0]     // "Hello"
list[1]     // "Swift"
list[2]     // "World"

list.remove(list.first!)   // "Hello"
list.count                 // 2
list[0]                    // "Swift"
list[1]                    // "World"

list.removeLast()          // "World"
list.count                 // 1
list[0]                    // "Swift"

list.removeAt(0)           // "Swift"
list.count                 // 0

list.append("Hello")
list.append("Swifty")
list.append("Universe")
list.description

let m = list.map { s in s.characters.count }
m  // [5, 6, 8]

let f = list.filter { s in s.characters.count > 5 }
f    // [Swifty, Universe]
