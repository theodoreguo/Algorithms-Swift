/**
 Binary search is to keep splitting the array in half until the value is found using divide and conquer theory.
 For an array of size n, the performance is not O(n) as with linear search but only O(log n).
 
 Here's how binary search works:
 - Split the array in half and determine whether the thing you're looking for, known as the search key, is in the left half or in the right half.
 - How do you determine in which half the search key is? This is why you sorted the array first, so you can do a simple < or > comparison.
 - If the search key is in the left half, you repeat the process there: split the left half into two even smaller pieces and look in which piece the search key must lie. (Likewise for when it's the right half.)
 - This repeats until the search key is found. If the array cannot be split up any further, you must regrettably conclude that the search key is not present in the array.
 
 Now you know why it's called a "binary" search: in every step it splits the array into two halves. This process of divide-and-conquer is what allows it to quickly narrow down where the search key must be.
 */

import Foundation

class BinarySearch {
    /**
     Recursion implementation
     */
    func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
        if range.lowerBound >= range.upperBound {
            return nil // If we get here, then the search key is not present in the array.
        } else {
            // Calculate where to split the array.
            let midIndex = (range.lowerBound + range.upperBound) / 2
            
            if key < a[midIndex] { // Is the search key in the left half?
                return binarySearch(a, key: key, range: range.lowerBound ..< midIndex)
            } else if key > a[midIndex] { // Is the search key in the right half?
                return binarySearch(a, key: key, range: midIndex + 1 ..< range.upperBound)
            } else { // If we get here, then we've found the search key.
                return midIndex
            }
        }
    }
    
    /**
     Iteration implementation
     */
    func binarySearch2<T: Comparable>(_ a: [T], key: T) -> Int? {
        var l = 0
        var r = a.count - 1
        while l <= r {
            let m = (l + r) / 2
            if key < a[m] {
                r = m - 1
            } else if key > a[m] {
                l = m + 1
            } else {
                return m
            }
        }
        return nil
    }
}

let list = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
let obj = BinarySearch()
obj.binarySearch(list, key: 43, range: 0..<list.count)
obj.binarySearch2(list, key: 43)
