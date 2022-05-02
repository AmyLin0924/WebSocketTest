//
//  HeaderTableViewCell.swift
//  WebSocketTest
//
//  Created by 哈哈涵 on 2022/5/1.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var m_lbTime: UILabel!
    @IBOutlet weak var m_lbPrice: UILabel!
    @IBOutlet weak var m_lbCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
