//
//  LoginViewController.swift
//  API
//
//  Created by 4lex@ndr0 on 10/03/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let defaults = UserDefaults.init(suiteName: "group.alexandro.cde")!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private func modalAlert(title: String = "Я сосал", msg: String = "Меня ебали") {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понял", style: .default) {_ in return })
        self.present(alert, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if loginField.text == "" || passwordField.text == "" {
            modalAlert(title: "Поля пусты", msg: "Введите логин/пароль")
            return
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
            defaults.set(loginField.text, forKey: "login")
            defaults.set(passwordField.text, forKey: "password")
            
            do {
                _ = try CDESession(login: loginField.text!, passwd: passwordField.text!)
            } catch {
                modalAlert(title: "Мне похуй", msg: "Но тут нужен обработчик")
                return
            }
            
            performSegue(withIdentifier: "FromLoginToMainSceneSegue", sender: nil) //Ok we dive to mainVC with guarantie that we hav session data
            activityIndicator.stopAnimating()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Do nothing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.loadView()
        
        // Do any additional setup after loading the view.
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
