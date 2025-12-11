//
//  Day9.swift
//  AdventOfCode2025
//
//  Created by Samuel Hayes on 30.11.2025.
//

import Foundation
import AocBasics

struct Day9: AdventDay {
    var example: Bool
    let redTiles:[Point]
    
    init(data: String, example: Bool) {
        self.example = example
        var tiles:[Point] = []
        for line in data.components(separatedBy: .newlines).compactMap({!$0.isEmpty ? $0 : nil}){
            let parts = line.components(separatedBy: ",")
            tiles.append(Point(Int(parts[0])!,Int(parts[1])!))
        }
        redTiles = tiles
    }
    
    func RunPartOne() throws -> Any {
        var maxArea = 0
        for i in 0..<redTiles.count {
            for j in i+1..<redTiles.count {
                let area = area(from: redTiles[i], to: redTiles[j])
                if area > maxArea {
                    maxArea = area
                }
            }
        }
        return maxArea
    }
    
    func area(from tile1:Point, to tile2:Point) -> Int {
        let deltaX = (tile1.x - tile2.x).magnitude + 1
        let deltaY = (tile1.y - tile2.y).magnitude + 1
        return Int(deltaX * deltaY)
    }
    
    func RunPartTwo() throws -> Any {
        //create new grid. populate lines between
        var floor = Grid<Character>()
        for i in 0..<redTiles.count {
            let this = redTiles[i]
            floor.Points[this] = "#"
            let next = (i+1 == redTiles.count) ? redTiles[0] : redTiles[i+1]
            //line between this and next is green
            if this.x == next.x {
                let lower = min(this.y, next.y)
                let higher = max(this.y, next.y)
                for y in lower+1..<higher {
                    if floor[this.x, y] == nil {
                        floor.Points[Point(this.x, y)] = "X"
                    }
                }
            } else {
                let lower = min(this.x, next.x)
                let higher = max(this.x, next.x)
                for x in lower+1..<higher {
                    if floor[x, this.y] == nil {
                        floor.Points[Point(x, this.y)] = "X"
                    }
                }
            }
        }
        let fencePosts = findFencePosts(of: floor)
        /*
        for post in fencePosts {
            floor.Points[post] = "O"
        }
         */
        //skip fill insides, will be millions of points...
        //floor.resetBounds()
        //floor.printGrid(valuePrintFunction: { $0 }, onlyPopulated: true)
        //repeat area size, check, but now every side of the rectangle must have tiles on it's entire length
        var maxArea:Int = 0
        for i in 0..<redTiles.count {
            let firstCorner = redTiles[i]
        cornerLoop:
            for j in i+1..<redTiles.count {
                let secondCorner = redTiles[j]
                let area = area(from: firstCorner, to: secondCorner)
                if area > maxArea {
                    if firstCorner.x == secondCorner.x || firstCorner.y == secondCorner.y {
                        maxArea = area
                        continue cornerLoop
                    }
                    let rectangleMaxX = max(firstCorner.x, secondCorner.x)
                    let rectangleMinX = min(firstCorner.x, secondCorner.x)
                    let rectangleMaxY = max(firstCorner.y, secondCorner.y)
                    let rectangleMinY = min(firstCorner.y, secondCorner.y)
                    if fencePosts.allSatisfy( {
                        $0.x < rectangleMinX || $0.x > rectangleMaxX || $0.y < rectangleMinY || $0.y > rectangleMaxY
                    }) {
                        maxArea = area
                    }
                    
                    
                }
            }
        }
        return maxArea
        
    }
    
    func findFencePosts(of grid:Grid<Character>) -> Set<Point> {
        var fencePosts: Set<Point> = []
        //first go diagonally until a wall is found
        var onWall = false
        var current = Point(0,0)
        
        while !onWall {
            let rightOne = current.move(by: Point(1,0))
            if grid.Points[rightOne] != nil {
                //current is next to the shape so it is a fence post
                fencePosts.insert(current)
                onWall = true
                break
            } else {
                let downOne = rightOne.move(by: Point(0,1))
                if grid.Points[downOne] != nil {
                    //rightOne is next to the shape so it is a fence post
                    fencePosts.insert(rightOne)
                    current = rightOne
                    onWall = true
                    break
                } else {
                    current = downOne
                }
            }
            
        }
        //now go around the shape
        var frontier = current.getAdjacentNeighbours()
        while !frontier.isEmpty {
            current = frontier.removeFirst()
            if grid.Points[current] != nil {
                continue
            }
            
            if !fencePosts.contains(current) {
                //is it next to the shape?
                let fenceNeighbours = current.getAdjacentNeighbours().filter { grid.Points[$0] != nil }
                if fenceNeighbours.isEmpty {
                    continue
                }
                fencePosts.insert(current)
                let notFenceNeighbours = current.getAdjacentNeighbours().filter { grid.Points[$0] == nil && !fencePosts.contains($0) }
                frontier.append(contentsOf: notFenceNeighbours)
            }
        }
        return fencePosts
    }


}
