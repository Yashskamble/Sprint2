//
//  SignUpViewController.swift
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


class SignUpViewController: UIViewController{
    //MARK: @IBOutlets connections through storyboard
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpImgView: UIImageView!
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Code to give border to Image
        signUpImgView.layer.borderWidth = 1
        signUpImgView.layer.masksToBounds = true
        signUpImgView.layer.borderColor = UIColor.orange.cgColor
        // Do any additional setup after loading the view.
        
    }
    
    //Function for username validation
    func userNameValidation(_ name: String) -> Bool {
        let userNameRegEx = "[a-zA-Z\\ a-zA-Z]{4,}"

        let userNamePred = NSPredicate(format:"SELF MATCHES %@", userNameRegEx)
        return userNamePred.evaluate(with: name)
    }
    
    //Function to check username after editing and if invalid pops an alert
    @IBAction func nameTextFieldAction(_ sender: Any) {
        if (!userNameValidation(nameTextField.text!)){
            displayAlert(title: "Invalid Name", msg: "Name should contain minimum 4 characters")
        }
        
    }
    
    
    //func for email validation
    func emailValidation(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //function to check emailid after editing and if invalid pops an alert also it checks and pops an alert if email id is already existing.
    @IBAction func emailTextFieldAction(_ sender: Any) {
        if (!emailValidation(emailTextField.text!)) {
            displayAlert(title: "Invalid Email Id", msg: "The Email Address must be alphanumeric and should contain atleast 2 charcters.")
            
        }
        else if !fetchUsers(emailTextField.text!) {
            displayAlert(title: "Cant Register", msg: "Email Already Exists!")
            
        }
    }

    //func for mobile no validation
    func mobileValidation(_ no: String) -> Bool {
        let mobileRegEx = "[0-9]{10,10}"
        
        let mobilePred = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return mobilePred.evaluate(with: no)
    }
    
    //Function to check mobile no after editing and if invalid pops an alert
    @IBAction func mobileTextFieldAction(_ sender: Any) {
        if (!mobileValidation(mobileTextField.text!)){
            displayAlert(title: "Invalid Mobile Number", msg: "Mobile Number should contain 10 digits.")
            
        }
    }
    
    
    //func for password validation
    func pwdValidation(_ pwd: String) -> Bool {
        let pwdRegEx = "[A-Z0-9a-z._%+-@]{6,}"
        
        let pwdPred = NSPredicate(format:"SELF MATCHES %@", pwdRegEx)
        return pwdPred.evaluate(with: pwd)
    }
    
    //Function to check password after editing and if invalid pops an alert
    @IBAction func passwordTextFieldAction(_ sender: Any) {
        if (!pwdValidation(passwordTextField.text!)) {
            displayAlert(title: "Invalid Password", msg: "Password should contain minimum 6 characters and should be alphanumeric.")
            
        }
    }
    
    //func to check the confirm password with password
    func confirmPwdValidation(_ pwd: String, _ cpwd: String) -> Bool {
        if cpwd == pwd {
            return true
        }
        else {
            return false
        }
            
    }
    
    //Function to check if both the passwords in the textfield matches.
    @IBAction func confirmPasswordTextFieldAction(_ sender: Any) {
        if (!confirmPwdValidation(passwordTextField.text!, confirmPasswordTextField.text!)) {
            displayAlert(title: "Registration Unsuccessful", msg: "Confirm Password doesn't match Password.")
            
        }
    }
    //Function to display alert
    func displayAlert(title: String, msg: String) {
        let alertMessage = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertMessage, animated: true,completion: nil)
    }
    
    
    //Function returns vc which is used in Unit Testing
    static func getVc() -> SignUpViewController {
        let stryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        return vc
    }
    
    //Function to insert user details in coredata
    func insertUserDetails(_ name: String, _ email: String, _ mobile: String, _ password: String) {
        let managedObject = AppDelegate.sharedAppDelegateInstance().persistentContainer.viewContext
        let user = Users(context: managedObject)
        user.username = name
        user.userEmailId = email
        user.mobile = mobile
        user.password = password
        
        do {
            try managedObject.save()
            print(user)
        } catch(let error){
            print(error)
        }
            
    }
    
    //Funtion to check if email already exists in coredata
    func fetchUsers(_ emailMatch: String) ->Bool {
        let managedObject = AppDelegate.sharedAppDelegateInstance().persistentContainer.viewContext
        let request: NSFetchRequest<Users> = Users.fetchRequest()
        request.returnsObjectsAsFaults = false
        let userPred = NSPredicate(format: "userEmailId MATCHES %@", emailMatch)
        request.predicate = userPred
        do {
            let userdet = try managedObject.fetch(request)
            print(userdet)
            if userdet.isEmpty {
                return true
            }else {
                return false
            }
            
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
        
    }
    
    //Function to store email id and password in firebase
    func registerUserInFirebase(email: String, password: String) {
        Auth.auth().createUser(withEmail: email ,password: password, completion: {
            (result, error) -> Void in
            if let _error = error {
                print(_error.localizedDescription)
            }
            else {
                print("User registered succussfully in Firebase.")
            }
        })
    }
    
    //Function signupButtonAction which will take user to categories list if all fields are field correctly, if not Then will show an alert
    @IBAction func signUpAction(_ sender: Any) {
        //if all fields are valid, it will take you to MainTabBarController
        if userNameValidation(nameTextField.text!) && emailValidation(emailTextField.text!) && mobileValidation(mobileTextField.text!) && pwdValidation(passwordTextField.text!) && confirmPwdValidation(passwordTextField.text!, confirmPasswordTextField.text!) {
            
            insertUserDetails(nameTextField.text!, emailTextField.text!, mobileTextField.text!, passwordTextField.text!)
            registerUserInFirebase(email: emailTextField.text!, password: passwordTextField.text!)
            let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            //print(self.navigationController?.viewControllers as Any)
            
            
            self.navigationController?.pushViewController(mainTabBarController, animated: true)
            
        }
            
        //will show alert message
        else if !userNameValidation(nameTextField.text!) && !emailValidation(emailTextField.text!) && !mobileValidation(mobileTextField.text!) && !pwdValidation(passwordTextField.text!) {
            displayAlert(title: "Can't Register", msg: "Please Enter the Details in the fields below.")
        }
        
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
