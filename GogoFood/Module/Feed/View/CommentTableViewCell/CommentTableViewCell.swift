//
//  CommentTableViewCell.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 21/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet var userImage : UIImageView!
    @IBOutlet var usernameLbl : UILabel!
    @IBOutlet var commentLbl : UILabel!
    
    @IBOutlet var restaurantImg : UIImageView!
    @IBOutlet var restaurantReply : UILabel!
    
    @IBOutlet var replyBtn : UIButton!
    var tapOnReplyButton: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func replyBtnClicked(_ sender: UIButton) {
        tapOnReplyButton()
    }
}
