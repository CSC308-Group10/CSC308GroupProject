//
//  CustomizeViewController.swift
//  CSC308GroupProject
//
//  Created by Goodman, Dakota K. on 4/19/26.
//

import UIKit

class CustomizeViewController: UIViewController {

    var colors = ["yellow", "red"]
    var names = ["Player 1", "Player 2"]
    
    @IBOutlet weak var player1NameField: UITextField!
    @IBOutlet weak var player1ColorButton: UIButton!
    @IBOutlet weak var player2NameField: UITextField!
    @IBOutlet weak var player2ColorButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
