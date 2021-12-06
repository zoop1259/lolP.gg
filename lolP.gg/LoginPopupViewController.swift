//
//  LoginPopViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/02.
//

import Foundation
import UIKit

class LoginPopupViewController: UIViewController {
    
    @IBOutlet var popup: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //모서리를 둥글게둥글게
        popup.layer.cornerRadius = 30
    }
    
}
