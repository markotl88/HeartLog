//
//  ReadingHeaderCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class ReadingHeaderCell: UITableViewCell {

    @IBOutlet weak var readingHeaderLabel: SubtitleLabel!
    @IBOutlet weak var borderLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderLine.backgroundColor = UIColor.dmsCloudyBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
