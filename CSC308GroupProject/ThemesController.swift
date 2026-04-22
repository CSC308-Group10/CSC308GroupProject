//
//  ThemesController.swift
//  CSC308GroupProject
//
//  Created by Morgan, Greyson F. on 4/21/26.
//

import UIKit

class ThemesController: UIViewController {

    @IBAction func pastelDarkButtonHit(_ sender: Any) {
        Colors.bgColor = Colors.darkBG
        Colors.chipOptions = Colors.pastelChipOptions
    }
    @IBAction func pastelLightButtonHit(_ sender: Any) {
        Colors.bgColor = Colors.lightBG
        Colors.chipOptions = Colors.pastelChipOptions
    }
    @IBAction func darkButtonHit(_ sender: Any) {
        Colors.bgColor = Colors.darkBG
        Colors.chipOptions = Colors.normChipOptions
    }
    @IBAction func lightButtonHit(_ sender: Any) {
        Colors.bgColor = Colors.lightBG
        Colors.chipOptions = Colors.normChipOptions
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Colors.bgColor = Colors.lightBG
        Colors.chipOptions = Colors.normChipOptions
        view.backgroundColor = Colors.bgColor
    }

}

struct Colors {
    static var bgColor: UIColor = .systemGray5
    static var chipOptions: [UIColor] = []
    static let pastelChipOptions: [UIColor] = [UIColor(named: "pastel-red")!, UIColor(named: "pastel-orange")!, UIColor(named: "pastel-yellow")!, UIColor(named: "pastel-green")!, UIColor(named: "pastel-blue")!, UIColor(named: "pastel-purple")!, UIColor(named: "pastel-brown")!]
    static let normChipOptions: [UIColor] = [UIColor(named: "norm-red")!, UIColor(named: "norm-orange")!, UIColor(named: "norm-yellow")!, UIColor(named: "norm-green")!, UIColor(named: "norm-blue")!, UIColor(named: "norm-purple")!, UIColor(named: "norm-brown")!]
    static let darkBG: UIColor = UIColor(named: "dark-bg")!
    static let lightBG: UIColor = UIColor(named: "light-bg")!
}
