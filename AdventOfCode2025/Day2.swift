//
//  Day3.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day2: AdventDay {
    var example: Bool
    var ranges: [ClosedRange<Int>] = []
    
    init(data: String, example: Bool) {
        self.example = example
        for range in data.components(separatedBy: ","){
            let bounds = range.trimmingCharacters(in: .newlines).components(separatedBy: "-").compactMap { Int($0) }
            ranges.append(bounds[0]...bounds[1])
        }
    }
    
    func RunPartOne() throws -> Any {
        var invalidSum = 0
        for range in ranges {
            for i in range {
                if !isValid(number: i) {
                    invalidSum += i
                    //print("Invalid number found: \(i)")
                }
            }
        }
        return invalidSum
    }
    
    private func isValid(number: Int) -> Bool {
        let digits = String(number).compactMap { Int(String($0)) }
        guard digits.count % 2 == 0 else {
            return true
        }
        let left = digits.prefix(digits.count / 2)
        let right = digits.suffix(digits.count / 2)
        return left != right
    }
    
    func RunPartTwo() throws -> Any {
        var invalidSum = 0
        for range in ranges {
            for i in range {
                if !isValid2(number: i) {
                    invalidSum += i
                    //print("Invalid number found: \(i)")
                }
            }
        }
        return invalidSum
    }
    
    private func isValid2(number: Int) -> Bool {
        let digits = String(number).compactMap { Int(String($0)) }
        if digits.count == 1 {
            return true
        }
        if digits.allSatisfy({ $0 == digits.first }) {
            return false
        }
        if digits.count % 2 == 0 {
            let left = digits.prefix(digits.count / 2)
            let right = digits.suffix(digits.count / 2)
            if left == right {
                return false
            }
        }
        if digits.count % 3 == 0 {
            let third = digits.count / 3
            let first = digits.prefix(third)
            let second = digits[third..<(2*third)]
            let thirdPart = digits.suffix(third)
            if first == second && second == thirdPart {
                return false
            }
        }
        if digits.count % 4 == 0 {
            let fourth = digits.count / 4
            let first = digits.prefix(fourth)
            let second = digits[fourth..<(2*fourth)]
            let third = digits[(2*fourth)..<(3*fourth)]
            let fourthPart = digits.suffix(fourth)
            if first == second && second == third && third == fourthPart {
                return false
            }
        }
        if digits.count % 5 == 0 {
            let fifth = digits.count / 5
            let first = digits.prefix(fifth)
            let second = digits[fifth..<(2*fifth)]
            let third = digits[(2*fifth)..<(3*fifth)]
            let fourth = digits[(3*fifth)..<(4*fifth)]
            let fifthPart = digits.suffix(fifth)
            if first == second && second == third && third == fourth && fourth == fifthPart {
                return false
            }
        }
        return true
    }
        

}
