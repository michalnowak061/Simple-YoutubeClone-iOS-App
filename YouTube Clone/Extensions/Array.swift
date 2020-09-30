//
//  Array.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 29/09/2020.
//

import Foundation

extension Array {
    public func saveToFile(path: String) {
        let foundationArray = self as NSArray
        foundationArray.write(toFile: path, atomically: true)
    }
    
    public mutating func loadFromFile(path: String) {
        if let anotherArray = NSArray(contentsOfFile: path) {
            self = anotherArray as! Array
        }
    }
}
