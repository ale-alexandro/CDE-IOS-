//
//  SubjectViewController.swift
//  API
//
//  Created by 4lex@ndr0 on 09/03/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import UIKit
import CoreGraphics

class SubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var reg: Eregister?, studyYear: String?, semester: Int?, subject: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reg!.getPoints(styear: self.studyYear!, semester: self.semester!, subject: subject!).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lock:NSLock = NSLock.init()
        lock.lock()
        
        let point = reg?.getPoints(styear: studyYear!, semester: semester!, subject: subject!)[indexPath.row]
        let cell: PointsCell = self.tableView.dequeueReusableCell(withIdentifier: "cell_points") as! PointsCell
    
        cell.limit.text = "Порог: " + point!["limit"]! + " Макс.:" + point!["max"]!
        cell.variable.text = point!["variable"]
        cell.value.text = point!["value"]
        
        let firstSpace = cell.variable.text!.firstIndex(of: " ") ?? cell.variable.text!.endIndex
        if cell.variable.text![..<firstSpace] == "Семестр" || cell.variable.text![..<firstSpace] == "Экзамен" || cell.variable.text![..<firstSpace] == "Зачёт" {
            //cell.backgroundColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            cell.limit.textColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            cell.variable.textColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            cell.value.textColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            cell.value.font = UIFont.boldSystemFont(ofSize: 21.0)
            cell.variable.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.limit.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        else if cell.variable.text![..<firstSpace] == "Модуль" {
            //cell.backgroundColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.75)
            cell.limit.textColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.75)
            cell.variable.textColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.75)
            cell.value.textColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.75)
        }
        else {
            //cell.backgroundColor = UIColor.white
            cell.limit.textColor = UIColor.gray
            cell.variable.textColor = UIColor.black
            cell.value.textColor = UIColor.black
            
            cell.variable.font = UIFont.systemFont(ofSize: 17.0)
            cell.limit.font = UIFont.systemFont(ofSize: 16.0)
            cell.value.font = UIFont.systemFont(ofSize: 21.0)
        }
        
        lock.unlock()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = subject
        //adjustLargeTitleSize() Not beatiful but useful 
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UIViewController {
    func adjustLargeTitleSize() {
        guard let title = title, #available(iOS 11.0, *) else { return }
        
        let maxWidth = UIScreen.main.bounds.size.width - 60
        var fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        var width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
        
        while width > maxWidth {
            fontSize -= 1
            width = title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]).width
        }
        
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
        ]
    }
}
