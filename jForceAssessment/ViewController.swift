//
//  ViewController.swift
//  jForceAssessment
//
// 
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var Usernametxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LogInBTN(_ sender: UIButton) {
        let adminUsername = "Admin"
        let adminPassword = "123"
        
        guard let enteredUsername = Usernametxt.text, !enteredUsername.isEmpty else {
            openAlert(message: "Please enter Username!")
            return
        }
        
        guard let enteredPassword = passwordtxt.text, !enteredPassword.isEmpty else {
            openAlert(message: "Please enter Password!")
            return
        }
        
        if enteredUsername == adminUsername && enteredPassword == adminPassword {
            let vc = storyboard?.instantiateViewController(identifier: "AdminVC") as! AdminVC
            self.navigationController?.pushViewController(vc, animated: true)
            Usernametxt.text = ""
            passwordtxt.text = ""
        } else {
            if checkCredentials(username: enteredUsername, password: enteredPassword) {
                let vc = storyboard?.instantiateViewController(identifier: "UserVC") as! UserVC
                self.navigationController?.pushViewController(vc, animated: true)
                Usernametxt.text = ""
                passwordtxt.text = ""
            } else {
                openAlert(message: "Invalid Username or Password!")
            }
        }
    }
    
    @IBAction func RegisterBtnTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "Registercontroller") as! Registercontroller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkCredentials(username: String, password: String) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            if users.count > 0 {
                return true
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
        
        return false
    }
}

extension ViewController {
    func openAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
}
