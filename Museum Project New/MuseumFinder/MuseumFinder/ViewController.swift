//
//  ViewController.swift
//  MuseumFinder
//
//  Created by Dagmawi on 9/13/15.
//  Copyright © 2015 IMLS. All rights reserved.
//

import UIKit
import MapKit // Uses mapkit to show User Museums
import CoreLocation // Needs location to find local museums around user

// made a few public variable to pass information among controller classes, probably better to use prepforsegue method
public var myMusuemData :  Array<NSDictionary> = []
public var centerCoordinate = CLLocationCoordinate2D()
public var myerror = UIAlertView()

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    let userTrackingButton = MKUserTrackingBarButtonItem()
    var radius = 1263
    var annotationArray = [CustomPointAnnotation]()
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var mapShown = true
    var fromMyLoc = false
    var placemark:CLPlacemark? = nil
    
    // MARK: - IBOutlets
    
    @IBOutlet var bottomNavigation: UINavigationItem!
    @IBOutlet var myMapView: MKMapView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the find me button to the bottom right of my screen
        userTrackingButton.mapView = myMapView
        self.bottomNavigation.rightBarButtonItem = userTrackingButton
        userTrackingButton.target = self
        
        myMapView.showsPointsOfInterest = false
        
        if enteredLoc == "" {
            mapView(myMapView, didChangeUserTrackingMode: MKUserTrackingMode.Follow, animated: false)
        }
    }
    
    // this method sets up all the mapview in response to which view controller sent the request
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // if it is from the add screen and there is an entered location
        if enteredLoc != "" && fromAdd {
            // parse the given address and set the bool back to false
            findByAddress(enteredLoc)
            fromAdd = false
        }
        

        // if there is no entered location
        if enteredLoc == "" && fromCat{
            // resend the query with the new category information
            getMyLoc()
        
            fromCat = false
        }else if enteredLoc != "" && fromCat{
                
            // if there is an entered location then send a query at that location
            findByAddress(enteredLoc)
            fromCat = false
        }
    }
    
    //MARK: - Functions
    
    // starts updating the location
    func getMyLoc(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func findByAddress(enteredLoc : String){
        
        // this method parses the given string, finds the location and updates the mapview around that region
        geocoder.geocodeAddressString(enteredLoc) { (placemarks:[CLPlacemark]?, error) -> Void in
            
            // if there is an error,show and log it
            if(error != nil) {
                
                myerror.title = "Error"
                myerror.message = "Could not go to the location"
                myerror.addButtonWithTitle("OK")
                myerror.show()
                
                print("Error Geocoding String")
                
            }else{
                // get the geocoded placemark, find the location and setup the map at that location
                self.placemark = placemarks![0]
                if self.placemark != nil{
                    let location = self.placemark!.location!
                    
                    self.makeMap(location)
                    self.myMapView.addAnnotation(MKPlacemark(placemark: self.placemark!))
                
                    
                    // sets the center coordinate to the value of this location
                    centerCoordinate.latitude = location.coordinate.latitude
                    centerCoordinate.longitude = location.coordinate.longitude
                    
                
                    // sets the annotation's callout to the name of the placemark
                    let ann = MKPointAnnotation()
                    ann.coordinate = centerCoordinate
                    
                    if let name = self.placemark!.name
                    {
                        ann.title = name
                    
                        if let locality = self.placemark!.locality {
                            ann.title = ann.title! + ", " + locality
                        
                            if let aArea = self.placemark!.administrativeArea {
                                ann.title = ann.title! + ", " + aArea
                            
                                if let pCode = self.placemark!.postalCode {
                                    ann.title = ann.title! + "-" + pCode
                                }
                            }
                        }
                    }
                
                    self.myMapView.addAnnotation(ann)
                }
            }
        }
    }
    
    // method that makes the map around a certain location
    func makeMap(location : CLLocation){
        
        let region = MKCoordinateRegion(
            center:CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude),
            span: MKCoordinateSpanMake(0.015, 0.015))
        
        
        
        // only updates the mapview if its called from find me button or there is no entered location
        
        if fromMyLoc || enteredLoc != ""{
            myMapView.setRegion(region, animated: true)
            print("fromMyLoc = \(fromMyLoc)")
            fromMyLoc = false
        }
    }
    
    // method that gets called everytime you want to update the museums in the mapview
    func updateMusuems(loc: CLLocation){
        
        // removes all the old annotations
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        
        // sets a cap on the radius
        if radius > 20000{
            radius = 20000
        }
        
        // sets the query url up
        var urlPath = "https://data.imls.gov/resource/ku5e-zr2b.json?$select=location_1,commonname,phone,discipl,weburl&$where=within_circle(location_1,\(loc.coordinate.latitude),\(loc.coordinate.longitude),\(radius))"
        
        // if there is a certain category the user wants to look at then add that to the query path
        if musCatArray.count >= 1
        {
            urlPath = urlPath + catString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
        }
        
        
        print(urlPath)
        
        // convert to url and send the query
        let url = NSURL(string: urlPath)
        
        // if you can set the contens of the query to a variable
        if let musuemData=NSData(contentsOfURL:url!){
            
            do{
                // parse the data
                let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                
                // convert to array
                var json = positions as! Array<NSDictionary>
                if json.count >= 1 {
                    
                    // set to a public property to be suer by another controller
                    myMusuemData=json
                    
                    // add the annotation
                    self.makeAnnotations(json)
                    
                    // remove all th values from my array
                    json.removeAll(keepCapacity: false)
                    
                    if placemark != nil {
                        print("notnil")
                        self.myMapView.addAnnotation(MKPlacemark(placemark: self.placemark!))
                    }
                }else{
                    print("No points to plot/annotate")
                }
            }catch{error}
        }else{
            // if there is an error
            myerror.title = "Error"
            myerror.message = "Could not connect to server"
            myerror.addButtonWithTitle("OK")
            myerror.show()
        }
        
    }
    
    func makeAnnotations(json : Array<AnyObject>){
        
        
        // if ther is one or more values in the array
        if json.count >= 1 {
            
            // for every value, get the info(discipl,commonname,location_1...),parse them and add them to the annotation array
            for index in 0...json.count-1{
                
                let myEntry: AnyObject = json[index]
                let discipl:String = myEntry["discipl"] as! String
                let musName:String = myEntry["commonname"] as! String
                let myLoc : AnyObject! = myEntry["location_1"]
                
                //make a custom point annotation
                let annotation = CustomPointAnnotation()
                
                // sets the address to the subtitle
                if let human_address : AnyObject! = myLoc["human_address"]
                {
                    
                    let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
                    
                    annotation.subtitle = partialAddress
                    
                }
                
                // sets the name to the title
                annotation.title = musName
                
                // sets the coordinate to the mus's location_1
                annotation.coordinate = CLLocationCoordinate2DMake(
                    numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue,
                    numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
                
                // the names of the images must directly coorelate to the value for the discipl field from the API for this line to work
                annotation.imageName = discipl
                
                // add the annotation to an array
                annotationArray.append(annotation)
            }
            
            
            // remove the old annotations and add the new ones
            self.myMapView.removeAnnotations(self.myMapView.annotations)
            self.myMapView.addAnnotations(annotationArray)
            
            // remove all the annotation from the annotation array
            annotationArray.removeAll(keepCapacity: false)
            
        }else{
            // if there are no museums
            myerror.title = "Error"
            myerror.message = "No museums to show"
            myerror.addButtonWithTitle("OK")
            myerror.show()
        }
    }
    
    //MARK: IBActions
    
    // method that gets called everytime the user wants to see the museums in their mapview
    // storyboard seegue might be better
    // here just incase we want to implement some sort of progress bar
    @IBAction func venuesPresed(sender: AnyObject) {
        // show progress bar or indicator for this
        self.performSegueWithIdentifier("venueSegue", sender: sender)
    }
    
    
    // MARK: - Protocols
    
    // MARK: - MKMApviewDelegate
    
    // method that gets called everytime the user clicks on the find me button
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        
        // if it is set on follow then reset the location info and get device's location
        if mode == MKUserTrackingMode.Follow{
            enteredLoc=""
            fromMyLoc = true
            getMyLoc()
        }
    }
    
    // method that gets called everytime the region of the mapview changes
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // You first have to get the corner point and convert it to a coordinate
        let mapRect = self.myMapView.visibleMapRect;
        let cornerPointNW = MKMapPointMake(mapRect.origin.x, mapRect.origin.y);
        let cornerCoordinate = MKCoordinateForMapPoint(cornerPointNW);
        let cornerLoc = CLLocation(latitude: cornerCoordinate.latitude, longitude: cornerCoordinate.longitude)
        
        // Then get the center coordinate of the mapView
        let centerCoordinate = self.myMapView.centerCoordinate
        let centerLoc = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        
        // And then calculate the distance
        let distance = cornerLoc.distanceFromLocation(centerLoc)
        radius = Int(round(distance))
        
        // then update the museums around that location
        updateMusuems(centerLoc)
    }
    
    // delegate method that gets called everytime you add an annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // if the annotation is not a CPA then return nil
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        // create an annotation view
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        // if the view is empty set it up
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            anView!.draggable = false
            
            // set the right button as detail disclosure
            anView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            // set the left button to "go"
            let directionsButton: UIButton = UIButton(type: UIButtonType.System)
            directionsButton.frame = CGRectMake(0, 0, 26, 25)
            directionsButton.setBackgroundImage(UIImage(named: "go_button") as UIImage?, forState: .Normal)
            
            anView!.leftCalloutAccessoryView = directionsButton
            
        }
            
        else {
            anView!.annotation = annotation
        }
        
        // set the image for the view
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        
        return anView
    }
    
    // method that gets called if the callout is tapped
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        // gets the name of the callout/museum
        let extString = NSURL(fileURLWithPath: view.annotation!.title!!).relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        
        // if its the right then show the detail controller
        if control == view.rightCalloutAccessoryView{
            
            newUrlPath  = "https://data.imls.gov/resource/ku5e-zr2b.json?commonname=\(extString)&$select=location_1,commonname,phone,weburl,discipl"
            
            self.performSegueWithIdentifier("detailSegue", sender: nil)
            
        }else if control == view.leftCalloutAccessoryView{
            
            // if its the left button then go to maps and show the user how to get to the location
            // look for it in myMusdata instead of sending a query?
            
            let urlPath = "https://data.imls.gov/resource/ku5e-zr2b.json?commonname=\(extString)&$select=location_1,commonname"
            let url = NSURL(string: urlPath)
            
            if let musuemData=NSData(contentsOfURL:url!){
                
                
                do {
                    let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                    
                    
                    var json = positions as! Array<NSDictionary>
                    
                    if json.count >= 1 {
                        
                        print(json)
                        let myEntry: AnyObject = json[0]
                        let myLoc : AnyObject! = myEntry["location_1"]
                        
                        let selectedLoc = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(
                            numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue,
                            numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
                            ,addressDictionary: nil))

                        let currentLoc = MKMapItem.mapItemForCurrentLocation()
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
               
                        selectedLoc.name = myEntry["commonname"] as? String
                        currentLoc.name = "Current Location"
                        
                        json.removeAll(keepCapacity: false)

                        // opens maps with the required information
                        MKMapItem.openMapsWithItems([currentLoc, selectedLoc], launchOptions: launchOptions)
                        
                    }else{print("No points to plot/annotate")}
                }catch{error}
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // method that gets called everytime the device is asked to update it's location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // stop updating,get the last location and make the map around it
        locationManager.stopUpdatingLocation()
        
        let location = locations.last!
        
        makeMap(location)
        myMapView.showsUserLocation = true
        
        // set the center coordinate value to this location's coordinate
        centerCoordinate.latitude = location.coordinate.latitude
        centerCoordinate.longitude = location.coordinate.longitude
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // if ther was an error updating the location
        myerror.title = "Error"
        myerror.message = "Cannot determine Location"
        myerror.addButtonWithTitle("OK")
        myerror.show()
    }
}

// the custom class that has the string for the image name
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

