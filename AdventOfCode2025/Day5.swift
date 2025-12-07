//
//  Day8.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day5: AdventDay {
    var example: Bool
    let freshLists:[ClosedRange<Int>]
    let ingredients:[Int]
    
    init(data: String, example: Bool) {
        self.example = example
        var workFresh:[ClosedRange<Int>] = []
        var workIngredients:[Int] = []
        for row in data.components(separatedBy: .newlines).compactMap({ !$0.isEmpty ? $0 : nil }) {
            if row.contains("-") {
                let parts = row.components(separatedBy: "-")
                workFresh.append(Int(parts[0])!...Int(parts[1])!)
            } else {
                workIngredients.append(Int(row)!)
            }
        }
        freshLists = workFresh
        ingredients = workIngredients
    }
    
    func RunPartOne() throws -> Any {
        var freshCount = 0
        for ingredient in ingredients {
            for list in freshLists {
                if list ~= ingredient {
                    freshCount += 1
                    break
                }
            }
        }
        return freshCount
    }
    
    func RunPartTwo() throws -> Any {
        var newFresh = freshLists
        
        
        var didMerge = true
        while didMerge {
            var workFresh:[ClosedRange<Int>] = []
            didMerge = false
            var ignoreList:[Int] = []
            outer:
            for i in 0..<newFresh.count-1 {
                for j in i+1..<newFresh.count {
                    if newFresh[i].overlaps(newFresh[j]) {
                        let mergedRange = min(newFresh[i].lowerBound, newFresh[j].lowerBound)...max(newFresh[i].upperBound, newFresh[j].upperBound)
                        workFresh.append(mergedRange)
                        didMerge = true
                        ignoreList.append(i)
                        ignoreList.append(j)
                        break outer
                    }
                }
            }
            newFresh = newFresh.enumerated().filter{ i,v in !ignoreList.contains(i) }.map{ $0.element }
            newFresh.append(contentsOf: workFresh)
        }
        
        return newFresh.reduce(0){ $0 + ($1.upperBound - $1.lowerBound + 1)}
    }
}
