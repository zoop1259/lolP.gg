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
    
    var imageUrl : String?
    var desc : String?
    var tesc : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let mai = tesc {
            //본문내용을 보여준다.
            self.detailLabel.text = mai
        }
        
        if let sub = desc {
            //타이틀을 보여준다.
            self.detailtitleLabel.text = sub
        }
        
    }
}
