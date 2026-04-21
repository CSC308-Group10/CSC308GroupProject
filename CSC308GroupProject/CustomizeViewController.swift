//
//  CustomizeViewController.swift
//  CSC308GroupProject
//
//  Created by Goodman, Dakota K. on 4/19/26.
//

import UIKit

class CustomizeViewController: UIViewController {

    let colorOptions: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple, .systemBrown]
    
    @IBOutlet weak var player1NameField: UITextField!
    @IBOutlet weak var player1ColorButton: UIButton!
    @IBOutlet weak var player2NameField: UITextField!
    @IBOutlet weak var player2ColorButton: UIButton!
    
    var p1Color: UIColor = .systemYellow
    var p2Color: UIColor = .systemRed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu(for: player1ColorButton)
        setupMenu(for: player2ColorButton)
        // Do any additional setup after loading the view.
    }
    

    func setupMenu(for button: UIButton) {
        // Create an array of UIAction objects from your colors
        var currColorOptions = colorOptions
        if(button == self.player1ColorButton) {
            currColorOptions.remove(at: colorOptions.firstIndex(of: p2Color) ?? -1)
            
        } else {
            currColorOptions.remove(at: colorOptions.firstIndex(of: p1Color) ?? -1)
        }
        let menuElements = currColorOptions.map { color in
            UIAction(title: color.accessibilityName.capitalized) { action in
                if(button == self.player1ColorButton) {
                    self.p1Color = color
                    self.setupMenu(for: self.player1ColorButton)
                    self.setupMenu(for: self.player2ColorButton)
                } else {
                    self.p2Color = color
                    self.setupMenu(for: self.player1ColorButton)
                    self.setupMenu(for: self.player2ColorButton)
                }
            }
        }

        // Wrap the actions in a UIMenu
        button.menu = UIMenu(title: "Choose a Color", children: menuElements)

        // Enable pull-down behavior
        // Shows the menu on a single tap
        button.showsMenuAsPrimaryAction = true
        
        // Automatically updates the button title to the selected color
        //button.changesSelectionAsPrimaryAction = true
        if(button == self.player1ColorButton) {
            button.setTitle(p1Color.accessibilityName.capitalized, for: .normal)
        } else {
            button.setTitle(p2Color.accessibilityName.capitalized, for: .normal)
        }
    }

}
