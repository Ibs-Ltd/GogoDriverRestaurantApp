//
//  InviteAndEarnViewController.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 17/02/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class InviteAndEarnViewController: BaseViewController<BaseData> {

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.createNavigationLeftButton(NavigationTitleString.inviteAndEarn)
        setNavigationTitleTextColor(NavigationTitleString.inviteAndEarn)

    }
    @IBAction func showInviteDetail(_ sender: UIBarButtonItem) {
        let vc: InviteDetailViewController = self.getViewController(.inviteDetail, on: .inviteAndEarn)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
