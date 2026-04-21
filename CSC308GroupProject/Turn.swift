//
//  Turn.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/21/26.
//

import Foundation
import UIKit

enum Turn {
    case One
    case Two
}

var currTurn = Turn.One

func toggleTurn(_ turnName: UILabel) {
    if oneTurn() {
        currTurn = Turn.Two
        turnName.text = "\(SingleGameController.twoName)"
    } else {
        currTurn = Turn.One
        turnName.text = "\(SingleGameController.oneName)"
    }
}

func setTurn(_ turnName: UILabel, _ turn: Turn) {
    currTurn = turn
    turnName.text = (turn == Turn.One) ? "\(SingleGameController.oneName)" : "\(SingleGameController.twoName)"
}

func oneTurn() -> Bool {
    return currTurn == Turn.One
}

func twoTurn() -> Bool {
    return currTurn == Turn.Two
}

func currTurnTile() -> Tile {
    return oneTurn() ? Tile.One : Tile.Two
}

func currTurnColor() -> UIColor {
    return oneTurn() ? SingleGameController.oneColor : SingleGameController.twoColor
}

func currTurnVictoryMessage() -> String {
    return oneTurn() ? "\(SingleGameController.oneName) Wins!" : "\(SingleGameController.twoName) Wins!"
}
