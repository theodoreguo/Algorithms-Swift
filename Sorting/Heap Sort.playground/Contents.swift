/**
 Heap sort is an in-place sorting algorithm with worst case and average complexity of O(n log n).
 A heap is a partially sorted binary tree that is stored inside an array. The heap sort algorithm takes advantage of the structure of the heap to perform a fast sort.
 To sort from lowest to highest, heap sort first converts the unsorted array to a max-heap, so that the first element in the array is the largest.
 
 The basic idea is to turn the array into a binary heap structure, which has the property that it allows efficient retrieval and removal of the maximal element.
 We repeatedly "remove" the maximal element from the heap, thus building the sorted list from back to front.
 Heapsort requires random access, so can only be used on an array-like data structure.
 */

import Foundation

class HeapSort {
    func heapSort<T:Comparable>(_ a: inout [T]) {
        var count = a.count
        
        func shiftDown(_ a: inout [T], start: Int, end: Int) { // end represents the limit of how far down the heap to shift
            var root = start
            
            while root * 2 + 1 <= end { // While the root has at least one child
                let child = root * 2 + 1 // root * 2 + 1 points to the left child
                var swap = root
                
                if a[swap] < a[child] { // Out of max-heap order
                    swap = child // Repeat to continue sifting down the child
                }
                
                if child + 1 <= end && a[swap] < a[child + 1] { // If the child has a sibling and the child's value is less than its sibling's
                    swap = child + 1 // Point to the right child instead
                }
                
                if swap == root {
                    return
                } else {
                    (a[root], a[swap]) = (a[swap], a[root])
                    root = swap
                }
            }
        }
        
        func heapify(_ a: inout [T], count: Int) {
            var start = count / 2 - 1 // start is assigned the index in a of the last parent node
            
            while start >= 0 {
                shiftDown(&a, start: start, end: count - 1) // Shift down the node at index start to the proper place such that all nodes below the start index are in heap order
                
                start -= 1
            } // After sifting down the root all nodes/elements are in heap order
        }
        
        heapify(&a, count: count) // Place a in max-heap order
        
        var end = count - 1
        
        while end > 0 {
            (a[end], a[0]) = (a[0], a[end]) // Swap the root (maximum value) of the heap with the last element of the heap
            
            end -= 1 // Decrement the size of the heap so that the previous max value will stay in its proper place
            
            shiftDown(&a, start: 0, end: end) // Put the heap back in max-heap order
        }
    }
}

var list = [4, 13, 20, 8, 7, 17, 2, 5, 25]
let obj = HeapSort()
obj.heapSort(&list)
list

/**
 Extension for heap
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

extension Heap {
    public mutating func sort() -> [T] {
        for i in stride(from: (elements.count - 1), through: 1, by: -1) {
            swap(&elements[0], &elements[i])
            shiftDown(0, heapSize: i)
        }
        return elements
    }
}

public func heapSort<T>(_ a: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
    let reverseOrder = { i1, i2 in sort(i2, i1) }
    var h = Heap(array: a, sort: reverseOrder)
    return h.sort()
}

var heap = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
let array = heap.sort()
heapSort(array, >)
