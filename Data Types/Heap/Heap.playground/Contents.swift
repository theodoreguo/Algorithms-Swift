/**
 A heap is a binary tree that lives inside an array, so it doesn't use parent/child pointers. The tree is partially sorted according to something called the "heap property" that determines the order of the nodes in the tree.
 
 There are two kinds of heaps: a max-heap and a min-heap. They are identical, except that the order in which they store the tree nodes is opposite.
 
 In a max-heap, parent nodes must always have a greater value than each of their children. For a min-heap it's the other way around: every parent node has a smaller value than its child nodes. This is called the "heap property" and it is true for every single node in the tree.
 
 Differences between heap and regular trees
 
 A heap isn't intended to be a replacement for a binary search tree. But there are many similarities between the two and also some differences. Here are some of the bigger differences:
 
 Order of the nodes. In a binary search tree (BST), the left child must always be smaller than its parent and the right child must be greater. This is not true for a heap. In max-heap both children must be smaller; in a min-heap they both must be greater.
 
 Memory. Traditional trees take up more memory than just the data they store. You need to allocate additional storage for the node objects and pointers to the left/right child nodes. A heap only uses a plain array for storage and uses no pointers.
 
 Balancing. A binary search tree must be "balanced" so that most operations have O(log n) performance. You can either insert and delete your data in a random order or use something like an AVL tree or red-black tree. But with heaps we don't actually need the entire tree to be sorted. We just want the heap property to be fulfilled, and so balancing isn't an issue. Because of the way the heap is structured, heaps can guarantee O(log n) performance.
 
 Searching. Searching a binary tree is really fast -- that's its whole purpose. In a heap, searching is slow. The purpose of a heap is to always put the largest (or smallest) node at the front, and to allow relatively fast inserts and deletes. Searching isn't a top priority.
 */

public struct Heap<T> {
    /** The array that stores the heap's nodes. */
    var elements = [T]()
    
    /** Determine whether this is a max-heap (>) or min-heap (<). */
    fileprivate var isOrderedBefore: (T, T) -> Bool
    
    /**
     Create an empty heap.
     The sort function determines whether this is a min-heap or max-heap.
     For integers, > makes a max-heap, < makes a min-heap.
     */
    public init(sort: @escaping (T, T) -> Bool) {
        self.isOrderedBefore = sort
    }
    
    /**
     Create a heap from an array. The order of the array does not matter; the elements are inserted into the heap in the order determined by the  sort function.
     */
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.isOrderedBefore = sort
        buildHeap(fromArray: array)
    }
    
    /*
     // This version has O(n log n) performance.
     private mutating func buildHeap(array: [T]) {
        elements.reserveCapacity(array.count)
        for value in array {
            insert(value)
        }
     }
     */
    
    /**
     Convert an array to a max-heap or min-heap in a bottom-up manner.
     Performance: This runs pretty much in O(n).
     */
    fileprivate mutating func buildHeap(fromArray array: [T]) {
        elements = array
        for i in stride(from: (elements.count / 2 - 1), through: 0, by: -1) {
            shiftDown(i, heapSize: elements.count)
        }
    }
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var count: Int {
        return elements.count
    }
    
    /**
     Return the index of the parent of the element at index i.
     The element at index 0 is the root of the tree and has no parent.
     */
    @inline(__always) func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    
    /**
     Return the index of the left child of the element at index i.
     Note that this index can be greater than the heap size, in which case there is no left child.
     */
    @inline(__always) func leftChildIndex(ofIndex i: Int) -> Int {
        return 2 * i + 1
    }
    
    /**
     Return the index of the right child of the element at index i.
     Note that this index can be greater than the heap size, in which case there is no right child.
     */
    @inline(__always) func rightChildIndex(ofIndex i: Int) -> Int {
        return 2 * i + 2
    }
    
    /**
     Return the maximum value in the heap (for a max-heap) or the minimum value (for a min-heap).
     */
    public func peek() -> T? {
        return elements.first
    }
    
    /**
     Add a new value to the heap. This reorders the heap so that the max-heap or min-heap property still holds. 
     Performance: O(log n).
     */
    public mutating func insert(_ value: T) {
        elements.append(value)
        shiftUp(elements.count - 1)
    }
    
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    
    /**
     Allow you to change an element. In a max-heap, the new element should be larger than the old one; in a min-heap it should be smaller.
     */
    public mutating func replace(index i: Int, value: T) {
        guard i < elements.count else { return }
        
        assert(isOrderedBefore(value, elements[i]))
        elements[i] = value
        shiftUp(i)
    }
    
    /**
     Remove the root node from the heap. For a max-heap, this is the maximum value; for a min-heap it is the minimum value. Performance: O(log n).
     */
    @discardableResult public mutating func remove() -> T? {
        if elements.isEmpty {
            return nil
        } else if elements.count == 1 {
            return elements.removeLast()
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = elements[0]
            elements[0] = elements.removeLast()
            shiftDown()
            return value
        }
    }
    
    /**
     Remove an arbitrary node from the heap. Performance: O(log n). You need to know the node's index, which may actually take O(n) steps to find.
     */
    public mutating func removeAt(_ index: Int) -> T? {
        guard index < elements.count else { return nil }
        
        let size = elements.count - 1
        if index != size {
            swap(&elements[index], &elements[size])
            shiftDown(index, heapSize: size)
            shiftUp(index)
        }
        return elements.removeLast()
    }
    
    /**
     Take a child node and looks at its parents; if a parent is not larger (max-heap) or not smaller (min-heap) than the child, we exchange them.
     */
    mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = elements[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && isOrderedBefore(child, elements[parentIndex]) {
            elements[childIndex] = elements[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        elements[childIndex] = child
    }
    
    mutating func shiftDown() {
        shiftDown(0, heapSize: elements.count)
    }
    
    /**
     Look at a parent node and makes sure it is still larger (max-heap) or smaller (min-heap) than its childeren.
     */
    mutating func shiftDown(_ index: Int, heapSize: Int) {
        var parentIndex = index
        
        while true {
            let leftChildIndex = self.leftChildIndex(ofIndex: parentIndex)
            let rightChildIndex = leftChildIndex + 1
            
            // Figure out which comes first if we order them by the sort function:
            // the parent, the left child, or the right child. If the parent comes
            // first, we're done. If not, that element is out-of-place and we make
            // it "float down" the tree until the heap property is restored.
            var first = parentIndex
            if leftChildIndex < heapSize && isOrderedBefore(elements[leftChildIndex], elements[first]) {
                first = leftChildIndex
            }
            if rightChildIndex < heapSize && isOrderedBefore(elements[rightChildIndex], elements[first]) {
                first = rightChildIndex
            }
            if first == parentIndex { return }
            
            swap(&elements[parentIndex], &elements[first])
            parentIndex = first
        }
    }
}

// MARK: - Searching
extension Heap where T: Equatable {
    /**
     Search the heap for the given element. Performance: O(n).
     */
    public func index(of element: T) -> Int? {
        return index(of: element, 0)
    }
    
    fileprivate func index(of element: T, _ i: Int) -> Int? {
        if i >= count { return nil }
        if isOrderedBefore(element, elements[i]) { return nil }
        if element == elements[i] { return i }
        if let j = index(of: element, self.leftChildIndex(ofIndex: i)) { return j }
        if let j = index(of: element, self.rightChildIndex(ofIndex: i)) { return j }
        return nil
    }
}
