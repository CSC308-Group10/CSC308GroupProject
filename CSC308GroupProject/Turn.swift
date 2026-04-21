//
//  Turn.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/21/26.
//

import Foundation
import UIKit

enum Turn {
    case Red
    case Yellow
}

var currTurn = Turn.Yellow

func toggleTurn(_ turnName: UILabel) {
    if yellowTurn() {
        currTurn = Turn.Red
        turnName.text = "Red"
    } else {
        currTurn = Turn.Yellow
        turnName.text = "Yellow"
    }
}

func yellowTurn() -> Bool {
    return currTurn == Turn.Yellow
}

func redTurn() -> Bool {
    return currTurn == Turn.Red
}

func currTurnTile() -> Tile {
    return yellowTurn() ? Tile.Yellow : Tile.Red
}

func currTurnColor() -> UIColor {
    return yellowTurn() ? .yellow : .red
}

func currTurnVictoryMessage() -> String {
    return yellowTurn() ? "Yellow Wins!" : "Red Wins!"
}
