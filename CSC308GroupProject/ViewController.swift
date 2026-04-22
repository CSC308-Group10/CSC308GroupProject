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
    var names = ["Player 1", "Player 2"]
    var colors: [UIColor] = [.yellow, .red]
    
    var selectedMember = ""
    var selectedTopic = ""
    var selectedImage = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = Colors.bgColor
    }
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue){
        if let sourceVC = sender.source as? CustomizeViewController {
            if let p1Name = sourceVC.player1NameField.text, !p1Name.isEmpty {
                names[0] = p1Name
            } else {
                names[0] = "Player 1"
            }
            
            let p1Color = sourceVC.p1Color
            colors[0] = p1Color
            if let p2Name = sourceVC.player2NameField.text, !p2Name.isEmpty {
                names[1] = p2Name
            } else {
                names[1] = "Player 2"
            }
            let p2Color = sourceVC.p2Color
            colors[1] = p2Color
            debugPrint(names[0], names[1], colors[0], colors[1])
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modeSegue" {
            guard let dest = segue.destination as? PlayModeController else {
                return
            }
            dest.oneName = names[0]
            dest.twoName = names[1]
            dest.oneColor = colors[0]
            dest.twoColor = colors[1]
        }
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
            return "Customize your players"
        default:
            return nil
        }
    }
    
    
}

