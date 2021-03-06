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

public var myNewURLPath = ""
public var numberFormatter = NSNumberFormatter()



// can I use the icons neville wanted..legally?

class detail_controller: UIViewController {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var disciplineLabel: UILabel!
    
    
    @IBOutlet var adressView: UITextView!
    @IBOutlet var phoneView: UITextView!
    @IBOutlet var websiteView: UITextView!
    
    @IBOutlet var mapIcon: UIImageView!
    @IBOutlet var phoneIcon: UIImageView!
    @IBOutlet var safariIcon: UIImageView!
    
    @IBOutlet var detailMap: MKMapView!
    
     var geocoder = CLGeocoder()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if myNewURLPath != ""{
        getMusuemDetails()
        
        }
        
    }
    
    
    
    
    
    
    
    func getMusuemDetails(){
        
    let url = NSURL(string: myNewURLPath)
        if let musuemData=NSData(contentsOfURL:url!){
            if let musuemInfo: AnyObject! = NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(0), error: nil){
                if let json = musuemInfo as? Array<NSDictionary> {
                    if json.count >= 1{
                        
                        
                        let myEntry : AnyObject! = json[0]
                        let myLoc : AnyObject! = myEntry["location"]
                        
                        
                        let newLat  = numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue
                        let newLng = numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue
                        
                        
                        
                        
                        if let name:String = myEntry["commonname"] as? String {
                            nameLabel.text = name
                        }
                        
                        
                        
                        
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
                        
                        
                        
                        
                        if var phone:String = myEntry["phone"] as? String {
                            
                            phone.insert("-", atIndex: phone.endIndex.predecessor().predecessor().predecessor().predecessor())
                            phone.insert("-", atIndex: phone.startIndex.successor().successor().successor())
                            phoneView.text = phone
                            
                        }else{
                            phoneView.hidden = true
                            phoneIcon.hidden = true
                        }
                        
                        
                        
                        
                        
                        
                        if let website:String = myEntry["weburl"] as? String{
                            websiteView.text = website
                        }else{
                            websiteView.hidden = true
                            safariIcon.hidden = true
                        }
                        
                        
                        
                        
                        
                        
                        if let human_address : AnyObject! = myLoc["human_address"]
                        {
                            self.adressView.text = "Loading..."
                            
                            var loc = CLLocation(latitude: newLat, longitude: newLng)
                            
                            geocoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                                
                                
                                if(error != nil)
                                {
                                    println("Error Geocoding String ")
                                    
                                    let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
                                    
                                    self.adressView.text = partialAddress
                                    
                                    
                                    
                                    
                                }else if let placemark = placemarks[0] as? CLPlacemark{
                                    
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
                        
                        
                        
                        
                        
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
                            ,span: MKCoordinateSpanMake(0.008, 0.008))
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(newLat, newLng)
                        
                        
                        
                        detailMap.setRegion(region, animated: true)
                        self.detailMap.addAnnotation(annotation)
                       
                    }else{
                        
            println("No data recieved")
        
                    }
                }
            }
        }
    }
}
