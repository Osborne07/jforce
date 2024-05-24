//
//  Registercontroller.swift
//  jForceAssessment
//
//  
//

import UIKit
import CoreData

class Registercontroller: UIViewController {
    
    @IBOutlet weak var userNametxt: UITextField!
    
    @IBOutlet weak var passwordtxt: UITextField!
    
    @IBOutlet weak var emailtxt: UITextField!
    
    @IBOutlet weak var phonetxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}

extension Registercontroller {
    
    @IBAction func RegisterBtnTapped(_ sender: Any) {
        guard let username = userNametxt.text, !username.isEmpty else {
            openAlert(message: "Please enter your Username!")
            return
        }
        guard let password = passwordtxt.text, !password.isEmpty else {
            openAlert(message: "Please enter your Password!")
            return
        }
        guard let email = emailtxt.text, !email.isEmpty else {
            openAlert(message: "Please enter your email!")
            return
        }
        guard let phone = phonetxt.text, !phone.isEmpty else {
            openAlert(message: "Please enter your phone number!")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let userEntity = UserEntity(context : context)
        userEntity.username = username
        userEntity.password = password
        userEntity.email = email
        userEntity.phone = phone
        
        do{
            try context.save()
        }catch{
            print("Error")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}



extension Registercontroller {
    func openAlert (message : String){
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
}
