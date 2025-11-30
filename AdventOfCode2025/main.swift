//
//  main.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics
import ArgumentParser
import System

let arguments = CommandLine.arguments
var day:Int? = Int(arguments[1])

var example:Bool = false
var all:Bool = false

if arguments.count > 2 {
    for _ in arguments[2...] {
        let arg = arguments[2]
        if arg == "--example" || arg == "-e" {
            example = true
        } else if arg == "--all" || arg == "-a" {
            all = true
        }
    }
    let arg = arguments[2]
    if arg == "--example" || arg == "-e" {
        example = true
    }
}

let aocYear = "2025"
let basePath = "Xcode/Advent/inputs/\(aocYear)/"
let cookiePath = "Xcode/Advent/cookie/cookie.txt"
let resultPath = "Xcode/Advent/results/\(aocYear)answers.txt"
let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let cookieUrl = dir.appendingPathComponent(cookiePath)
let resultUrl = dir.appendingPathComponent(resultPath)
let mod:String

if example {
    mod = "example"
} else {
    mod = "input"
}
let file = basePath + "day" + String(day!) + mod + ".txt"

if !example {
    //download file if doesn't exist
    
    let fileUrl = dir.appendingPathComponent(file)
    //check file exists
    let path = cookieUrl.path
    //let _ = FileManager.default.fileExists(atPath:path)
    
    let downloader = try! InputDownload(year:aocYear,cookiePath:FilePath(cookieUrl.path))
    downloader.saveInputToFile(at: fileUrl, day: "\(day!)")
    var timeout = 10
    while timeout > 0 && !FileManager.default.fileExists(atPath:fileUrl.path) {
        Thread.sleep(forTimeInterval: 1)
        timeout -= 1
    }
}

let allChallenges: [any AdventDay] = [
    Day1(basePath:basePath, example: example),
    Day2(basePath:basePath, example: example),
    Day3(basePath:basePath, example: example),
    Day4(basePath:basePath, example: example),
    Day5(basePath:basePath, example: example),
    Day6(basePath:basePath, example: example),
    Day7(basePath:basePath, example: example),
    Day8(basePath:basePath, example: example),
    Day9(basePath:basePath, example: example),
    Day10(basePath:basePath, example: example),
    Day11(basePath:basePath, example: example),
    Day12(basePath:basePath, example: example)
]
    
var selectedChallenge: any AdventDay {
    get throws {
      if let day {
        if let challenge = allChallenges.first(where: { $0.day == day }) {
          return challenge
        } else {
          throw ValidationError("No solution found for day \(day)")
        }
      } else {
        return latestChallenge
      }
    }
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay {
    allChallenges.max(by: { $0.day < $1.day })!
  }

let challenges =
      if all {
        allChallenges
      } else {
        try [selectedChallenge]
      }

let submitter = try! SubmitAnswer(year: aocYear, cookiePath: FilePath(cookieUrl.path), answerURL: resultUrl)

for challenge in challenges {
    print("Executing Aoc \(aocYear) Day \(challenge.day) \(challenge.example ? "Example" : "")")
    
    let part1 = runPart(part: challenge.RunPartOne, named: "Part 1")
    let part2 = runPart(part: challenge.RunPartTwo, named: "Part 2")
    
    print("Part One completed in: \(part1.took)")
    print("Part Two completed in: \(part2.took)")
    
    if !example {
        if part1.answer != nil {
            print("Running submission check for Part One \(part1.answer!)")
            let part1Answer = AocAnswer(year:aocYear, day: String(challenge.day),part: 1, answer: "\(part1.answer!)", computeTime:part1.took)
            submitter.submitInteractive(answer: part1Answer)
        }
        if part2.answer != nil {
            print("Running submission check for Part Two \(part2.answer!)")
            let part2Answer = AocAnswer(year:aocYear, day: String(challenge.day),part: 2, answer: "\(part2.answer!)", computeTime:part2.took)
            submitter.submitInteractive(answer: part2Answer)
        }
    }
        
}
    
    func runPart(part: () throws -> Any, named:String) -> (answer:Any?, took:Duration) {
        var result: Result<Any, Error>?
        let clock = SuspendingClock()
        let time = clock.measure {
            do {
                result = .success(try part())
            }
            catch {
                result = .failure(error)
            }
        }
        var answer:Any? = nil
        switch result! {
            case .success(let success):
              answer = success
              print("\(named) answer: \(success)")
            case .failure(let failure as PartUnimplemented):
              print("Day \(failure.day) part \(failure.part) unimplemented")
            case .failure(let failure):
              print("\(named): Failed with error: \(failure)")
        }
        
        return (answer, time)
    }

