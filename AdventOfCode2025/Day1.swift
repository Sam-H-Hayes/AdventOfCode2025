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
    var turns:[(dir:Character, rotate:Int)] = []
    
    init(data: String, example: Bool) {
        self.example = example
        let dataRows = data.components(separatedBy: .newlines).compactMap{$0.isEmpty ? nil : $0}
        for row in dataRows {
            let direction = row.first!
            let distance = Int(row.dropFirst().trimmingCharacters(in: .whitespaces))!
            turns.append((direction, distance))
        }
    }
    
    func RunPartOne() throws -> Any {
        var dialPos = 50
        var zeroCount = 0
        for turn in turns {
            let rotation = turn.rotate % 100
            if turn.dir == "R" {
                dialPos += rotation
                dialPos %= 100
            } else {
                if dialPos >= rotation {
                    dialPos -= rotation
                } else {
                    dialPos = 100 - (rotation - dialPos)
                }
            }
            if dialPos == 0 {
                zeroCount += 1
            }
        }
        return zeroCount
    }
    
    func RunPartTwo() throws -> Any {
        var dialPos = 50
        var zeroClicks = 0
        for turn in turns {
            let rotation = turn.rotate % 100
            zeroClicks += turn.rotate / 100
            if turn.dir == "R" {
                dialPos += rotation
                if dialPos >= 100 {
                    if dialPos != 100 {
                        zeroClicks += 1
                    }
                    dialPos %= 100
                }
            } else {
                if dialPos >= rotation {
                    dialPos -= rotation
                } else {
                    if dialPos != 0 {
                        zeroClicks += 1
                    }
                    dialPos = 100 - (rotation - dialPos)
                }
            }
            if dialPos == 0 {
                zeroClicks += 1
            }
        }
        return zeroClicks
    }
}
