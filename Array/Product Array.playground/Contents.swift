/**
 Given an array arr[] of n integers, construct a Product Array prod[] (of same size) such that prod[i] is equal to the product of all the elements of arr[] except arr[i]. Solve it without division operator and in O(n).
 
 Example:
 arr[] = [10, 3, 5, 6, 2]
 prod[] = [180, 600, 360, 300, 900]
 
 Similar to the question below:
 Given an array of numbers, nums, return an array of numbers products, where products[i] is the product of all nums[j], j != i.
 
 Input : [1, 2, 3, 4, 5]
 Output: [(2*3*4*5), (1*3*4*5), (1*2*4*5), (1*2*3*5), (1*2*3*4)]
       = [120, 60, 40, 30, 24]
 You must do this in O(N) without using division.
 */

/**
 1. Construct a temporary array left[] such that left[i] contains product of all elements on left of arr[i] excluding arr[i].
 2. Construct another temporary array right[] such that right[i] contains product of all elements on on right of arr[i] excluding arr[i].
 3. To get prod[], multiply left[] and right[].
 
 In this case, n = 5. Hence, we get
 left : [                   1,            a[0],    a[0]*a[1],    a[0]*a[1]*a[2],  a[0]*a[1]*a[2]*a[3] ]
 right: [ a[1]*a[2]*a[3]*a[4],  a[2]*a[3]*a[4],    a[3]*a[4],              a[4],                    1 ]
 */
class Solution {
    // Function to get product array for a given array arr[]
    func productArray(_ arr: [Int]) -> [Int] {
        let n = arr.count
        
        // Initialize memory to all arrays
        var left = [Int](repeating: 0, count: n)
        var right = [Int](repeating: 0, count: n)
        var prod = [Int](repeating: 0, count: n)
        
        // The most left element of left array is always 1
        left[0] = 1
        
        // The most right element of right array is always 1
        right[n - 1] = 1
        
        // Construct the left array
        for i in 1 ..< n {
            left[i] = arr[i - 1] * left[i - 1]
        }
        
        // Construct the right array
        var j = n - 2
        while j >= 0 {
            right[j] = arr[j + 1] * right[j + 1]
            j -= 1
        }
        
        // Construct the product array using left[] and right[]
        for i in 0 ..< n {
            prod[i] = left[i] * right[i]
        }
        
        return prod
    }
}

let obj = Solution()
let a = [10, 3, 5, 6, 2]
let a2 = [1, 2, 3, 4, 5]
obj.productArray(a)
obj.productArray(a2)
