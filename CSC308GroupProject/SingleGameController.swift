//
//  SingleGameController.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/21/26.
//

import UIKit

class SingleGameController: UIViewController {
    
    // variable to change game mode
    var mode: Mode?
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var turnLabel: UILabel!
    
    var oneScore = 0
    var twoScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBoard()
        setCellWidthHeight()
        turnLabel.text = "Player One" // TODO: add name customization
        collView.reloadData()
    }
    
    func setCellWidthHeight() {
        let width = collView.frame.size.width/9
        let height = collView.frame.size.height/6
        let flowLayout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

}

extension SingleGameController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return board.count
    }
}

extension SingleGameController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return board[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BoardCell
        let boardItem = getBoardItem(indexPath)
        cell.image.tintColor = boardItem.tileColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let col = indexPath.item
        if var boardItem = getLowestEmptyBoardItem(col) {
            if let cell = collView.cellForItem(at: boardItem.indexPath) as? BoardCell {
                cell.image.tintColor = currTurnColor()
                boardItem.tile = currTurnTile()
                updateBoardWithBoardItem(boardItem)
                
                if victoryAchieved() {
                    if redTurn() {
                        oneScore += 1
                    }
                    
                    if yellowTurn() {
                        twoScore += 1
                    }
                    
                    resultAlert(currTurnVictoryMessage())
                }
                
                if boardIsFull() {
                    resultAlert("Draw")
                }
                
                toggleTurn(turnLabel)
            }
        }
    }
    
    func resultAlert(_ title: String) {
        let message = "\nOne: \(oneScore)\n\nTwo: \(twoScore)"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Reset", style: .default, handler: {
            [self] (_) in
            resetBoard()
            self.resetCells()
        })
        ac.addAction(action)
        self.present(ac, animated: true)
    }
    
    func resetCells() {
        for cell in collView.visibleCells as! [BoardCell] {
            cell.image.tintColor = .white
        }
    }
}
