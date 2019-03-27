//All i need to do is cache eregister in CoreData DB to provide previous data when new loads.
// Misha creditionals (login: "242458", passwd: "WAK9Pqea")
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellReuseIdentifier = "cell"
    var defaults: UserDefaults = UserDefaults.init(suiteName: "com.alexandro.cde")!
    
    var session: CDESession!, reg: Eregister? = nil
    var activeStudyYear: String? = nil, sem: Int = 1, selectedSubject: String? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var SemSelectSegmentedControl: UISegmentedControl!
    @IBAction func SemChanges(_ sender: UISegmentedControl) {
        self.sem = self.SemSelectSegmentedControl.selectedSegmentIndex + reg!.getFirstSemesterByStudyYear(styear: reg!.getStudyears().last!)
        self.defaults.set(sem, forKey: "sem")
        self.defaults.synchronize()
        
        self.tableView.reloadData()
    }
    
    func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    func ModalAlert(title: String = "ЪЕЪ", msg: String = "Sample Text") {
        let alert: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in print("Foo")}))
        self.present(alert, animated: true, completion: {})
    }
    
    func loadData() {
        let semaphore = DispatchSemaphore.init(value: 0)
        URLSession.shared.dataTask(with: URL(string: "https://de.ifmo.ru/api/private/eregister")!) { (data, response, error) in
            guard error == nil else { return }
            do {
                let eregister = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: [Any]]
                self.reg = Eregister(rawJsonData: eregister)
            } catch {
                print(error)
                return
            }
            semaphore.signal()
            }.resume() // Get eregister
        semaphore.wait() //Pray that this code works
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
        let queue = DispatchQueue.init(label: "data_loading")
    
        queue.async {
            self.loadData()
            if self.reg != nil {
                if self.defaults.object(forKey: "studyYear") == nil {
                    self.activeStudyYear = self.reg!.getStudyears().last
                    self.defaults.set(self.activeStudyYear, forKey: "studyYear")
                } else { self.activeStudyYear = self.defaults.string(forKey: "studyYear") }
                
                if self.defaults.object(forKey: "sem") == nil {
                    self.sem = self.reg!.getFirstSemesterByStudyYear(styear: self.activeStudyYear!)
                    self.defaults.set(self.sem, forKey: "sem")
                } else { self.sem = self.defaults.integer(forKey: "sem") }
                self.SemSelectSegmentedControl.selectedSegmentIndex = self.sem - self.reg!.getFirstSemesterByStudyYear(styear: self.activeStudyYear!)
                
                self.SemSelectSegmentedControl.setTitle(String(self.reg!.getFirstSemesterByStudyYear(styear: self.activeStudyYear!)) + " семестр", forSegmentAt: 0)
                self.SemSelectSegmentedControl.setTitle(String(self.reg!.getFirstSemesterByStudyYear(styear: self.activeStudyYear!) + 1) + " семестр", forSegmentAt: 1)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination_controller: SubjectViewController = segue.destination as? SubjectViewController else { return }
        destination_controller.reg = self.reg
        destination_controller.semester = self.sem
        destination_controller.studyYear = self.activeStudyYear
        destination_controller.subject = self.selectedSubject
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(sem)
        if reg != nil {
            return reg!.getSubjects(styear: activeStudyYear!, semester: sem).count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubjectCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! SubjectCell
        if reg != nil {
            let subject = reg!.getSubjects(styear: activeStudyYear!, semester: sem)[indexPath.row]
        
            cell.name.text = subject["name"]
            cell.worktype.text = subject["worktype"]! + " (" + subject["mark"]! + ")"
            cell.amount.text = subject["amount"]
        
            let amount = (subject["amount"]! as NSString).floatValue
            if Int(amount) >= 60 {
                cell.name.textColor = UIColor.init(red: 0.0, green: 0.7, blue: 0.05, alpha: 1.0)
                cell.amount.textColor = UIColor.init(red: 0.0, green: 0.7, blue: 0.05, alpha: 1.0)
            } else {
                cell.name.textColor = UIColor.black
                cell.amount.textColor = UIColor.black
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reg != nil {
            self.selectedSubject = reg!.getSubjects(styear: activeStudyYear!, semester: sem)[indexPath.row]["name"]!
            performSegue(withIdentifier: "gotopoints_segue", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
