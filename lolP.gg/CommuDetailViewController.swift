//
//  CommuDetailViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/02.
//

import UIKit

class CommuDetailViewController : UIViewController {
    
    @IBOutlet var ImageMain: UIImageView!
    @IBOutlet var detailtitleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    var detailTitle: String?
    var imageUrl : String?
    var desc : String?
    var tesc : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detailTitle = detailTitle {
            self.detailtitleLabel.text = detailTitle
        }
    }
}
