//
//  Day7.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day7: AdventDay {
    var example: Bool
    let tachyonManifold:Grid<Character>
    
    init(data: String, example: Bool) {
        self.example = example
        tachyonManifold = Grid(rawData:data, nullChar:".")
    }
    
    func RunPartOne() throws -> Any {
        let start = tachyonManifold.Points.first { $0.value == "S" }!.key
        var currentBeam:Point
        var splitCount = 0
        var visited:Set<Point> = []
        var frontier:Set<Point> = [start]
        
        while !frontier.isEmpty {
            currentBeam = frontier.removeFirst()
            if !tachyonManifold.inBounds(currentBeam)  {
                continue
            }
            if visited.contains(currentBeam) {
                continue
            }
            if tachyonManifold.Points[currentBeam] == "^" {
                frontier.insert(Point(currentBeam.x - 1, currentBeam.y))
                frontier.insert(Point(currentBeam.x + 1, currentBeam.y))
                splitCount += 1
                
            } else {
                frontier.insert(Point(currentBeam.x, currentBeam.y + 1))
            }
            visited.insert(currentBeam)
                
        }
        return splitCount
    }
    
    func RunPartTwo() throws -> Any {
        let start = tachyonManifold.Points.first { $0.value == "S" }!.key
        var cache:[Point:Int] = [:]
        return pathCount(from: start, cache: &cache)
    }
    func pathCount(from start:Point, cache: inout [Point:Int]) -> Int {
        if start.y == tachyonManifold.height - 1 {
            return 1
        }
        if let cached = cache[start] {
            return cached
        }
        
        let below = Point(start.x, start.y + 1)
        var next:[Point] = []
        
        if tachyonManifold.Points[below] == "^" {
            next.append(below.move(by:Point(-1,0)))
            next.append(below.move(by:Point(1,0)))
        } else {
            next.append(below)
        }
        var paths = next.reduce(0){initial, point in initial + pathCount(from: point, cache: &cache)}
        cache[start] = paths
        return paths
        
    }
}
