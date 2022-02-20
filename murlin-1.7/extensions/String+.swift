//
//  String+.swift
//  murlin-1.7
//
//  Created by John Knowles on 2/19/22.
//

import Foundation

extension String {
    func fuzzyMatch(_ needle: String) -> Bool {
        if needle.isEmpty { return true }
        var remainder = needle[...]
        for char in self {
            if char == remainder[remainder.startIndex] {
                remainder.removeFirst()
                if remainder.isEmpty { return true }
            }
        }
        return false
    }
}
