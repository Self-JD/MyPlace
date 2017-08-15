//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Jaydeep Patoliya on 12/08/17.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MainViewController: UIViewController, UISearchDisplayDelegate, GMSMapViewDelegate, CLLocationManagerDelegate{
    
    //LocationManager

    
    //Google Place
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var searchBar: UISearchBar?
    
    //Global Object for MapView
    var mapView: GMSMapView!

   //Location Service
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    
    //Load Gogole Map
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.8683,
                                              longitude: 151.2086,
                                              zoom: 4)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true

        mapView.isMyLocationEnabled = true
        mapView.delegate = self;
        view = mapView
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerCellNib(DataTableViewCell.self)
    
        //Intialize Location Code
        
        initLocationManager()
        
        //PLace API for search place 
        searchBar?.frame = (CGRect(x: 0, y: 0, width: 250.0, height: 44.0))
    
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as? GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
       
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK Delegate MAP

    

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if(self.navigationController?.isNavigationBarHidden == false){
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = "\("Test Name")"
        marker.snippet = "\(String(describing: "Test Address"))"
        marker.map = mapView
    }
 
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let status = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined:
                 locationManager.requestAlwaysAuthorization()
            case .restricted, .denied:
                print("No access")
                
                callLocationAlerview()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationFixAchieved = false
                locationManager.stopUpdatingLocation()
                locationManager.startUpdatingLocation()
            }

//        let alertController = UIAlertController(title: "Destructive", message: "Simple alertView demo with Destructive and Ok.", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
//        let DestructiveAction = UIAlertAction(title: "Destructive", style: UIAlertActionStyle.destructive) {
//            (result : UIAlertAction) -> Void in
//            print("Destructive")
//        }
//        
//        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            (result : UIAlertAction) -> Void in
//            print("OK")
//        }
//        
//        alertController.addAction(DestructiveAction)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
        return true
    }
    
    
    
//MARK Location Delegate
    
    // Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    // Location Manager Delegate stuff
    // If failed

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            cameraMoveToLocation(toLocation: coord)
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
            break
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
            mapView.isMyLocationEnabled = false
            break
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
            manager.requestAlwaysAuthorization()
        default:
            locationStatus = "Allowed to location Access"
            mapView.isMyLocationEnabled = true
            shouldIAllow = true
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            print("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            //mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
            
            let vancouver = CLLocationCoordinate2D(latitude:(toLocation?.latitude)!, longitude: (toLocation?.longitude)!)
            let vancouverCam = GMSCameraUpdate.setTarget(vancouver)
            mapView.animate(with: vancouverCam)
            
            mapView.animate(toZoom: 15)
            
        }
    }
    
    //Utils Functions
    func callLocationAlerview() {
        let alert = UIAlertController(title: "Your title", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go to Settings now", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            print("GPS")
            UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}



extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}


// Handle the user's selection.
extension MainViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = "\(place.name)"
        marker.snippet = "\(String(describing: place.formattedAddress))"
        marker.map = mapView
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

