/**
 Bubble sort is a sorting algorithm that is implemented by starting in the beginning of the array and swapping the first two elements only if the first element is greater than the second element. This comparison is then moved onto the next pair and so on and so forth. This is done until the array is completely sorted. The smaller items slowly “bubble” up to the beginning of the array.
 */

import Foundation

class BubbleSort {
    func bubbleSort<T: Comparable>(_ a: inout [T]) {
        for i in 0..<a.count {
            for j in (i + 1)..<a.count {
                if a[i] > a[j] {
                    (a[i], a[j]) = (a[j], a[i])
                }
            }
        }
    }
}

var list = [10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26]
let obj = BubbleSort()
obj.bubbleSort(&list)
list