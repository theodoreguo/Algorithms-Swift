/**
 The insertion sort algorithm works as follows:
 - Put the numbers on a pile. This pile is unsorted.
 - Pick a number from the pile. It doesn't really matter which one you pick, but it's easiest to pick from the top of the pile.
 - Insert this number into a new array.
 - Pick the next number from the unsorted pile and also insert that into the new array. It either goes before or after the first number you picked, so that now these two numbers are sorted.
 - Again, pick the next number from the pile and insert it into the array in the proper sorted position.
 - Keep doing this until there are no more numbers on the pile. You end up with an empty pile and an array that is sorted.
 
 That's why this is called an "insertion" sort, because you take a number from the pile and insert it in the array in its proper sorted position.
 
 This is how the content of the array changes during the sort:
 [| 8, 3, 5, 4, 6 ]
 [ 8 | 3, 5, 4, 6 ]
 [ 3, 8 | 5, 4, 6 ]
 [ 3, 5, 8 | 4, 6 ]
 [ 3, 4, 5, 8 | 6 ]
 [ 3, 4, 5, 6, 8 |]
 In each step, the | bar moves up one position. As you can see, the beginning of the array up to the | is always sorted. The pile shrinks by one and the sorted portion grows by one, until the pile is empty and there are no more unsorted numbers left.
 */

import Foundation

class InsertionSort {
    func insertionSort(_ array: [Int]) -> [Int] {
        var a = array
        for i in 1..<a.count {
            var j = i
            while j > 0 && a[j] < a[j - 1] {
                swap(&a[j - 1], &a[j])
                j -= 1
            }
        }
        return a
    }
}

let list = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj = InsertionSort()
obj.insertionSort(list)

/**
 Run time improvement by removing the call to swap()
 */
class InsertionSort2 {
    func insertionSort(_ array: [Int]) -> [Int] {
        var a = array
        for i in 1..<a.count {
            var j = i
            let temp = a[j]
            while j > 0 && temp < a[j - 1] {
                a[j] = a[j - 1] // Shift up the previous elements by one position
                j -= 1
            }
            a[j] = temp // Copy this number into target place
        }
        return a
    }
}

let list2 = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj2 = InsertionSort2()
obj2.insertionSort(list2)

/**
 Improvement with generic applicability and ascending/descending order selection using a user-supplied function (or closure) to perform the less-than comparison.
 The new parameter isOrderedBefore: (T, T) -> Bool is a function that takes two T objects and returns true if the first object comes before the second, and false if the second object should come before the first. This is exactly what Swift's built-in sort() function does.
 */
class InsertionSort3 {
    func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
        guard array.count > 1 else { return array }
        
        var a = array
        for i in 1..<a.count {
            var j = i
            let temp = a[j]
            while j > 0 && isOrderedBefore(temp, a[j - 1]) {
                a[j] = a[j - 1]
                j -= 1
            }
            a[j] = temp
        }
        return a
    }
}

let list3 = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj3 = InsertionSort3()
obj3.insertionSort(list, <)
obj3.insertionSort(list, >)
