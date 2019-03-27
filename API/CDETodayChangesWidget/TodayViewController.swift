//
//  TodayViewController.swift
//  CDETodayChangesWidget
//
//  Created by 4lex@ndr0 on 15/03/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, /*UITableViewDelegate, UITableViewDataSource,*/ NCWidgetProviding {
    
    let defaults = UserDefaults.init(suiteName: "group.alexandro.cde")!, days = 1
    var session: CDESession? = nil, eregister_log: EregisterLog? = nil
   
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var password: UILabel!
    /*@IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eregister_log!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodayViewLogCell = self.tableView.dequeueReusableCell(withIdentifier: "todayview_logcell") as! TodayViewLogCell
        
        let subject = eregister_log!.getProtocolElement(num: indexPath.row)["subject"] as! String
        let name = (eregister_log!.getProtocolElement(num: indexPath.row)["var"]! as! [String: Any])["name"] as! String
        var value: String
        if eregister_log!.getProtocolElement(num: indexPath.row)["value"] != nil {
            value = eregister_log!.getProtocolElement(num: indexPath.row)["value"] as! String
        } else { value = "0" }
        
        cell.subject.text = "test"
        //cell.criteria.text = name
        //cell.amount.text = value
        
        return cell
    }
    */
    
    func loadData() -> Bool{
        var result = false
        
        let login = defaults.string(forKey: "login")!
        let password = defaults.string(forKey: "password")!
        
        self.login.text = login
        self.password.text = password
        print(password)
        
        do {
            session = try CDESession(login: login, passwd: password)
        } catch {
            return result
        }
        
        guard let url = URL(string: "https://de.ifmo.ru/api/private/eregisterlog?days=30") else { return result }
        let semaphore = DispatchSemaphore.init(value: 0)
        self.session!.session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                print(json)
                self.eregister_log! = EregisterLog(rawJsonData: json)
                result = true
            } catch let error {
                print(error)
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        
        return result
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        let login = defaults.string(forKey: "login")!
        let password = defaults.string(forKey: "password")!
        
        self.login.text = login
        self.password.text = password
        //tableView.delegate = self
        //tableView.dataSource = self
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        let login = defaults.string(forKey: "login")!
        let password = defaults.string(forKey: "password")!
        
        self.login.text = login
        self.password.text = password
        //if loadData() {
            //tableView.reloadData()
            //completionHandler(NCUpdateResult.newData)
        //}
        completionHandler(NCUpdateResult.newData)
        
    }
    
}
