//
//  Day3.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day3: AdventDay {
    var example: Bool
    let Batteries:[[Int]]
    
    init(data: String, example: Bool) {
        self.example = example
        let lines = data.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let batts = lines.map{ l in Array(l).map{ Int(String($0))! } }
        Batteries = batts
    }
    
    func RunPartOne() throws -> Any {
        var batterySum = 0
        for battery in Batteries {
            batterySum += highestPower(in: battery)
        }
        return batterySum
    }
    
    func highestPower(in battery: [Int]) -> Int {
        //highest number excluding last digit
        let tensPlace = battery.dropLast().max()!
        //handle case where there are multiple highest numbers - in which case the highest power is that number twice - unless last digit is higher!
        if battery.last! >= tensPlace {
            return tensPlace * 10 + battery.last!
        } else if battery.filter({ $0 == tensPlace }).count > 1 {
            return tensPlace * 11
        }
        //now the case where we search for the highest number right of the tens place
        let tensIndex = battery.firstIndex(of: tensPlace)!
        let unitsPlace = battery[(tensIndex+1)...].max()!
        return tensPlace * 10 + unitsPlace
    }
    
    func RunPartTwo() throws -> Any {
        var batterySum = 0
        for battery in Batteries {
            batterySum += highestNthPower(in: battery)
        }
        return batterySum
    }
    
    func highestNthPower(in battery: [Int], n: Int = 12) -> Int {
        //highest number excluding last n-1th digits
        let nthPlace = battery.dropLast(n-1).max()!
        //we should always take the first index of this number
        let nthIndex = battery.firstIndex(of: nthPlace)!
        if n > 1 {
            return (nthPlace * Int(pow(10.0, Double(n-1)))) + highestNthPower(in: Array(battery[(nthIndex+1)...]), n: n-1)
        } else {
            return nthPlace
        }
    
    }
}
