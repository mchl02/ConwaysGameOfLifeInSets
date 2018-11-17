//
//  main.swift
//  ConwaysGameOfLifeInSets
//
//  Created by ws on 11/16/18.
//  Copyright © 2018 mchl02. All rights reserved.
//


import Foundation

class Coor: Hashable {
    let row: Int
    let column: Int
    
    init(_ x_coor: Int, _ y_coor: Int) {
        self.row = x_coor
        self.column = y_coor
    }
    
    var hashValue: Int {
        return(pair(row, column))
    }
    func pair(_ row: Int, _ column: Int) -> Int {
        return ((row + column) * (row + column + 1) / 2) + column
    }
    static func == (lhs: Coor, rhs: Coor) -> Bool {
        return (lhs.row == rhs.row) && (lhs.column == rhs.column)
    }
}

class Colony: CustomStringConvertible {
    var s = Set<Coor>()
    var colonySize: Int
    var gen = 0
    
    init() {
        self.colonySize = 20
        self.s = Set<Coor>()
    }
    
    func setCellAlive(xCoor: Int, yCoor: Int) {
        s.insert(Coor(xCoor, yCoor))
    }
    
    func setCellDead(xCoor: Int, yCoor: Int) {
        s.remove(Coor(xCoor, yCoor))
    }
    
    func isCellAlive(xCoor: Int, yCoor: Int) -> Bool {
        return s.contains(Coor(xCoor, yCoor))
    }
    
    func neighboring(xCoor: Int, yCoor: Int) -> Set<Coor> {
        var neighbor = Set<Coor>()
        neighbor.insert(Coor(xCoor-1, yCoor-1))
        neighbor.insert(Coor(xCoor, yCoor-1))
        neighbor.insert(Coor(xCoor+1, yCoor-1))
        neighbor.insert(Coor(xCoor-1, yCoor))
        neighbor.insert(Coor(xCoor+1, yCoor))
        neighbor.insert(Coor(xCoor-1, yCoor+1))
        neighbor.insert(Coor(xCoor, yCoor+1))
        neighbor.insert(Coor(xCoor+1, yCoor+1))
        return neighbor
    }
    
    func neighboringCount(_ x: Int, _ y: Int) -> Int {
        return neighboring(xCoor: x, yCoor: y).filter( {isCellAlive(xCoor: $0.row, yCoor: $0.column)} ).count
    }
    
    func decide(_ row: Int, _ col: Int) -> Bool {
        let count = neighboringCount(row, col)
        if count == 3 {
            return true
        } else if count == 2 && isCellAlive(xCoor: row, yCoor: col) {
            return true
        } else {
            return false
        }
    }
    
    func resetColony(){
        s = Set<Coor>()
        gen = 0
    }
    
    var description: String {
        var result = ""
        result += "Generation #\(gen)\n"
        for row in 0..<colonySize {
            for col in 0..<colonySize {
                result += isCellAlive(xCoor: row, yCoor: col) ? "*" : " "
            }
            result += "\n"
        }
        return result
    }
    
    
    func evolve() {
        var s1 = Set<Coor>()
        s1 = Set( s.map( { neighboring(xCoor: $0.row, yCoor: $0.column) })
            .flatMap({$0}) )
        
        s = Set( s1.filter( {decide($0.row, $0.column)} ) )
        gen += 1
        
    }
}

var c = Colony()
c.setCellAlive(xCoor: 5, yCoor: 5)
c.setCellAlive(xCoor: 5, yCoor: 6)
c.setCellAlive(xCoor: 5, yCoor: 7)
c.setCellAlive(xCoor: 6, yCoor: 6)
c.setCellAlive(xCoor: 17, yCoor: 17)
c.setCellAlive(xCoor: 17, yCoor: 18)
c.setCellAlive(xCoor: 17, yCoor: 19)
c.setCellAlive(xCoor: 18, yCoor: 18)

print(c)

for _ in 0..<10{
    c.evolve()
    print(c)
}


