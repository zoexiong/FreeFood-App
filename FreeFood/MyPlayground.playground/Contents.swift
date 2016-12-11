//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var sp = str.characters.split{$0 == ","}.map(String.init)
print(sp)