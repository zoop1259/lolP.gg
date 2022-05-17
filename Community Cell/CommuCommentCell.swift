//
//  CommuCommentCell.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/05/15.
//

import UIKit

class CommuCommentCell: UITableViewCell {

    static let identifier = "CommuCommentCell"
    
    @IBOutlet weak var commenttextLabel: UILabel!
    @IBOutlet weak var commentnicknameLabel: UILabel!
    @IBOutlet weak var commentdateLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "CommuCommentCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
