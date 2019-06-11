//
//  ProfileUITaTableViewCell.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/11.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class ProfileUITaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
