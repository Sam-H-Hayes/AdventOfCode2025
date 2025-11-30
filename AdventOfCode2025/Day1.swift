//
//  Day1.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day1: AdventDay {
    var example: Bool
    
    init(data: String, example: Bool) {
        self.example = example
        let dataRows = data.components(separatedBy: .newlines).compactMap{$0.isEmpty ? nil : $0}
    }
    
    func RunPartOne() throws -> Any {
        return 0
    }
    
    func RunPartTwo() throws -> Any {
        return 0
    }
}
