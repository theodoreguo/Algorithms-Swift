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
        
        func shiftDown(_ a: inout [T], start: Int, end: Int) { // end represents the limit of how far down the heap to sift
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
            var start = (count - 2) / 2 // start is assigned the index in a of the last parent node
            
            while start >= 0 {
                shiftDown(&a, start: start, end: count - 1) // Shift down the node at index start to the proper place such that all nodes below the start index are in heap order
                
                start -= 1
            } // After sifting down the root all nodes/elements are in heap order
        }
        
        heapify(&a, count: count) // Place a in max-heap order
        
        var end = count - 1
        
        while end > 0 {
            (a[end], a[0]) = (a[0], a[end]) // Swap the root(maximum value) of the heap with the last element of the heap
            
            end -= 1 // Decrement the size of the heap so that the previous max value will stay in its proper place
            
            shiftDown(&a, start: 0, end: end) // Put the heap back in max-heap order
        }
    }
}

var list = [4, 13, 20, 8, 7, 17, 2, 5, 25]
let obj = HeapSort()
obj.heapSort(&list)
list
