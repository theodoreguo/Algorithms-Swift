import Foundation

/**
 Simple but inefficient version of quicksort
 */
class QuickSort {
    func quickSort<T: Comparable>(_ a: [T]) -> [T] {
        guard a.count > 1 else { return a }
        
        let pivot = a[a.count / 2]
        let less = a.filter { $0 < pivot }
        let equal = a.filter { $0 == pivot }
        let greater = a.filter { $0 > pivot }
        
        // Uncomment this following line to see in detail what the pivot is in each step and how the subarrays are partitioned.
//        print(pivot, less, equal, greater)
        return quickSort(less) + equal + quickSort(greater)
    }
}

let list1 = [10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26]
let obj = QuickSort()
obj.quickSort(list1)

/**
 Lomuto's partitioning algorithm.
 The return value is the index of the pivot element in the new array. The left partition is [low...p-1]; the right partition is [p+1...high], where p is the return value.
 */
class QuickSort2 {
    func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
        let pivot = a[high]
        
        var i = low
        for j in low..<high {
            if a[j] <= pivot {
                (a[i], a[j]) = (a[j], a[i])
                i += 1
            }
        }
        (a[i], a[high]) = (a[high], a[i])
        
        return i
    }
    
    func quickSortLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
        if low < high {
            let p = partitionLomuto(&a, low: low, high: high)
            quickSortLomuto(&a, low: low, high: p - 1)
            quickSortLomuto(&a, low: p + 1, high: high)
        }
    }
}

let obj2 = QuickSort2()
var list2 = [10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8]
obj2.partitionLomuto(&list2, low: 0, high: list2.count - 1)
obj2.quickSortLomuto(&list2, low: 0, high: list2.count - 1)
list2
