/**
 Without using standard library function, write a program that covert decimal to hexadecimal. Check if the hexadecimal number is the same in forward order and reverse order (e.g., 0x3C3, 0x4B4 are the same in forward order and reverse order).
 */

class Solution {
    func decToHex(_ number: Int) -> String {
        var num = number
        // For storing remainder
        var rem = 0
        // For storing result
        var str = ""
        
        // Digits in hexadecimal number system
        let hex = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        
        while num > 0 {
            rem = num % 16
            str = hex[rem] + str
            num = num / 16
        }
        
        return str
    }
    
    func isPalindrome (_ str: String) -> Bool {
        let chars = Array(str.characters)
        var i = 0
        var j = chars.count - 1
        
        while i < j {
            if chars[i] != chars[j] { return false }
            i += 1
            j -= 1
        }
        return true
    }
}

let obj = Solution()
let hex = obj.decToHex(963)
obj.isPalindrome(hex)
let hex2 = obj.decToHex(961)
obj.isPalindrome(hex2)
		