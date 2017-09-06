//
//  ServiceHandler.swift
//  MyPlace
//
//  Created by Jaydeep Patoliya on 06/09/17.
//  Copyright © 2017 Jaydeep Patoliya. All rights reserved.
//


import CoreLocation
import GoogleMaps

class ServiceHandler : NSObject {
    //Write code for API
    static func callReverceGeocodeService (coordinate: CLLocationCoordinate2D){
        
    }
    
    static func getAddress(coordinate: CLLocationCoordinate2D, currentAdd : @escaping ( _ returnAddress :String)->Void){
        
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(coordinate.latitude),Double(coordinate.longitude))
        
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: "\n")
                
                currentAdd(currentAddress)
            }
        }     
    }
    
    
    static func getAddressFromLatLong(coordinate: CLLocationCoordinate2D, callback:@escaping (_ returnAddress: String)->Void){
        
 
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(coordinate.latitude),Double(coordinate.longitude))
        
        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: "\n")
                
                callback(currentAddress)
            }
        }     
    }
}
