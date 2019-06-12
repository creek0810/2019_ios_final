//
//  WeatherTableViewCell.swift
//  2019_ios_final
//
//  Created by User15 on 2019/6/12.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var feltTempLabel: UILabel!
    @IBOutlet weak var realTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
