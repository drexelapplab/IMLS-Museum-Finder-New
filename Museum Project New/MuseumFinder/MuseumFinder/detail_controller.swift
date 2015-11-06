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
    
    // MARK: Functions
    
    // sends the query and gets the museum details
    // also parse the given information
    func getMusuemDetails(){
        
        let url = NSURL(string: newUrlPath)
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
                        
                        //gets the name and sets it to the name label
                        if let name:String = myEntry["commonname"] as? String {
                            nameLabel.text = name
                        }
                        

                        //sets the disipline label as well
                        
                        if let discipl:String = myEntry["discipl"] as? String {
                            
                            if discipl == "ART" {
                                disciplineLabel.text = "Art Museum"
                            }
                                
                            else if discipl == "BOT"{
                                disciplineLabel.text  = "Botanical Garden"
                            }
                                
                            else if discipl == "CMU"{
                                disciplineLabel.text  = "Children's Museum"
                            }
                                
                            else if discipl == "GMU"{
                                disciplineLabel.text  = "General Museum"
                            }
                                
                            else if discipl == "HSC"{
                                disciplineLabel.text = "Historical Society and Preservation"
                            }
                                
                            else if discipl == "HST"{
                                disciplineLabel.text = "History Museum"
                            }
                                
                            else if discipl == "NAT"{
                                disciplineLabel.text  = "Natural History and Science Museum"
                            }
                                
                            else if discipl == "SCI"{
                                disciplineLabel.text  = "Science Museum"
                            }
                                
                            else if discipl == "ZAW"{
                                disciplineLabel.text  = "Zoos,Aquariums and WildLife"
                            }
                        }
                        
                        
                        
                        
                        
                        
                        // gets the phone string and adds two "-" before adding it to the label
                        if var phone:String = myEntry["phone"] as? String {
                            
                            phone.insert("-", atIndex: phone.endIndex.predecessor().predecessor().predecessor().predecessor())
                            phone.insert("-", atIndex: phone.startIndex.successor().successor().successor())
                            phoneView.text = phone
                            
                        }else{
                            phoneView.hidden = true
                            phoneIcon.hidden = true
                        }
                        
                        
                        
                        
                        //sets the url label
                        if let website:String = myEntry["weburl"] as? String{
                            websiteView.text = website
                        }else{
                            websiteView.hidden = true
                            safariIcon.hidden = true
                        }
                        
                        
                        
                        
                        
                        // gets the human address infor from the museum details
                        if let human_address : AnyObject! = myLoc["human_address"]
                        {
                            //sets the view until it parses the information
                            self.adressView.text = "Loading..."
                            
                            //converst the coordinates to one location
                            let loc = CLLocation(latitude: newLat, longitude: newLng)
                            
                            
                            
                            //finds the information about a certain location from the location
                            geocoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks:[CLPlacemark]?, error) -> Void in
                                
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
                            adressView.hidden = true
                            mapIcon.hidden = true
                        }
                        
                        // sets the detail mapview to the coordinate of the museum whose data we have recieved
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
                            ,span: MKCoordinateSpanMake(0.008, 0.008))
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(newLat, newLng)
                        
                        //sets the region and adds the annotation
                        detailMap.setRegion(region, animated: true)
                        self.detailMap.addAnnotation(annotation)
                        
                    }else{
                        
                        print("No data recieved")
                        
                    }
                }
            }catch{error}
            
        }
    }
    
    // MARK: IBActions
    
    // MARK: - Protocols
}
