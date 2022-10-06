//
//  InviteeDetailViewController.swift
//  GogoFood
//
//  Created by MAC on 30/03/20.
//  Copyright © 2020 GWS. All rights reserved.
//

import UIKit

class InviteDetailViewController: BaseTableViewController<BaseData> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavigationLeftButton(NavigationTitleString.inviteDetail)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    

   

}
