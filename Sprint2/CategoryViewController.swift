//
//  CategoryViewController.swift
//  Sprint2
//
//  Created by Capgemini-DA230 on 9/23/22.
//

import UIKit
import Alamofire
class CategoryTableViewCell: UITableViewCell{
    //MARK: IBOutlet for categoryLabel in CategoryTableViewCell
    @IBOutlet weak var categoryLabel: UILabel!
}

class CategoryViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    //MARK: IBOutlet for UITableView
    @IBOutlet weak var CategoryTableView: UITableView!
    
    // creating a mutable array to store json data
    var categoryArr = NSMutableArray()
    //MARK: Functions
    // Function viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callApi()
        // Do any additional setup after loading the view.
    }
    
    //function viewDidAppear to make visible the tabBar
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    
    
    
   //function to call the api
    func callApi() {
        // initialising array to no elements so that it won't repeat the list items when called again
        categoryArr = []
        
        let api = "https://dummyjson.com/products/categories"
        
        
        //Using Alamofire to call the API
        Alamofire.request(api, method : .get, encoding : URLEncoding.default, headers : nil).responseJSON { response in
            switch response.result{
            case .success:
                print(response.result)
                if let dict: NSArray = response.value as! NSArray? {
                    //print(dict)
                    for i in dict {
                        //adding each item of the list to the array
                        self.categoryArr.add(i)
                        
                    }
                    //print(self.categoryArr)
                    
                    //reloading data and UI changes are made in main queue.
                    DispatchQueue.main.async {
                        self.CategoryTableView.delegate = self
                        self.CategoryTableView.dataSource = self
                        self.CategoryTableView.reloadData()
                    }
                    
                }
                break
            case .failure(let err):
                print(err.localizedDescription)
            }
            
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.text = (categoryArr[indexPath.row] as AnyObject) as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let particularcategoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "ParticularCategoryViewController") as! ParticularCategoryViewController
        self.navigationController?.pushViewController(particularcategoryViewController, animated: true)
        //getting the value of the row selected.
        let rowSelected = categoryArr[indexPath.row]
        //setting the row selected value to the variable in ParticularCategoryViewController
        particularcategoryViewController.categoryName = rowSelected as! String
        
        
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
