//
//  Day8.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day4: AdventDay {
    var example: Bool
    var paperRolls:Grid<Character>
    
    init(data: String, example: Bool) {
        self.example = example
        paperRolls = Grid(rawData:data, nullChar:".")
    }
    
    func RunPartOne() throws -> Any {
        var count = 0
        for roll in paperRolls.Points {
            if paperRolls.getPopulatedAdjacentNeightbours(of: roll.key, searchChars:["@"]).count < 4 {
                count += 1
            }
        }
        return count
    }
    
    func RunPartTwo() throws -> Any {
        var workRolls = paperRolls.copy()
        var removable:[Point] = []
        var removedTotal = 0
        repeat {
            print("Removing \(removable.count) rolls, \(workRolls.Points.count) remain")
            for toRemove in removable {
                workRolls.Points[toRemove] = nil
            }
            removedTotal += removable.count
            removable.removeAll()
            for roll in workRolls.Points {
                if workRolls.getPopulatedAdjacentNeightbours(of: roll.key, searchChars:["@"]).count < 4 {
                    removable.append(roll.key)
                }
            }
            
        } while removable.count > 0
        return removedTotal
    }
        
}
