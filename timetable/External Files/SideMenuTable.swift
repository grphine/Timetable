//
//  SideMenuTableViewController.swift
//  timetable
//
//  Created by Juheb on 10/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import SideMenu

class SideMenuTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh cell blur effect in case it changed
        tableView.reloadData()
        
        /*
         // Set up a cool background image for demo purposes
         let imageView = UIImageView(image: UIImage(named: "saturn"))
         imageView.contentMode = .scaleAspectFit
         imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
         tableView.backgroundView = imageView
         
         */

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
        
        //cell.blurEffectStyle = SideMenuManager.default.menuBlurEffectStyle
        
        return cell
    }



}





