//
//  ChangesViewController.swift
//  API
//
//  Created by 4lex@ndr0 on 10/03/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import UIKit

class ChangesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var eregister_log: EregisterLog? = nil
    var days: String = "60"
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eregister_log != nil {
            return eregister_log!.getProtocolCount()
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LogCell = self.tableView.dequeueReusableCell(withIdentifier: "logcell") as! LogCell
        
        let subject = eregister_log!.getProtocolElement(num: indexPath.row)["subject"] as! String
        let name = (eregister_log!.getProtocolElement(num: indexPath.row)["var"]! as! [String: Any])["name"] as! String
        let sign = eregister_log!.getProtocolElement(num: indexPath.row)["sign"] as! String
        let date = eregister_log!.getProtocolElement(num: indexPath.row)["date"] as! String
        
        var value: String
        if eregister_log!.getProtocolElement(num: indexPath.row)["value"] != nil {
            value = eregister_log!.getProtocolElement(num: indexPath.row)["value"] as! String
        } else { value = "0" }
        
        let max = (eregister_log!.getProtocolElement(num: indexPath.row)["var"]! as! [String: Any])["max"] as! String
        let threshold = Int((eregister_log!.getProtocolElement(num: indexPath.row)["var"]! as! [String: Any])["threshold"] as! String)
        
        if threshold != nil {
            if (value as NSString).floatValue >= Float(threshold!) {
                cell.name.textColor = UIColor.init(red: 0.0, green: 0.7, blue: 0.05, alpha: 1.0)
                cell.subject.textColor = UIColor.init(red: 0.0, green: 0.7, blue: 0.05, alpha: 1.0)
                cell.Amount.textColor = UIColor.init(red: 0.0, green: 0.7, blue: 0.05, alpha: 1.0)
            }
        } else {
            cell.name.textColor = UIColor.black
            cell.subject.textColor = UIColor.black
            cell.Amount.textColor = UIColor.black
        }
        
        let first_index = subject.firstIndex(of: "(") ?? subject.endIndex
        cell.subject.text = String(subject[..<first_index])
        
        if value != nil { cell.Amount.text = value } else { cell.Amount.text = "0"}
        cell.sign.text = date + " (" + sign + ")"
        cell.name.text = name
        cell.threshold.text = "Из " + max
        
        return cell
    }
    
    func loadData() {
        guard let eregisterLog_method = URL(string: "https://de.ifmo.ru/api/private/eregisterlog?days=" + days) else { print("Error ChangesVC:31"); return }
        let semaphore: DispatchSemaphore = DispatchSemaphore.init(value: 0)
        URLSession.shared.dataTask(with: eregisterLog_method) { (data, response, error) in
            guard let data = data else {print("Error Changes VC:33"); return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.eregister_log = EregisterLog(rawJsonData: json as! NSArray)
            } catch let error
            {
                print(error)
                semaphore.signal()
            }
            semaphore.signal()
            }.resume()
        semaphore.wait()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        DispatchQueue.main.async {
            self.loadData()
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        //self.tableView.refreshControl?.beginRefreshing()
        refresh(sender: self.tableView.refreshControl!)
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
