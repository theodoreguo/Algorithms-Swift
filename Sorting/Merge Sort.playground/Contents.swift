/**
 Merge-sort is an efficient algorithm with a best, worst, and average time complexity of O(n log n).
 
 The merge-sort algorithm uses the divide and conquer approach which is to divide a big problem into smaller problems and solve them. The merge-sort algorithm can be thought as split first and merge after.
 
 Assume you need to sort an array of n numbers in the right order. The merge-sort algorithm works as follows:
 - Put the numbers in an unsorted pile.
 - Split the pile into two. Now, you have two unsorted piles of numbers.
 - Keep splitting the resulting piles until you cannot split anymore. In the end, you will have n piles with one number in each pile.
 - Begin to merge the piles together by pairing them sequentially. During each merge, put the contents in sorted order. This is fairly easy because each individual pile is already sorted.
 
 Performance:
 A disadvantage of the merge-sort algorithm is that it needs a temporary "working" array equal in size to the array being sorted. It is not an in-place sort, unlike for example quicksort.
 */

import Foundation
/**
 This is an iterative top-down implementation.
 */
class MergeSort {
    func mergeSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        
        let middleIndex = array.count / 2
        let leftArray = mergeSort(Array(array[0..<middleIndex]))
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
        
        return merge(leftPile: leftArray, rightPile: rightArray)
    }
    
    func merge<T: Comparable>(leftPile: [T], rightPile: [T]) -> [T] {
        var leftIndex = 0
        var rightIndex = 0
        var orderedPile = [T]()
        if orderedPile.capacity < leftPile.count + rightPile.count {
            orderedPile.reserveCapacity(leftPile.count + rightPile.count)
        }
        
        while leftIndex < leftPile.count && rightIndex < rightPile.count {
            if leftPile[leftIndex] < rightPile[rightIndex] {
                orderedPile.append(leftPile[leftIndex])
                leftIndex += 1
            } else if leftPile[leftIndex] > rightPile[rightIndex] {
                orderedPile.append(rightPile[rightIndex])
                rightIndex += 1
            } else {
                orderedPile.append(leftPile[leftIndex])
                leftIndex += 1
                orderedPile.append(rightPile[rightIndex])
                rightIndex += 1
            }
        }
        
        while leftIndex < leftPile.count {
            orderedPile.append(leftPile[leftIndex])
            leftIndex += 1
        }
        
        while rightIndex < rightPile.count {
            orderedPile.append(rightPile[rightIndex])
            rightIndex += 1
        }
        
        return orderedPile
    }
}

let list = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj = MergeSort()
obj.mergeSort(list)

/**
 This is an iterative bottom-up implementation. Instead of recursively splitting up the array into smaller sublists, it immediately starts merging the individual array elements.
 As the algorithm works its way up, it no longer merges individual elements but larger and larger subarrays, until eventually the entire array is merged and sorted.
 To avoid allocating many temporary array objects, it uses double-buffering with just two arrays.
 */
class MergeSort2 {
    func mergeSort<T>(_ a: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
        let n = a.count
        var z = [a, a] // The two working arrays
        var d = 0 // z[d] is for reading while z[1 - d] is for writing, i.e., double-buffering
        var width = 1 // The size of the pile is given by width. Initially, width is 1 but at the end of each loop iteration, multiply it by two. So this outer loop determines the size of the piles being merged, and the subarrays to merge become larger in each step.
        
        while width < n {
            
            var i = 0
            while i < n {
                
                var j = i
                var l = i
                var r = i + width
                
                let lmax = min(l + width, n)
                let rmax = min(r + width, n)
                
                while l < lmax && r < rmax { // This is the same logic as in the top-down version
                    if isOrderedBefore(z[d][l], z[d][r]) {
                        z[1 - d][j] = z[d][l]
                        l += 1
                    } else {
                        z[1 - d][j] = z[d][r]
                        r += 1
                    }
                    j += 1
                }
                while l < lmax {
                    z[1 - d][j] = z[d][l]
                    j += 1
                    l += 1
                }
                while r < rmax {
                    z[1 - d][j] = z[d][r]
                    j += 1
                    r += 1
                }
                
                i += width * 2
            }
            
            width *= 2   // The subarray to merge becomes larger in each step (the piles of size width from array z[d] have been merged into larger piles of size width * 2 in array z[1 - d])
            d = 1 - d    // Swap active array, so that in the next step we'll read from the new piles we have just created.
        }
        
        return z[d]
    }
}

let list2 = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj2 = MergeSort2()
obj2.mergeSort(list2, <)
obj2.mergeSort(list2, >)
