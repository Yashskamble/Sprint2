//
//  MapViewController.swift
//  Sprint2
//
//  Created by Capgemini-DA230 on 9/26/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: Variables
    var manageLocation: CLLocationManager!
    var myLocationStr: String = ""
    
    //MARK: @IBOutlet
    @IBOutlet weak var myMap: MKMapView!
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = "Map"        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLocation()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //Function returns vc which is used in Unit Testing
    static func getVc() -> MapViewController {
        let stryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        return vc
    }

    //Function orderButtonAction that will take you to LocalNotification Page.
    @IBAction func orderAction(_ sender: Any) {
        let notificationPage = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        //print(self.navigationController?.viewControllers as Any)
        
        self.navigationController?.pushViewController(notificationPage, animated: true)
    }
    func getLocation() {
        //creating instance of class that provides functionss
        manageLocation = CLLocationManager()
        manageLocation.delegate = self
        // for best accuracy
        manageLocation.desiredAccuracy = kCLLocationAccuracyBest
        //request access to accurate location
        manageLocation.requestAlwaysAuthorization()
        
        
        //if location is granted it will start updating location.
        if CLLocationManager.locationServicesEnabled() {
            manageLocation.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation: CLLocation = locations[0] as CLLocation
        let centerposition = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
        
        let nearRegion = MKCoordinateRegion(center: centerposition, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let annotation : MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude)
        
        getAddress { (address) in
            annotation.title = address
        }
        
        myMap.setRegion(nearRegion, animated: true)
        myMap.addAnnotation(annotation)
        
        func getAddress(handler: @escaping (String) -> Void) {
            let geocoder = CLGeocoder()
            let locations = CLLocation(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            geocoder.reverseGeocodeLocation(locations, completionHandler: { (placemarks, error ) -> Void in
                var place : CLPlacemark?
                place = placemarks?[0]
                
                let address = "\(place?.subThoroughfare ?? ""), \(place?.thoroughfare ?? ""), \(place?.locality ?? ""),\(place?.subLocality ?? ""),\(place?.administrativeArea ?? ""), \(place?.postalCode ?? ""),\(place?.country ?? "")"
                print(address)
                handler(address)
            })
           
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
