import UIKit

var str: String = "Hello, playground"
let closure: (String) -> Int = { (s) in 3 }
closure("hello")

var x: Int! = 5
x = nil
let y = x + 1

print(x)
