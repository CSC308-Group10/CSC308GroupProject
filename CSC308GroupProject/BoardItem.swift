//
//  BoardItem.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/21/26.
//

import Foundation
import UIKit

enum Tile {
    case One
    case Two
    case Empty
}

struct BoardItem {
    var indexPath: IndexPath!
    var tile: Tile!
    
    func oneTile() -> Bool {
        return tile == Tile.One
    }
    
    func twoTile() -> Bool {
        return tile == Tile.Two
    }
    
    func emptyTile() -> Bool {
        return tile == Tile.Empty
    }
    
    func tileColor() -> UIColor {
        if oneTile() {
            return SingleGameController.oneColor
        }
        if twoTile() {
            return SingleGameController.twoColor
        }
        return .white
    }
}
