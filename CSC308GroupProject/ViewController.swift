//
//  ViewController.swift
//  CSC308GroupProject
//
//  Created by Morgan, Ashley F. on 4/7/26.
//

import UIKit

class ViewController: UIViewController {

    let gameTable = ["Play", "Themes", "Player Customization"]
    let theme = ["Dark", "Light", "Pastel", "Dark Pastel"]
    let names = ["Player 1", "Player 2"]
    
    var selectedMember = ""
    var selectedTopic = ""
    var selectedImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch(indexPath.row) {
                case 0:
                    // Play hit
                    self.performSegue(withIdentifier: "memberSegue", sender: self)
                    break
                case 1:
                    // Themes hit
                    self.performSegue(withIdentifier: "memberSegue", sender: self)
                    break
                case 2:
                    // Player Customization hit
                    self.performSegue(withIdentifier: "memberSegue", sender: self)
                    break
                default:
                    break
            }
        
    }
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("#1. ", #function)
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    //This method is called repeatedly
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("#1. ", #function, indexPath)
       //#1. Get or reuse a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //#2. Put data into the cell
        switch indexPath.section{
        case 0:
            cell.textLabel?.text = gameTable[indexPath.row]
        case 1:
            cell.textLabel?.text = gameTable[indexPath.row]
        case 2:
            cell.textLabel?.text = gameTable[indexPath.row]
        default:
            break
        }
        
        //#3. Return the cell
        return cell //for a cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Play"
        case 1:
            return "Themes"
        case 2:
            return "Player Customization"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Choose game modes"
        case 1:
            return "Choose different themes"
        case 2:
            return "Customize yuor players"
        default:
            return nil
        }
    }
    
    
}

