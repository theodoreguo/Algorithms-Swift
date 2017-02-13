/**
 The selection sort algorithm divides the array into two parts: the beginning of the array is sorted, while the rest of the array consists of the numbers that still remain to be sorted.
 [ ...sorted numbers... | ...unsorted numbers... ]
 
 It works as follows:
 - Find the lowest number in the array. You start at index 0, loop through all the numbers in the array, and keep track of what the lowest number is.
 - Swap the lowest number you've found with the number at index 0. Now the sorted portion consists of just the number at index 0.
 - Go to index 1.
 - Find the lowest number in the rest of the array. This time you start looking from index 1. Again you loop until the end of the array and keep track of the lowest number you come across.
 - Swap it with the number at index 1. Now the sorted portion contains two numbers and extends from index 0 to index 1.
 - Go to index 2.
 - Find the lowest number in the rest of the array, starting from index 2, and swap it with the one at index 2. Now the array is sorted from index 0 to 2; this range contains the three lowest numbers in the array.
 - And so on... until no numbers remain to be sorted.
 
 It's called a "selection" sort, because at every step you search through the rest of the array to select the next lowest number.
 
 Performance:
 Selection sort is easy to understand but it performs quite badly, O(n^2). It's worse than insertion sort but better than bubble sort. The killer is finding the lowest element in the rest of the array. This takes up a lot of time, especially since the inner loop will be performed over and over.
 Heap sort uses the same principle as selection sort but has a really fast method for finding the minimum value in the rest of the array. Its performance is O(n log n).
 */

import Foundation

class SelectionSort {
    func selectionSort(_ array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }
        
        var a = array
        
        // Find the lowest value in the rest of the array
        for i in 0 ..< a.count - 1 {
            var lowest = i
            for j in i + 1 ..< a.count {
                if a[j] < a[lowest] {
                    lowest = j
                }
            }
            
            // Swap the lowest value with the current array index
            if i != lowest {
                swap(&a[i], &a[lowest])
            }
        }
        return a
    }
}

let list = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj = SelectionSort()
obj.selectionSort(list)

/**
 Improvement with generic applicability and ascending/descending order selection using a user-supplied function (or closure) to perform the less-than comparison.
 The new parameter isOrderedBefore: (T, T) -> Bool is a function that takes two T objects and returns true if the first object comes before the second, and false if the second object should come before the first. This is exactly what Swift's built-in sort() function does.
 */
class SelectionSort2 {
    func selectionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
        guard array.count > 1 else { return array }
        
        var a = array
        
        // Find the lowest value in the rest of the array
        for i in 0 ..< a.count - 1 {
            var lowest = i
            for j in i + 1 ..< a.count {
                if isOrderedBefore(a[j], a[lowest]) {
                    lowest = j
                }
            }
            
            // Swap the lowest value with the current array index
            if i != lowest {
                swap(&a[i], &a[lowest])
            }
        }
        return a
    }
}

let list2 = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj2 = SelectionSort2()
obj2.selectionSort(list2, <)
obj2.selectionSort(list2, >)
