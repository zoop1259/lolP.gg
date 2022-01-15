//
//  ChampDetailView.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/01/11.
//

import Foundation
import UIKit

public class ChampDetailView : UIViewController {
    
    
    @IBOutlet var detailImg: UIImageView!
    @IBOutlet var detailName: UILabel!

    public var VCImg : String?
    public var VCName : String?
    
//    public override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        var VC = ViewController()
//        //detailName.text = VC.nameLabel
//        //detailImg.image = VC.enarr
//    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        if let vcname = VCName {
            //본문을 보여준다.
            self.detailName.text = vcname
            print("챔프디테일에서의 vcname값 : \(vcname)")
        }
        
        if let vcimg = VCImg {
            
            if let data = try? Data(contentsOf: URL(string: "http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(vcimg).png")!) {
                DispatchQueue.main.async {
                    self.detailImg.image = UIImage(data: data)
                    print("챔프디테일에서의 vcimg값 : \(vcimg)")
                }
            }
        }
    }
    
}


