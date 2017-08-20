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

class MainViewController: UIViewController, UISearchDisplayDelegate, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchControllerDelegate, UISearchBarDelegate{
    
    //LocationManager
    
    // Menu Button
 
    
    
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
        mapView.mapType = .normal
        mapView.isMyLocationEnabled = true
        mapView.delegate = self;
        self.view = mapView
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
        searchController?.searchBar.sizeToFit()
        searchController?.delegate = self
        searchController?.searchBar.delegate = self
        
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
        
//        let btnMapType = UIButton(frame: CGRect(x: self.view.frame.size.width-64, y: 70, width: 36, height: 36))
//        btnMapType.backgroundColor = UIColor.gray
//        btnMapType.contentHorizontalAlignment = .right
//        btnMapType.addTarget(self, action: #selector(changeMapType), for: .touchUpInside)
//        self.view.addSubview(btnMapType)
//        
//        
        
        // Menu Button
 
        let menuButtonsMapType = LGPlusButtonsView(numberOfButtons: 4, firstButtonIsPlusButton: true, showAfterInit: true, actionHandler: { (menuButtonsMapType, title, description, index) in
        print("Location")
            if(index == 1){
                self.mapView.mapType = .normal
            }else if(index == 2)
            {
                self.mapView.mapType = .terrain
            }else{
                self.mapView.mapType = .hybrid
            }
        })
            
        //menuButtonsMapType?.observedScrollView = self.mapView;
        menuButtonsMapType?.coverColor = UIColor(white: 1.0, alpha: 0.7)
        menuButtonsMapType?.position = .topRight
        
        menuButtonsMapType?.plusButtonAnimationType = .none
        menuButtonsMapType?.setButtonsTitles(["", "", "", ""], for: .normal)
        
        menuButtonsMapType?.setDescriptionsTexts(["", "Normal", "Terrain", "Hybrid"])
        
        menuButtonsMapType?.setButtonsImages([UIImage(named: "Camera")!, UIImage(named: "Camera")!, UIImage(named: "Picture")!, UIImage(named: "Message")!], for: .normal, for: .all)
        
        
        
        menuButtonsMapType?.setButtonsAdjustsImageWhenHighlighted(false)
        
        
        menuButtonsMapType?.setButtonsBackgroundColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0), for: .normal)
        menuButtonsMapType?.setButtonsBackgroundColor(UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0), for: .highlighted)
        menuButtonsMapType?.setButtonsBackgroundColor(UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0), for: [.highlighted, .selected])
        menuButtonsMapType?.setButtonsSize(CGSize(width: 38.0, height: 38.0), for: .all)
        menuButtonsMapType?.setButtonsLayerCornerRadius(38.0 / 2.0, for: .all)
        menuButtonsMapType?.setButtonsTitleFont(UIFont.boldSystemFont(ofSize: 24.0), for: .all)
        menuButtonsMapType?.setButtonsLayerShadowColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
        
        menuButtonsMapType?.setButtonsLayerShadowOpacity(0.5)
        menuButtonsMapType?.setButtonsLayerShadowRadius(3.0)
        menuButtonsMapType?.setButtonsLayerShadowOffset(CGSize(width: 0.0, height: 2.0))

        menuButtonsMapType?.setButtonAt(0, size: CGSize(width: 56.0, height: 56.0), for: (UI_USER_INTERFACE_IDIOM() == .phone ? .portrait : .all))
        menuButtonsMapType?.setButtonAt(0, layerCornerRadius: 56.0 / 2.0, for: (UI_USER_INTERFACE_IDIOM() == .phone ? .portrait : .all))
        
        menuButtonsMapType?.setButtonAt(0, titleFont: UIFont.systemFont(ofSize: 40.0), for: (UI_USER_INTERFACE_IDIOM() == .phone ? .portrait : .all))
        menuButtonsMapType?.setButtonAt(0, titleOffset: CGPoint(x: 0.0, y: -3.0), for: .all)
        menuButtonsMapType?.setButtonAt(1, backgroundColor: UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0), for: .normal)
        menuButtonsMapType?.setButtonAt(1, backgroundColor: UIColor(red: 1.0, green: 0.2, blue: 0.6, alpha: 1.0), for: .highlighted)
        menuButtonsMapType?.setButtonAt(2, backgroundColor: UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0), for: .normal)
        menuButtonsMapType?.setButtonAt(2, backgroundColor: UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0), for: .highlighted)
        menuButtonsMapType?.setButtonAt(3, backgroundColor: UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0), for: .normal)
        menuButtonsMapType?.setButtonAt(3, backgroundColor: UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0), for: .highlighted)
        menuButtonsMapType?.setDescriptionsBackgroundColor(UIColor.white)
        menuButtonsMapType?.setDescriptionsTextColor(UIColor.black)
        menuButtonsMapType?.setDescriptionsLayerShadowColor (UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))
        menuButtonsMapType?.setDescriptionsLayerShadowOpacity (0.25)
        menuButtonsMapType?.setDescriptionsLayerShadowRadius (1.0)
        menuButtonsMapType?.setDescriptionsLayerShadowOffset(CGSize(width: 0.0, height: 1.0))
        
        menuButtonsMapType?.setDescriptionsLayerCornerRadius(6.0, for: .all)
        menuButtonsMapType?.setDescriptionsContentEdgeInsets(UIEdgeInsetsMake(4.0, 8.0, 4.0, 8.0), for: .all)
        for i in 1...3 {
            menuButtonsMapType?.setButtonAt(UInt(i), offset: CGPoint(x: -6.0, y: 0.0), for: (UI_USER_INTERFACE_IDIOM() == .phone ? .portrait : .all))
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            menuButtonsMapType?.setButtonAt(0, titleOffset: CGPoint(x: 0.0, y: -2.0), for: .landscape)
            menuButtonsMapType?.setButtonAt(0, titleFont: UIFont.systemFont(ofSize: 32.0), for: .landscape
            )
        }
        navigationController?.view?.addSubview(menuButtonsMapType!)
        //self.view.addSubview(menuButtonsMapType!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func changeMapType(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.mapView.mapType = .normal
        }
        
        let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.mapView.mapType = .terrain
        }
        
        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.mapView.mapType = .hybrid
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(normalMapTypeAction)
        actionSheet.addAction(terrainMapTypeAction)
        actionSheet.addAction(hybridMapTypeAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: GOOGLE MAP Delegate
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
    
    @objc(mapView:didTapPOIWithPlaceID:name:location:) func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        searchController?.searchBar.text = name
        marker.title = "\(name)"
        marker.snippet = "\(placeID)"
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
        return true
    }
    
    
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
    
    // MARK:Location Manager Delegate stuff
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            cameraMoveToLocation(toLocation: coord, zoomPoint: 15)
            
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
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?, zoomPoint : Float) {
        if toLocation != nil {
            //mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
            
            let vancouver = CLLocationCoordinate2D(latitude:(toLocation?.latitude)!, longitude: (toLocation?.longitude)!)
            let vancouverCam = GMSCameraUpdate.setTarget(vancouver)
            mapView.animate(with: vancouverCam)
            
            mapView.animate(toZoom: zoomPoint)
            
        }
    }
    
    
    // MARK:UISearchDisplayController Delegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
        //searchController.searchBar.showsCancelButton = false
    }
    func didPresentSearchController(_ searchController: UISearchController) {
        print("didPresentSearchController")
        //searchController.searchBar.showsCancelButton = false
        
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        print("willDismissSearchController")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        print("didDismissSearchController")
    }
    
    // MARK: SearchBar Delegate
    
    var isSearchBarShouldBeginEditing = true
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mapView.clear()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchBarShouldBeginEditing = true
        if(searchText.characters.count == 0){
            mapView.clear()
            isSearchBarShouldBeginEditing = false
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if(isSearchBarShouldBeginEditing){
            return true
        }else{
            return false
        }
    }
    
  

    //Utils Functions
    func callLocationAlerview() {
        let alert = UIAlertController(title: "Turn On Location Service to Allow \"MyPLace\" to Determine Your Location", message: "We use your current location to provide more accurate information about your buddies.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction!) in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Go to Settings", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
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
        searchController?.searchBar.text = place.name
        // Do something with the selected place.
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = "\(place.name)"
        marker.snippet = "\(String(describing: place.formattedAddress))"
        marker.map = mapView
        var zoomPoint:Float!
        let typesArray = place.types as NSArray
        let locationObj = typesArray.firstObject as! String
        
        switch locationObj {
        case "restaurant":
            zoomPoint = 15
        case "country":
            zoomPoint = 4
        case "premise":
            zoomPoint = 19
        default:
            zoomPoint = 10
            
        }
        
        cameraMoveToLocation(toLocation: place.coordinate, zoomPoint: zoomPoint)

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

