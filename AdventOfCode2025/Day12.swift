//
//  Day12.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day12: AdventDay {
    var example: Bool
    let presents:[Grid<Character>]
    let spaces:[(size:Point,giftCounts:[Int])]
    
    init(data: String, example: Bool) {
        self.example = example
        var presentSection = true
        var presentRows:[String] = []
        var workPresents:[Grid<Character>] = []
        var workSpaces:[(Point,[Int])] = []
        for row in data.components(separatedBy: .newlines).compactMap({ $0.isEmpty ? nil : $0 }) {
            if presentSection {
                if row.contains(":") {
                    if row.contains("x") {
                        presentSection = false
                    }
                    if presentRows.isEmpty {
                        continue
                    }
                    workPresents.append(Grid<Character>(rows: presentRows))
                    presentRows = []
                } else {
                    presentRows.append(row)
                }
            }
            
            if !presentSection {
                let parts = row.components(separatedBy: ": ")
                let coords = parts[0].components(separatedBy: "x")
                 let counts = parts[1].components(separatedBy: .whitespaces).compactMap{Int($0)}
                workSpaces.append((Point(Int(coords[0])!,Int(coords[1])!),counts))
            }
        }
        presents = workPresents
        spaces = workSpaces
    }
    
    func RunPartOne() throws -> Any {
        var fitCount = 0
        for space in spaces {
            let width = space.size.x
            let height = space.size.y
            //do basic estimations first
            let size = width * height
            let maxNeeded = space.giftCounts.reduce(0, +) * 9
            if maxNeeded > size {
                continue
            }
            //check number of 3x3 blocks needed
            let blockCapacity = (width / 3) * (height / 3)
            let neededBlocks = space.giftCounts.reduce(0,+)
            if neededBlocks > blockCapacity {
                continue
            }
            //check actual space taken
            let actualSize = space.giftCounts.enumerated().map{index, count in presents[index].Points.count * count}.reduce(0, +)
            if actualSize > size {
                continue
            }
            fitCount += 1
        }
                
        return fitCount
    }
    
}
