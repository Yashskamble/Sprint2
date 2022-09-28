//
//  CartPageViewController.swift
//  Sprint2
//
//  Created by Capgemini-DA230 on 9/26/22.
//

import UIKit
import CoreData
import Firebase
class CartTableViewCell: UITableViewCell {
    
    //MARK: @IBOutlets
    @IBOutlet weak var cartDescriptionLabel: UILabel!
    @IBOutlet weak var cartTitleLabel: UILabel!
    
}

class CartPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // MARK: Variables
    //variable created to be able to use and fetch coredata attributes
    var user: [CartData]!
    //MARK: @IBOutlets
    @IBOutlet weak var CartPageTableView: UITableView!
    
    //MARK: Functions
    //Function cartButton: When clicked, will take user to the MapViewController to see there location and to order the product.
    @IBAction func cartButtonAction(_ sender: Any) {
        let locationPage = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        print(self.navigationController?.viewControllers as Any)
        
        
        self.navigationController?.pushViewController(locationPage, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        fetchUsers()
        
    }
    
    //Function FetchUsers that will check whether the firebase email matches the attribute email of CartData entity and will let and help to fetch attributes title and descroiption of CartData entity and display it .
    func fetchUsers() {
        let managedObject = AppDelegate.sharedAppDelegateInstance().persistentContainer.viewContext
        let request: NSFetchRequest<CartData> = CartData.fetchRequest()
        request.returnsObjectsAsFaults = false
        let empPred = NSPredicate(format: "userEmailId MATCHES %@", (Auth.auth().currentUser?.email)! as String)
        request.predicate = empPred
        do {
            let emp = try managedObject.fetch(request)
            user  = emp
            
            DispatchQueue.main.async {
            self.CartPageTableView.delegate = self
            self.CartPageTableView.dataSource = self
            self.CartPageTableView.reloadData()
            }
    
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
        
      
           
        
    }
    
    //MARK: - TablView Source Data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CartPageTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.cartDescriptionLabel.text = (user[indexPath.row] as AnyObject).value(forKey: "descriptionProduct") as? String
        cell.cartTitleLabel.text = (user[indexPath.row] as AnyObject).value(forKey: "title") as? String
        return cell
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
