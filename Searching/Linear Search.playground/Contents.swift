/**
 With linear search, we iterate over all the objects in the array and compare each one to the object we're looking for. If the two objects are equal, we stop and return the current array index. If not, we continue to look for the next object as long as we have objects in the array.
 */

import Foundation

class LinearSearch {
    func linearSearch(_ a: [Int], _ element: Int) -> Int? {
        var i = 0
        for num in a {
            if num == element {
                return i
            } else {
                i += 1
            }
        }
        return nil
    }
    
    /**
     Generic applicability
     */
    func linearSearch2<T: Equatable>(_ array: [T], _ object: T) -> Int? {
        for (index, obj) in array.enumerated() where obj == object {
            return index
        }
        return nil
    }
}

let list = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
let obj = LinearSearch()
obj.linearSearch(list, 11)
obj.linearSearch2(list, 11)