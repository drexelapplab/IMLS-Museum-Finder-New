//
//  ViewController.swift
//  MuseumFinder
//
//  Created by Dagmawi on 9/13/15.
//  Copyright © 2015 IMLS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


// made a few public variable to pass information among controller classes, probably better to use prepforsegue method
public var myMusuemData :  Array<NSDictionary> = []
public var centerCoordinate = CLLocationCoordinate2D()
public var myerror = UIAlertView()




class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    
    
    // declaring and initalizing variables
    var radius = 1263
    var annotationArray = [CustomPointAnnotation]()
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    let buttonItem = MKUserTrackingBarButtonItem()
    var resultSearchController = UISearchController()
    
    
    @IBOutlet var bottomNavigation: UINavigationItem!
    @IBOutlet var myMapView: MKMapView!
    @IBOutlet weak var tblView: UITableView!
    
    
    var mapShown = true
    var fromMyLoc = false
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the find me button to the bottom right of my screen
        buttonItem.mapView = myMapView
        self.bottomNavigation.rightBarButtonItem = buttonItem
        buttonItem.target = self
        
        //setting up the search bar and all its properties with the results view at the top
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.Default
            controller.searchBar.barTintColor = UIColor.grayColor()
            controller.searchBar.backgroundColor = UIColor.whiteColor()
            controller.searchBar.placeholder = "Search all by name"
            self.tblView.tableHeaderView = controller.searchBar
            return controller

            
        })()
        
        
        // initial setup and delegation
        resultSearchController.searchBar.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
        self.tblView.reloadData()
        tblView.hidden = true
        
        
        //initial map does not show points of interest since it is too much information for the first view
        
        myMapView.showsPointsOfInterest = false
        
        if enteredLoc == ""
        {
            mapView(myMapView, didChangeUserTrackingMode: MKUserTrackingMode.Follow, animated: false)
        }
        
        
        
    }
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // this method sets up all the mapview in response to which view controller sent the request
        
        //if it is from the add screen and there is an entered location
        if enteredLoc != "" && fromAdd
        {
            // parse the given address and set the bool back to false
            findByAddress(enteredLoc)
            fromAdd = false
        }
        
        
        // if it is from the categories controller
        if fromCat
        {
            // if there is no entered location
            if enteredLoc == ""
            {
                // resend the query with the new category information
                getMyLoc()
                
            }else{
                
                // if there is an entered location then send a query at that location
                findByAddress(enteredLoc)
            }
            
            //reset the bool
            fromCat = false
        }
        
        
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
                let placemark = placemarks![0]
                let location = placemark.location!
                
                self.makeMap(location)
                self.myMapView.addAnnotation(MKPlacemark(placemark: placemark))
                
                
                // sets the center coordinate to the value of this location
                centerCoordinate.latitude = location.coordinate.latitude
                centerCoordinate.longitude = location.coordinate.longitude
                
                
                // sets the annotation's callout to the name of the placemark
                let ann = MKPointAnnotation()
                ann.coordinate = centerCoordinate
                
                if let name = placemark.name
                {
                    ann.title = name
                    
                    if let locality = placemark.locality
                    {
                        ann.title = ann.title! + ", " + locality
                        
                        if let aArea = placemark.administrativeArea
                        {
                            ann.title = ann.title! + ", " + aArea
                            
                            if let pCode = placemark.postalCode
                            {
                                ann.title = ann.title! + "-" + pCode
                            }
                        }
                    }
                }
                
                self.myMapView.addAnnotation(ann)
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // method that gets called everytime the user clicks on the find me button
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        
        //hides the search results view
        tblView.hidden = true
        resultSearchController.active = false
        
        // if it is set on follow then reset the location info and get device's location
        if mode == MKUserTrackingMode.Follow{
            enteredLoc=""
            fromMyLoc = true
            getMyLoc()
        }
    }
    
    
    // starts updating the location
    func getMyLoc(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //method that gets called everytime the device is asked to update it's location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //stop updating,get the last location and make the map around it
        
        locationManager.stopUpdatingLocation()
        
        let location = locations.last!
        
        makeMap(location)
        myMapView.showsUserLocation = true
        
        //set the center coordinate value to this location's coordinate
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //method that gets called everytime the user wants to see the museums in their mapview
    //storyboard seegue might be better
    //here just incase we want to implement some sort of progress bar
    
    @IBAction func venuesPresed(sender: AnyObject) {
        // show progress bar or indicator for this
            self.performSegueWithIdentifier("venueSegue", sender: sender)
    }
    
    
    
    
    
    
    // if the search icon is pressed, it either drops down the search bar or hides it
    @IBAction func pressed(sender: AnyObject) {
        if mapShown {
            tblView.hidden = false
            mapShown = false
        }else{
            tblView.hidden = true
            mapShown = true
        }
        
    }
    
    
    
    
    
    
    // method that makes the map around a certain location
    func makeMap(location : CLLocation){
        
        let region = MKCoordinateRegion(
            center:CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude),
            span: MKCoordinateSpanMake(0.015, 0.015))
        
        
        
        //only updates the mapview if its called from find me button or there is no entered location
        
        if fromMyLoc || enteredLoc != ""{
            myMapView.setRegion(region, animated: true)
            print("fromMyLoc = \(fromMyLoc)")
            fromMyLoc = false
        }
        
        
    }
    
    
    
    
    
    // method that gets called everytime the region of the mapview changes
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        //hides the searchbar results view
        tblView.hidden = true
        resultSearchController.active = false
        
        // You first have to get the corner point and convert it to a coordinate
        let  mapRect = self.myMapView.visibleMapRect;
        let  cornerPointNW = MKMapPointMake(mapRect.origin.x, mapRect.origin.y);
        let cornerCoordinate = MKCoordinateForMapPoint(cornerPointNW);
        let cornerLoc = CLLocation(latitude: cornerCoordinate.latitude, longitude: cornerCoordinate.longitude)
        
        // Then get the center coordinate of the mapView 
        let centerCoordinate = self.myMapView.centerCoordinate
        let centerLoc = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        
        // And then calculate the distance
        let distance = cornerLoc.distanceFromLocation(centerLoc)
        radius = Int(round(distance))
        
        //then update the museums around that location
        updateMusuems(centerLoc)
    }
    
    
    
    
    
    
    
    
    
    //method that gets called everytime you want to update the museums in the mapview
    func updateMusuems(loc: CLLocation){
        
        //removes all the old annotations
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        
        //sets a cap on the radius
        if radius > 20000{
        radius = 20000
        }
        
        //sets the query url up
        var urlPath = "https://data.imls.gov/resource/bqh6-bapa.json?$select=location,commonname,phone,discipl,weburl&$where=within_circle(location,\(loc.coordinate.latitude),\(loc.coordinate.longitude),\(radius))"
        
        //if there is a certain category the user wants to look at then add that to the query path
        if musCatArray.count >= 1
        {
            urlPath = urlPath + catString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
        }
        
        
        print(urlPath)
        
        //convert to url and send the query
        let url = NSURL(string: urlPath)
        
        // if you can set the contens of the query to a variable
        if let musuemData=NSData(contentsOfURL:url!){
            
            do{
                //parse the data
                let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                
                //convert to array
                var json = positions as! Array<NSDictionary>
                if json.count >= 1 {
                    
                    //set to a public property to be suer by another controller
                    myMusuemData=json
                    
                    //add the annotation
                    self.makeAnnotations(json)
                    
                    //remove all th values from my array
                    json.removeAll(keepCapacity: false)
                    
                }else{
                    print("No points to plot/annotate")
                }
                
            }catch{error}
            
        }else{
            //if there is an error
            myerror.title = "Error"
            myerror.message = "Could not connect to server"
            myerror.addButtonWithTitle("OK")
            myerror.show()
        }
        
    }
    
    
    
    
    
    
    
    
    
    func makeAnnotations(json : Array<AnyObject>){
        
        
        //if ther is one or more values in the array
        if json.count >= 1 {
            
            //for every value, get the info(discipl,commonname,location...),parse them and add them to the annotation array
            for index in 0...json.count-1{
                
                let myEntry: AnyObject = json[index]
                let discipl:String = myEntry["discipl"] as! String
                let musName:String = myEntry["commonname"] as! String
                let myLoc : AnyObject! = myEntry["location"]
                
                
                
                
                
                //make a custom point annotation
                let annotation = CustomPointAnnotation()
                
                
                // sets the address to the subtitle
                if let human_address : AnyObject! = myLoc["human_address"]
                {
                    
                    let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
                    
                    annotation.subtitle = partialAddress
                    
                }
                
                //sets the name to the title
                annotation.title = musName
                
                //sets the coordinate to the mus's location
                annotation.coordinate = CLLocationCoordinate2DMake(
                    numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue,
                    numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
                
                
                //the names of the images must directly coorelate to the value for the discipl field from the API for this line to work
                annotation.imageName = discipl
                
                //add the annotation to an array
                annotationArray.append(annotation)
            }
            
            
            //remove the old annotations and add the new ones
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        self.myMapView.addAnnotations(annotationArray)
            
            //remove all the annotation from the annotation array
        annotationArray.removeAll(keepCapacity: false)
        
        }else{
            // if there are no museums
            myerror.title = "Error"
            myerror.message = "No museums to show"
            myerror.addButtonWithTitle("OK")
            myerror.show()
        }
    }
    
    
    
    
    
    
    
    
    
    //delegate method that gets called everytime you add an annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        //if the annotation is not a CPA then return nil
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        //create an annotation view
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        // if the view is empty set it up
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            anView!.draggable = false
            
            //set the right button as detail disclosure
            anView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            //set the left button to "go"
            let directionsButton: UIButton = UIButton(type: UIButtonType.System)
            directionsButton.frame = CGRectMake(0, 0, 26, 25)
            directionsButton.setBackgroundImage(UIImage(named: "go_button") as UIImage?, forState: .Normal)
            
            anView!.leftCalloutAccessoryView = directionsButton
            
        }
            
        else {
            anView!.annotation = annotation
        }
        
        //set the image for the view
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        
        return anView
    }
    
    
    
    
    
    
    
    
    
    
    //method that gets called if the callout is tapped
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        //gets the name of the callout/museum
        let extString = NSURL(fileURLWithPath: view.annotation!.title!!).relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        
        //if its the right then show the detail controller
        if control == view.rightCalloutAccessoryView{
            
            myNewURLPath  = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname,phone,weburl,discipl"
        
            self.performSegueWithIdentifier("detailSegue", sender: nil)
            
            
            
        }else if control == view.leftCalloutAccessoryView
        {
            
            
            //if its the left button then go to maps and show the user how to get to the location
            // look for it in myMusdata instead of sending a query?
            
            let urlPath = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname"
            let url = NSURL(string: urlPath)
            
            if let musuemData=NSData(contentsOfURL:url!){
                
                
                do {
                    let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                    
                    
                    var json = positions as! Array<NSDictionary>
                    
                    if json.count >= 1 {
                        
                        print(json)
                        let myEntry: AnyObject = json[0]
                        let myLoc : AnyObject! = myEntry["location"]
                        
                        
                        
                        
                        let selectedLoc = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(
                            numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue,
                            numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
                            ,addressDictionary: nil))
                        
                        
                        
                        let currentLoc = MKMapItem.mapItemForCurrentLocation()
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        
                        
                        selectedLoc.name = myEntry["commonname"] as? String
                        currentLoc.name = "Current Location"
                        
                        json.removeAll(keepCapacity: false)
                        
                        
                        //opens maps with the required information
                        MKMapItem.openMapsWithItems([currentLoc, selectedLoc], launchOptions: launchOptions)
                        
                        
                    }else{
                        print("No points to plot/annotate")
                    }
                }catch{error}
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Search bar and updater
    
    
    
    //declaring the properties
    var data:[String] = []
    var adresses:[String] = []
    var filtered:[String] = []
    
    //the amount of matches you want returned
    var limit = 5
    
    
    
    //number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //number of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count;
    }
    
    
    
    
    //sets the information for every cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"addCategoryCell")
        cell.selectionStyle =  UITableViewCellSelectionStyle.Blue
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textAlignment = NSTextAlignment.Left
        cell.textLabel?.numberOfLines = 3
        
        cell.textLabel?.textColor = self.view.tintColor
        cell.textLabel?.font = UIFont.systemFontOfSize(12.0)
        
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(8.0)
        
        cell.textLabel?.text = data[indexPath.row]
        cell.detailTextLabel?.text = adresses[indexPath.row]
        
        
        return cell;
        
    }
    
    
    
    
    
    
    
    
    //everytime the user adds a new charcter then send the query and update the table view
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        sendQueryAndGetNames()
        self.tblView.reloadData()
        
        print("updateSearchResultsForSearchController")
        
    }
    
    
    
    
    // if a cell is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //deselct the row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //prep the query
        let ext = NSURL(fileURLWithPath: (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!)
        
        let extString = ext.relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        myNewURLPath = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname,phone,weburl,discipl"
        
        
        //hides the table view
        tblView.hidden = true
        resultSearchController.active = false
        
        //show the details view
        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailController")
        self.showViewController(vc, sender: self)
        
        }
    
    
    
    
    
    
    //method that sends the query when the text changes
    func sendQueryAndGetNames(){
        
        //prep the query
        var queryPath = "https://data.imls.gov/resource/bqh6-bapa.json?$select=commonname,location&$limit=\(limit)&$q=(\(resultSearchController.searchBar.text!))"
        print(queryPath)
        queryPath = queryPath.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        
        //sends the query with the tet from the search bar
        if let queryURL=NSURL(string: queryPath){
            if let positionData=NSData(contentsOfURL:queryURL){
                do{
                    let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(positionData, options: NSJSONReadingOptions(rawValue: 0))
                    if let json = positions as? Array<NSDictionary> {
                        if json.count >= 1 {
                            
                            
                            //removes the previous info
                            data.removeAll(keepCapacity: false)
                            adresses.removeAll(keepCapacity: false)
                            
                            
                            //parses the info and add it to the array
                            for index in 0...json.count-1{
                                
                                let myEntry = json[index]
                                if let musName = myEntry["commonname"] as? String{
                                    data.append(musName)
                                }
                                
                                
                                //get the location
                                let myLoc : AnyObject! = myEntry["location"]
                                
                                
                                //get the address and append it to the address array
                                if let human_address : AnyObject! = myLoc["human_address"]
                                    
                                {
                                    let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
                                    
                                    adresses.append(partialAddress)
                                }
                            }
                        }else{
                            //remove all the previous info
                            data.removeAll(keepCapacity: false)
                            adresses.removeAll(keepCapacity: false)
                            print("No Matches")
                        }
                    }
                }catch{error}
                
            }else{
                //if there is an error sending the query
                myerror.title = "Error"
                myerror.message = "Couldn't connect to Server"
                myerror.addButtonWithTitle("OK")
                myerror.show()
                
                
            }
        }
        
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// the custom class that has the string for the image name
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

