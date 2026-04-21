//
//  PlayModeController.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/16/26.
//

import UIKit

class PlayModeController: UIViewController {
    
    var mode = Mode.SP
    
    // player names, default to One and Two
    var oneName: String = "One"
    var twoName: String = "Two"
    
    // player colors, default to yellow and red
    var oneColor: UIColor = .yellow
    var twoColor: UIColor = .red
    
    @IBAction func playButtonPressed(_ sender: Any) {
        switch mode {
        case .SP:
            self.performSegue(withIdentifier: "singleSegue", sender: self)
            break
        default:
            self.performSegue(withIdentifier: "playSegue", sender: self)
            break
        }
        
    }
    @IBOutlet weak var modeDescText: UITextView!
    
    
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // single player selected
            modeDescText.text = "Single Player\n\nIn single player mode, you play against Al the AI, trying to create a row, column, or diagonal of four chips before it can."
            mode = Mode.SP
            break
        case 1: // two player selected
            modeDescText.text = "Two Player\n\nIn two player mode, you and a friend can play against each other, taking turns trying to make a row, column, or diagonal of your chips before they can."
            mode = Mode.TP
            break
        case 2: // two player timed selected
            modeDescText.text = "Two Player Timed\n\nIn two player timed mode, you and a friend can play against each other, trying to make a row, column, or diagonal of your chips before they can. But be careful! If you don't place your chip in time, your turn is skipped and play moves to the next player!"
            mode = Mode.TPT
            break
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        modeDescText.text = "Single Player\n\nIn single player mode, you play against Al the AI, trying to create a row, column, or diagonal of four chips before it can."
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playSegue" {
            guard let dest = segue.destination as? GameController else {
                return
            }
            dest.mode = mode
        } else if segue.identifier == "singleSegue" {
            SingleGameController.oneName = oneName
            SingleGameController.twoName = twoName
            SingleGameController.oneColor = oneColor
            SingleGameController.twoColor = twoColor
        }
    }

}

enum Mode {
    case SP
    case TP
    case TPT
}
