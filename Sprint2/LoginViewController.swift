//
//  ViewController.swift
//  Sprint2
//
//  Created by Capgemini-DA230 on 9/22/22.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import LocalAuthentication

class LoginViewController: UIViewController {
    // MARK: @IBOutlets connections from storyboard
   
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var loginImgView: UIImageView!
    // MARK: @IBOutlets end
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //code to give border to ImgView
        loginImgView.layer.borderWidth = 1
        loginImgView.layer.masksToBounds = true
        loginImgView.layer.borderColor = UIColor.orange.cgColor
        //loginImgView.layer.cornerRadius = loginImgView.frame.height/2
        //loginImgView.layer.cornerRadius = loginImgView.frame.width/2
        //loginImgView.clipsToBounds = true
        UserAuthenticationByFaceID()
    }
    
    //Function returns vc which is used in Unit Testing
    static func getVc() -> LoginViewController {
        let stryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return vc
    }
    
    //Function to authenticate user by Face ID
    func UserAuthenticationByFaceID() {
        let context = LAContext()
        let mssgStr = "Identify Yourself Please"
        
        var err: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: mssgStr) {
                [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        self?.displayAlert(title: "Success: We Can Identify You!", msg: "Authentication is Successfull. You can now use the app.")
                    }
                    else {
                        
                    }
                }
                
            }
        }
        else {
            displayAlert(title: "Failed To Authenticate.", msg: "No Biometrics Available to test")
        }
    }
        
    // Function for email validation
    func emailValidation(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //Function after editing ends checks the email and gives alert if invalid
    @IBAction func userEmailTextFieldAction(_ sender: Any) {
        if !emailValidation(userEmailTextField.text!) {
            displayAlert(title: "Invalid Email Id", msg: "The Email Address must be alphanumeric.")
        }
    }
    
    //Function for Password Validation
    func pwdValidation(_ pwd: String) -> Bool {
        let pwdRegEx = "[A-Z0-9a-z._%+-@]{6,}"
        
        let pwdPred = NSPredicate(format:"SELF MATCHES %@", pwdRegEx)
        return pwdPred.evaluate(with: pwd)
    }
    
    //Function after editing ends checks the password and gives alert if invalid
    @IBAction func userPAsswordTextFieldAction(_ sender: Any) {
        if !pwdValidation(userPasswordTextField.text!) {
            displayAlert(title: "Invalid Password", msg: "Password should contain minimum 6 characters and should be alphanumeric.")
            
        }
    }
    
    //Function to match email and password from coredata
    func fetchUsers(_ emailMatch: String, _ passwordMatch: String) ->Bool {
        //creating a fetchRequest
        let managedObject = AppDelegate.sharedAppDelegateInstance().persistentContainer.viewContext
        let request: NSFetchRequest<Users> = Users.fetchRequest()
        request.returnsObjectsAsFaults = false
        let emailPred = NSPredicate(format: "userEmailId MATCHES %@", emailMatch)
        let pwdPred = NSPredicate(format: "password MATCHES %@", passwordMatch)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [emailPred,pwdPred])
        request.predicate = andPredicate
        
        do {
            let userdet = try managedObject.fetch(request)
            //print(userdet)
            if userdet.isEmpty {
                return true
            }else {
                return false
            }
            
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
        
    }
    
    //Function to delete all the users from Coredata
    /*func deleteUsers() {
        let managedObject = AppDelegate.sharedAppDelegateInstance().persistentContainer.viewContext
        let request: NSFetchRequest<Users> = Users.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let userdet = try managedObject.fetch(request)
            for e in userdet {
                managedObject.delete(e)
            }
            do {
                try managedObject.save()
            } catch(let error) {
                print(error.localizedDescription)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }*/
    
    //Function to display alert
    func displayAlert(title: String, msg: String) {
        let alertMessage = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertMessage, animated: true,completion: nil)
    }
    
    //Function to check users credentials from firebase storage/database.
    func loginUserWithFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            (result, error) -> Void in
            
            if let err = error {
                self.displayAlert(title: "Error", msg: "\(err.localizedDescription)")
                
            }
            else {
                print("User Logged in with Firebase.")
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                //print(self.navigationController?.viewControllers as Any)
                
                
                self.navigationController?.pushViewController(mainTabBarController, animated: true)
            }
        })
    }
    
    //oginButton Action for allowing users with right credentials to login
    @IBAction func loginAction(_ sender: Any) {
        if emailValidation(userEmailTextField.text!) && pwdValidation(userPasswordTextField.text!)  {
            saveCreds()
            loginUserWithFirebase(email: userEmailTextField.text!, password: userPasswordTextField.text!)
            
        }
    }
    
    //MARK: Enumertion
    //enum creted for error status
    enum KeychainError: Error  {
        case unknown(OSStatus)
    }
    
    
    //MARK: Function
    //func to save emailid and password in keychain
    func save(_ emailid: String, _ password: Data) throws {
       
        print("starting save...")
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: emailid as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("saved")
    }
    
    //func to call the keychain save func
    func saveCreds(){
        let savecreds = fetchUsers(userEmailTextField.text!, userPasswordTextField.text!)
        if !savecreds {
            do {
                try save(userEmailTextField.text!, Data(userPasswordTextField.text!.utf8))
            }catch (let error){
            print(error)
        }
        }
        
    }
    
    //signbuttonAction to take the user on SignUp Page
    @IBAction func signUpAction(_ sender: Any) {
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        //print(self.navigationController?.viewControllers as Any)
        self.navigationController?.pushViewController(signUpViewController, animated: true)
        
    }
    
}


