//
//  Board.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/21/26.
//

import Foundation
import UIKit

var board = [[BoardItem]]()

func resetBoard() {
    board.removeAll()
    
    for row in 0...5 {
        var rowArray = [BoardItem]()
        for col in 0...6 {
            let indexPath = IndexPath.init(item: col, section: row)
            let boardItem = BoardItem(indexPath: indexPath, tile: Tile.Empty)
            rowArray.append(boardItem)
        }
        board.append(rowArray)
    }
}

func getBoardItem(_ indexPath: IndexPath) -> BoardItem {
    return board[indexPath.section][indexPath.row]
}

func getLowestEmptyBoardItem(_ col: Int) -> BoardItem? {
    for row in (0...5).reversed() {
        let boardItem = board[row][col]
        if boardItem.emptyTile() {
            return boardItem
        }
    }
    return nil
}

func updateBoardWithBoardItem(_ boardItem: BoardItem) {
    if let indexPath = boardItem.indexPath {
        board[indexPath.section][indexPath.item] = boardItem
    }
}

func boardIsFull() -> Bool {
    for row in board {
        for col in row {
            if col.emptyTile() {
                return false
            }
        }
    }
    return true
}

func victoryAchieved() -> Bool {
    return horVictory() || vertVictory() || diagVictory()
}

func diagVictory() -> Bool {
    for col in 0...board.count {
        if checkDiagCol(col, true, true) {
            return true
        }
        if checkDiagCol(col, true, false) {
            return true
        }
        if checkDiagCol(col, false, true) {
            return true
        }
        if checkDiagCol(col, false, false) {
            return true
        }
    }
    return false
}

func checkDiagCol(_ colToCheck: Int, _ moveUp: Bool, _ reverseRows: Bool) -> Bool {
    var movingCol = colToCheck
    var consecutive = 0
    if reverseRows {
        for row in board.reversed() {
            if movingCol < row.count && movingCol >= 0 {
                if row[movingCol].tile == currTurnTile() {
                    consecutive += 1
                    if consecutive >= 4 {
                        return true
                    }
                } else {
                    consecutive = 0
                }
                movingCol = moveUp ? movingCol + 1 : movingCol - 1
            }
        }
    }
    return false
}

func vertVictory() -> Bool {
    for col in 0...board.count {
        if checkVertCol(col) {
            return true
        }
    }
    return false
}

func checkVertCol(_ colToCheck: Int) -> Bool {
    var consecutive = 0
    for row in board {
        if row[colToCheck].tile == currTurnTile() {
            consecutive += 1
            if consecutive >= 4 {
                return true
            }
        } else {
            consecutive = 0
        }
    }
    return false
}

func horVictory() -> Bool {
    for row in board {
        var consecutive = 0
        for col in row {
            if col.tile == currTurnTile() {
                consecutive += 1
                if consecutive >= 4 {
                    return true
                }
            } else {
                consecutive = 0
            }
        }
    }
    return false
}
