/**
 Radix sort is a sorting algorithm that takes as input an array of integers and uses a sorting subroutine to sort the integers by their radix, or rather their digit. Counting Sort, and Bucket Sort are often times used as the subroutine for Radix Sort.
 
 Example:
 Input Array: [170, 45, 75, 90, 802, 24, 2, 66]
 Output Array (Sorted): [2, 24, 45, 66, 75, 90, 170, 802]
 The largest integer in our array is 802, and it has three digits (ones, tens, hundreds). So our algorithm will iterate three times whilst performing some sorting algorithm on the digits of each integer.
 Iteration 1: 170, 90, 802, 2, 24, 45, 75, 66
 Iteration 2: 802, 2, 24, 45, 66, 170, 75, 90
 Iteration 3: 2, 24, 45, 66, 75, 90, 170, 802
 */

import Foundation

class RadixSort {
    func radixSort(_ a: inout [Int]) {
        let radix = 10  // Define radix to be 10
        var done = false
        var index: Int
        var digit = 1 // Which digit are we on?
        
        while !done {  // While sorting is not completed
            done = true  // Assume it is done for now
            
            var buckets: [[Int]] = []  // Our sorting subroutine is bucket sort, so predefine the buckets
            
            for _ in 1...radix {
                buckets.append([])
            }
            
            for number in a {
                index = number / digit  // Which bucket will we access?
                buckets[index % radix].append(number)
                if done && index > 0 {  // If not done, continue to finish, otherwise it's done
                    done = false
                }
            }
            
            var i = 0
            
            for j in 0..<radix {
                let bucket = buckets[j]
                for number in bucket {
                    a[i] = number
                    i += 1
                }
            }
            
            digit *= radix  // Move to the next digit
        }
    }
}

var list = [170, 45, 75, 90, 802, 24, 2, 66]
let obj = RadixSort()
obj.radixSort(&list)
list
