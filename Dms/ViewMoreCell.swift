//
//  ViewMoreCell.swift
//  FTN
//
//  Created by Marko Stajic on 12/21/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class ViewMoreCell: UITableViewCell {

    @IBOutlet weak var viewMoreButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.dmsPaleGrey
        viewMoreButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsPaleGrey, titleColor: UIColor.dmsOffBlue, highlightedColor: UIColor.dmsPaleGreyHighlighted)
        viewMoreButton.setEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
