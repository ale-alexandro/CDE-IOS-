//
//  SettingsTableViewController.swift
//  API
//
//  Created by 4lex@ndr0 on 15/03/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBAction func logoutBtnTapped(_ sender: Any) {
        let defaults = UserDefaults.init(suiteName: "group.alexandro.cde")!
        
        defaults.set(nil, forKey: "login")
        defaults.set(nil, forKey: "password")
        defaults.set(nil, forKey: "studyYear")
        defaults.set(nil, forKey: "sem")
        
        defaults.synchronize()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "login_screen") as! LoginViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clear
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
