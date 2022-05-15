//
//  CommuDetailCell.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/05/15.
//

import UIKit

class CommuDetailCell: UITableViewCell {

    static let identifier = "CommuDetailCell"
    
    @IBOutlet weak var detailtitleLabel: UILabel!
    @IBOutlet weak var detailnicknameLabel: UILabel!
    @IBOutlet weak var detaildateLabel: UILabel!
    @IBOutlet weak var detailtextLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CommuDetailCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
