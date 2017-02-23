/**
 Shell sort is based on insertion sort as a general way to improve its performance, by breaking the original list into smaller sublists which are then individually sorted using insertion sort.
 
 How it works:
 - Instead of comparing elements that are side-by-side and swapping them if they are out of order, the way insertion sort does it, the shell sort algorithm compares elements that are far apart.
 - The distance between elements is known as the gap. If the elements being compared are in the wrong order, they are swapped across the gap. This eliminates many in-between copies that are common with insertion sort.
 - The idea is that by moving the elements over large gaps, the array becomes partially sorted quite quickly. This makes later passes faster because they don't have to swap so many items any more.
 - Once a pass has been completed, the gap is made smaller and a new pass starts. This repeats until the gap has size 1, at which point the algorithm functions just like insertion sort. But since the data is already fairly well sorted by then, the final pass can be very quick.
 
 The reason we use this gap is that we don't have to actually make new arrays. Instead, we interleave them in the original array.
 */

import Foundation

class ShellSort {
    public func shellSort(_ a: inout [Int]) {
        var sublistCount = a.count / 2
        while sublistCount > 0 {
            for pos in 0..<sublistCount {
                insertionSort(&a, start: pos, gap: sublistCount)
            }
            sublistCount = sublistCount / 2
        }
    }
    
    public func insertionSort(_ a: inout [Int], start: Int, gap: Int) {
        for i in stride(from: (start + gap), to: a.count, by: gap) {
            let currentValue = a[i]
            var pos = i
            while pos >= gap && a[pos - gap] > currentValue {
                a[pos] = a[pos - gap]
                pos -= gap
            }
            a[pos] = currentValue
        }
    }
}

var list = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]
let obj = ShellSort()
obj.shellSort(&list)
list
