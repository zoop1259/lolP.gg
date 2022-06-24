//
//  TestLoginView.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/06/24.
//

import Foundation
import UIKit
import FirebaseAuth

class TestLoginView: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = Auth.auth().currentUser?.email
        nickLabel.text = Auth.auth().currentUser?.displayName ?? "별명이없다"
        uuidLabel.text = Auth.auth().currentUser?.uid
        
    }
    
    
}
