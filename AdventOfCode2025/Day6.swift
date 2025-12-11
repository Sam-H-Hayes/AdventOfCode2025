//
//  Day7.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day6: AdventDay {
    var example: Bool
    var sumParts:[(op:Character,numbers:[String])] = []
    let rawRows:[String]
    
    init(data: String, example: Bool) {
        self.example = example
        var rowLists: [[String]] = []
        for row in data.components(separatedBy: .newlines).compactMap({ $0.isEmpty ? nil : $0 }) {
            let parts = row.components(separatedBy: .whitespaces)
            rowLists.append(parts)
        }
        
        let strippedRows = rowLists.map{ $0.compactMap{ $0.isEmpty ? nil : $0 } }
        for i in 0..<strippedRows[0].count {
            
            let op = Character(strippedRows.last![i])
            //assert op == "+" || op == "*"
            var figures: [String] = []
            for j in 0..<strippedRows.count-1 {
                figures.append(strippedRows[j][i])
            }
            sumParts.append((op, figures))
        }
        let lines = data.components(separatedBy: .newlines).compactMap({ $0.isEmpty ? nil : $0 })
        
        rawRows = lines.dropLast()
    }
        
    func RunPartOne() throws -> Any {
        var total = 0
        for sum in sumParts {
            switch sum.op {
                case "*":
                total += sum.numbers.reduce(1){ $0 * Int($1)! }
                case "+":
                total += sum.numbers.reduce(0){ $0 + Int($1)! }
            default:
                break
            }
        }
        return total
    }
        
    func RunPartTwo() throws -> Any {
        var total = 0
        var workRows = rawRows
        for sum in sumParts.reversed() {
            var figures:[Int] = []
            //take last character from each row and create number
            var number = 0
            repeat {
                guard workRows[0].count > 0 else {
                    break
                }
                let numString = String(workRows.map{ $0.last! }).trimmingCharacters(in: .whitespaces)
                workRows = workRows.map{ String($0.dropLast()) }
                if numString.isEmpty {
                    number = 0
                    continue
                }
                number = Int(numString)!
                figures.append(number)
            } while number != 0
            
            switch sum.op {
                case "*":
                total += figures.reduce(1,*)
                case "+":
                total += figures.reduce(0,+)
            default:
                break
            }
        }
        return total
    }
}
    
