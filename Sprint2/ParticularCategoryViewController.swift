//
//  ParticularCategoryViewController.swift
//  Sprint2
//
//  Created by Capgemini-DA230 on 9/24/22.
//

import UIKit
import SwiftyJSON
import Alamofire
import Firebase
import CoreData

class CategoryNameTableViewCell: UITableViewCell{
    
    //MARK: IBOutlets  connections
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cartImageButton: UIButton!
    
    //MARK: Functions
    // Function cartImageAction: when user will click on the image, it will add the product in the cart page and will display it there.
    @IBAction func cartImageButtonAction(_ sender: Any) {
       
        let managedObject = AppDelegate.sharedAppDelegateInstance().persistentContainer.viewContext
        let request: NSFetchRequest<CartData> = CartData.fetchRequest()
        request.returnsObjectsAsFaults = false
        //let empPred = NSPredicate(format: "userEmailId MATCHES %@", (Auth.auth().currentUser?.email)! as String)
        //request.predicate = empPred
        do {
            //var emp = try managedObject.fetch(request)
            let user  = CartData(context: managedObject)
            //print(emp
            //Storing the datain core data
            user.title = titleLabel.text
            user.descriptionProduct = descriptionLabel.text
            user.userEmailId = (Auth.auth().currentUser?.email)
            do {
                try managedObject.save()
            } catch(let error){
                print(error)
            }
            
        }catch (let error) {
            fatalError(error.localizedDescription)
        }
        
       
        
    }
   
    
    
}


class ParticularCategoryViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    //creating a string to concatenate to url of the selected row
    //MARK: Variables
    var categoryName: String = ""
    // creating arrays of string to store title and description of json data
    var categoryTitleArr = [String]()
    var categoryDescArr = [String]()
    
    //MARK: IBOutlet of UITableView
    @IBOutlet weak var ParticularCategoryTableView: UITableView!
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteCartData()
        //self.tabBarController?.tabBar.isHidden = true
        self.title = "Add to Cart"
        //self.navigationController?.navigationBar.topItem?.title = "jjhjk"
        // Do any additional setup after loading the view.
        print(categoryName)
        callApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
   //Functton to delete data from coredata entity cartdata.
    func deleteCartData() {
        let managedObject = AppDelegate.sharedAppDelegateInstance().persistentContainer.viewContext
        let request: NSFetchRequest<CartData> = CartData.fetchRequest()
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
    }
    
    // Function to call API
    func callApi() {
        let api = "https://dummyjson.com/products/category/"
        
        //concatenating the API
        let myapi = api + categoryName
        
        // initialising arrays to no elements so that it won't repeat the list items when called again
        categoryDescArr = []
        categoryTitleArr = []
        
        //Using Alamofire to call API
        Alamofire.request(myapi, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response.result)
                
                //Using SwiftyJSON to convert data into readable format
                let result = try? JSON(data: response.data!)
                let resultArr = result!["products"]
                for i in resultArr.arrayValue {
                    
                    // Fetching and appending the data into arrays
                    
                    let category_title = i["title"].stringValue
                    self.categoryTitleArr.append(category_title)
                    
                    let category_desc  = i["description"].stringValue
                    self.categoryDescArr.append(category_desc)
                }
                
                //reloading data and UI changes are made in main queue.
                DispatchQueue.main.async {
                    self.ParticularCategoryTableView.delegate = self
                    self.ParticularCategoryTableView.dataSource = self
                    self.ParticularCategoryTableView.reloadData()
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
                
            }
        }
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ParticularCategoryTableView.dequeueReusableCell(withIdentifier: "CategoryNameTableViewCell", for: indexPath) as! CategoryNameTableViewCell
        cell.titleLabel.text = (categoryTitleArr[indexPath.row] as AnyObject) as? String
        cell.descriptionLabel.text = (categoryDescArr[indexPath.row] as AnyObject) as? String
       

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
