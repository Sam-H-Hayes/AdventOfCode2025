//
//  Day12.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day11: AdventDay {
    var example: Bool
    let deviceOutput:[String:[String]]
    
    init(data: String, example: Bool) {
        self.example = example
        var workOutputs: [String:[String]] = [:]
        for row in data.components(separatedBy: .newlines).compactMap({ $0.isEmpty ? nil : $0 }) {
            let parts = row.components(separatedBy: ": ")
            let key = parts[0]
            let outPuts = parts[1].components(separatedBy: .whitespaces)
            workOutputs[key] = outPuts
        }
        deviceOutput = workOutputs
    }
    
    func RunPartOne() throws -> Any {
        return pathCount(from: "you", to: "out")
        
    }
    
    func pathCount(from start:String, to end:String) -> Int {
        var pathCount = 0
        var frontier:QueueLL<String> = QueueLL()
        frontier.enqueue(start)
        var cameFrom:[String:Set<String>] = [:]
        cameFrom[start] = nil
        //var visited:Set<String> = []
        //visited.insert(start)
        while !frontier.isEmpty {
            let current = frontier.dequeue()!
            if current == end {
                //don't add to this path, continue finding more paths
                
                pathCount += 1
                continue
            }
            for next in deviceOutput[current] ?? [] {
                //if already visited this node, don't add again to frontier
                if cameFrom[current] != nil && cameFrom[current]!.contains(next) {
                    continue
                }
                frontier.enqueue(next)
                if cameFrom[next] == nil {
                    cameFrom[next] = [current]
                } else {
                    cameFrom[next]!.insert(current)
                }
                
            }
        }
        return pathCount
    }

    func RunPartTwo() throws -> Any {
        var cache:[CacheKey:Int] = [:]
        return pathCountMemoisation(from: "svr", to: "out", cache: &cache, flag: 0, targetFlag: DacFlag | FftFlag)
    }
    
    struct CacheKey:Hashable {
        let node:String
        let flag:Int
    }
    let DacFlag = 1 << 1 //bit shift 1
    let FftFlag = 1 << 2 //bit shift 2 == 4
    
    func pathCountMemoisation(from start:String, to end:String, cache: inout [CacheKey:Int],flag:Int = 0, targetFlag:Int) -> Int {
        if start == end {
            return flag == targetFlag ? 1 : 0
        }
        var newFlag = flag
        
        switch start {
            case "dac":
                newFlag |= DacFlag //set DacFlag
            case "fft":
                newFlag |= FftFlag //set FftFlag
            default:
                break
        }
        
        guard let nextNodes = deviceOutput[start] else {
            return 0
        }
        
        let newKey = CacheKey(node: start, flag: newFlag)
        if cache[newKey] != nil {
            return cache[newKey]!
        }
        
        var res = nextNodes.reduce(0) { x, next in x + pathCountMemoisation(from: next, to: end, cache: &cache, flag: newFlag, targetFlag: targetFlag) }
        cache[newKey] = res
        return res
    }
    
}
