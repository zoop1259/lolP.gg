//
//  ChampDetailView.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/01/11.
//

import Foundation
import UIKit

class ChampDetailView : UIViewController {
    
    
    @IBOutlet var detailImg: UIImageView!
    @IBOutlet var detailName: UILabel!

    var VCImg : UIImage?
    var VCName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vcimg = VCImg {
            //본문을 보여준다.
            self.detailImg.image = vcimg
        }
        
        if let vcname = VCName {
            //본문을 보여준다.
            self.detailName.text = vcname
        }
        
    }
    
}


