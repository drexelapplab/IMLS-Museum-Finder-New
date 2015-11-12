//
//  detail_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/13/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

// MARK: Globals
// FIXME: remove both globals from global scope?
public var newUrlPath = ""
public var numberFormatter = NSNumberFormatter()


class detail_controller: UIViewController {

    // MARK: Properties
    
    var geocoder = CLGeocoder()
    
    // MARK: IBOutlets
    
    ///
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var disciplineLabel: UILabel!
    @IBOutlet var adressView: UITextView!
    @IBOutlet var phoneView: UITextView!
    @IBOutlet var websiteView: UITextView!
    @IBOutlet var mapIcon: UIImageView!
    @IBOutlet var phoneIcon: UIImageView!
    @IBOutlet var safariIcon: UIImageView!
    @IBOutlet var detailMap: MKMapView!
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if there is a url path set for the query
        if newUrlPath != ""{
            getMusuemDetails()
            
        }
        
    }
    
    /// Method overrided to tell Navigation controller which orientation to use for this viewController
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    // MARK: Functions
    
    // sends the query and gets the museum details
    // also parse the given information
    func getMusuemDetails(){
        
        let url = NSURL(string: newUrlPath)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
        if let musuemData=NSData(contentsOfURL:url!){
            do{
                let musuemInfo: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                
                
                if let json = musuemInfo as? Array<NSDictionary> {
                    if json.count >= 1 {
                        
                        
                        // gets the museum aand its informations
                        let myEntry : AnyObject! = json[0]
                        
                        //gets the location from the museum info
                        let myLoc : AnyObject! = myEntry["location_1"]
                        
                        //converts the lat and long from strings
                        let newLat  = numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue
                        let newLng = numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue
                        
                        dispatch_async(dispatch_get_main_queue()) {
                        //gets the name and sets it to the name label
                        if let name:String = myEntry["commonname"] as? String {
                            self.nameLabel.text = name
                        }
                        }

                        //sets the disipline label as well
                        dispatch_async(dispatch_get_main_queue()) {
                        if let discipl:String = myEntry["discipl"] as? String {
                            
                            if discipl == "ART" {
                                self.disciplineLabel.text = "Art Museum"
                            }
                                
                            else if discipl == "BOT"{
                                self.disciplineLabel.text  = "Botanical Garden"
                            }
                                
                            else if discipl == "CMU"{
                                self.disciplineLabel.text  = "Children's Museum"
                            }
                                
                            else if discipl == "GMU"{
                                self.disciplineLabel.text  = "General Museum"
                            }
                                
                            else if discipl == "HSC"{
                                self.disciplineLabel.text = "Historical Society and Preservation"
                            }
                                
                            else if discipl == "HST"{
                                self.disciplineLabel.text = "History Museum"
                            }
                                
                            else if discipl == "NAT"{
                                self.disciplineLabel.text  = "Natural History and Science Museum"
                            }
                                
                            else if discipl == "SCI"{
                                self.disciplineLabel.text  = "Science Museum"
                            }
                                
                            else if discipl == "ZAW"{
                                self.disciplineLabel.text  = "Zoos,Aquariums and WildLife"
                            }
                        }
                        }
                        
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                        // gets the phone string and adds two "-" before adding it to the label
                        if var phone:String = myEntry["phone"] as? String {
                            
                            phone.insert("-", atIndex: phone.endIndex.predecessor().predecessor().predecessor().predecessor())
                            phone.insert("-", atIndex: phone.startIndex.successor().successor().successor())
                            self.phoneView.text = phone
                            
                        }else{
                            self.phoneView.hidden = true
                            self.phoneIcon.hidden = true
                        }
                        }
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                        //sets the url label
                        if let website:String = myEntry["weburl"] as? String{
                            self.websiteView.text = website
                        }else{
                            self.websiteView.hidden = true
                            self.safariIcon.hidden = true
                        }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                        // gets the human address infor from the museum details
                        if let human_address : AnyObject! = myLoc["human_address"]{
                            //sets the view until it parses the information
                            self.adressView.text = "Loading..."
                            
                            //converst the coordinates to one location
                            let loc = CLLocation(latitude: newLat, longitude: newLng)
                            
                            
                            
                            //finds the information about a certain location from the location
                            self.geocoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks:[CLPlacemark]?, error) -> Void in
                                
                                if(error != nil)
                                {
                                    // if there is an issue set the label to the address from the API
                                    print("Error Geocoding String ")
                                    
                                    let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
                                    
                                    self.adressView.text = partialAddress
                                    
                                }else{
                                    
                                    //if there is no error then set the placemark name to the address
                                    let placemark = placemarks![0]
                                    
                                    if let name = placemark.name
                                    {
                                        self.adressView.text = name
                                        
                                        if let locality = placemark.locality
                                        {
                                            self.adressView.text = self.adressView.text! + "," + locality
                                            
                                            if let aArea = placemark.administrativeArea
                                            {
                                                self.adressView.text = self.adressView.text! + "," + aArea
                                                
                                                if let pCode = placemark.postalCode
                                                {
                                                    self.adressView.text = self.adressView.text! + "-" + pCode
                                                }
                                            }
                                        }
                                    }
                                }
                            })
                            
                            
                        }else{
                            self.adressView.hidden = true
                            self.mapIcon.hidden = true
                        }
                        }
                        
                        // sets the detail mapview to the coordinate of the museum whose data we have recieved
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
                            ,span: MKCoordinateSpanMake(0.008, 0.008))
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(newLat, newLng)
                        
                        //sets the region and adds the annotation
                        dispatch_async(dispatch_get_main_queue()) {
                            self.detailMap.setRegion(region, animated: true)
                            self.detailMap.addAnnotation(annotation)
                        }
                        
                    }else{
                        
                        print("No data recieved")
                        
                    }
                }
            }catch{error}
            
        }
        }
        
        
    }
    
    // MARK: IBActions
    
    // MARK: - Protocols
}
