//
//  CommuButtonCell.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/05/15.
//

import UIKit

class CommuButtonCell: UITableViewCell {

    static let identifier = "CommuButtonCell"
    @IBOutlet weak var commenttextField: UITextField!
    @IBOutlet weak var commentBtn: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "CommuButtonCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
