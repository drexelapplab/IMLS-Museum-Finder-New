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


public var radius = 2500
public var myMusuemData :  Array<NSDictionary> = []
public var centerCoordinate = CLLocationCoordinate2D()
public var myerror = UIAlertView()




class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    
    //    @IBOutlet var actIndict: UIActivityIndicatorView!
    
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    let buttonItem: MKUserTrackingBarButtonItem = MKUserTrackingBarButtonItem()
    var resultSearchController = UISearchController()
    
    //    let queue:NSOperationQueue = NSOperationQueue()
    
    
    @IBOutlet var bottomNavigation: UINavigationItem!
    @IBOutlet var myMapView: MKMapView!
    @IBOutlet weak var tblView: UITableView!
    
    
    var mapShown = true
    var fromMyLoc = false
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        buttonItem.mapView = myMapView
        self.bottomNavigation.rightBarButtonItem = buttonItem
        buttonItem.target = self
        
        self.resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.Black
            controller.searchBar.barTintColor = UIColor.whiteColor()
            controller.searchBar.backgroundColor = UIColor.grayColor()
            controller.searchBar.placeholder = "Search all by name"
            self.tblView.tableHeaderView = controller.searchBar
            
            
            return controller
            
            
        })()
        
        resultSearchController.searchBar.delegate = self
        
        tblView.delegate = self
        tblView.dataSource = self
        
        
        self.tblView.reloadData()
        tblView.hidden = true
        
        
        
        myMapView.showsPointsOfInterest = false
        
        
        
        if enteredLoc == ""
        {
            mapView(myMapView, didChangeUserTrackingMode: MKUserTrackingMode.Follow, animated: false)
        }
        
        
        
    }
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if enteredLoc != "" && fromAdd
        {
            findByAddress(enteredLoc)
            fromAdd = false
        }
        
        
        
        if fromCat
        {
            if enteredLoc == ""
            {
                getMyLoc()
                
            }else{
                findByAddress(enteredLoc)
            }
            
            fromCat = false
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func findByAddress(enteredLoc : String){
        
        geocoder.geocodeAddressString(enteredLoc) { (placemarks:[CLPlacemark]?, error) -> Void in
            
            if(error != nil) {
                
                myerror.title = "Error"
                myerror.message = "Could not go to the location"
                myerror.addButtonWithTitle("OK")
                myerror.show()
                
                print("Error Geocoding String")
            
            }else{
                let placemark = placemarks![0]
                let location = placemark.location!
                
                self.makeMap(location)
                self.myMapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.updateMusuems(location)
                
                
                
                centerCoordinate.latitude = location.coordinate.latitude
                centerCoordinate.longitude = location.coordinate.longitude
                
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
        
        tblView.hidden = true
        resultSearchController.active = false
        
        if mode == MKUserTrackingMode.Follow{
            enteredLoc=""
            fromMyLoc = true
            getMyLoc()
        }
    }
    
    
    
    func getMyLoc(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        let location = locations.last!
        
        makeMap(location)
        updateMusuems(location)
        myMapView.showsUserLocation = true
        
        centerCoordinate.latitude = location.coordinate.latitude
        centerCoordinate.longitude = location.coordinate.longitude
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        myerror.title = "Error"
        myerror.message = "Cannot determine Location"
        myerror.addButtonWithTitle("OK")
        myerror.show()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func venuesPresed(sender: AnyObject) {
        
        //        let myString = "tel://9809088798"
        //
        //        println(UIApplication.sharedApplication().canOpenURL(NSURL(string : myString)!))
        //
        //        UIApplication.sharedApplication().openURL( NSURL(string : myString)!)
        
        
        //        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        //        spinner.frame = CGRectMake(round((view.frame.size.width - 25) / 2), round((view.frame.size.height - 25) / 2), 25, 25)
        //        spinner.color = UIColor.blueColor().colorWithAlphaComponent(0.6)
        //        spinner.hidesWhenStopped = true
        //
        //        self.view.addSubview(spinner)
        //        spinner.startAnimating()
        //        spinner.stopAnimating()
        //        spinner.startAnimating()
        //        spinner.stopAnimating()
        //        spinner.startAnimating()
        
        
        
        self.performSegueWithIdentifier("venueSegue", sender: sender)
    }
    
    
    
    
    
    func switchIndOnOff(){
        
        
        
        //        if self.actIndict.hidden == true {
        //            self.actIndict.hidden = false
        //        }else{
        //            self.actIndict.hidden = true
        //        }
    }
    
    
    
    
    @IBAction func pressed(sender: AnyObject) {
        print("show/hide searchbar")
        if mapShown {
            tblView.hidden = false
            mapShown = false
        }else{
            tblView.hidden = true
            mapShown = true
        }
        
    }
    
    
    
    
    
    
    
    func makeMap(location : CLLocation){
        
        let region = MKCoordinateRegion(
            center:CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude),
            span: MKCoordinateSpanMake(0.015, 0.015))
        
        
        if fromMyLoc || enteredLoc != ""{
            myMapView.setRegion(region, animated: true)
            print("fromMyLoc = \(fromMyLoc)")
            fromMyLoc = false
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func updateMusuems(loc: CLLocation){
        
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        
        var urlPath = "https://data.imls.gov/resource/bqh6-bapa.json?$select=location,commonname,phone,discipl,weburl&$where=within_circle(location,\(loc.coordinate.latitude),\(loc.coordinate.longitude),\(radius))"
        
        
        if musCatArray.count >= 1
        {
            urlPath = urlPath + catString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
        }
        
        print(urlPath)
        
        let url = NSURL(string: urlPath)
        
        if let musuemData=NSData(contentsOfURL:url!){
           do{
                let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                
                var json = positions as! Array<NSDictionary>
                
                if json.count >= 1 {
                    
                    myMusuemData=json
                    self.makeAnnotations(json)
                    
                    venues_controller().getMyMusuemNames()
                    
                    
                    
                    
                    json.removeAll(keepCapacity: false)
                    
                }else{
                    print("No points to plot/annotate")
                }
                
            }catch{error}
            
        }else{
            
            myerror.title = "Error"
            myerror.message = "Could not connect to server"
            myerror.addButtonWithTitle("OK")
            myerror.show()
        }
        
        
        //        let task: Void = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        //
        //            if error != nil {
        //            println(error)
        //            }
        //
        //            if let positions: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil){
        //
        //                if let json = positions as? Array<NSDictionary> {
        //                    if json.count >= 1 {
        //
        //                        myMusuemData=json
        //                        self.makeAnnotations(json)
        //                        println("Updated")
        //
        //                    }else{
        //                        println("No points to plot/annotate")
        //                    }
        //
        //
        //                }
        //            }
        //
        //        }.resume()
        
    }
    
    
    
    
    
    
    
    
    
    func makeAnnotations(json : Array<AnyObject>){
        
        //do I need this line?
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        
        if json.count >= 1 {
            for index in 0...json.count-1{
                
                let myEntry: AnyObject = json[index]
                let discipl:String = myEntry["discipl"] as! String
                let musName:String = myEntry["commonname"] as! String
                let myLoc : AnyObject! = myEntry["location"]
                
                // makes the annotation
                
                let annotation = CustomPointAnnotation()
                
                
                if let human_address : AnyObject! = myLoc["human_address"]
                {
                    
                    let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
                    
                    annotation.subtitle = partialAddress
                    
                }
                
                
                annotation.title = musName
                
                annotation.coordinate = CLLocationCoordinate2DMake(
                    numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue,
                    numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
                
                
                annotation.imageName = discipl
                
                self.myMapView.addAnnotation(annotation)
            }
            
        }else{
            myerror.title = "Error"
            myerror.message = "No museums to show"
            myerror.addButtonWithTitle("OK")
            myerror.show()
        }
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        
        
        
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        
        
        
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            anView!.draggable = false
            anView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            
            
            let directionsButton: UIButton = UIButton(type: UIButtonType.System)
            directionsButton.frame = CGRectMake(0, 0, 23, 23)
            directionsButton.setTitle("GO", forState: .Normal)
            directionsButton.titleLabel?.font = UIFont.systemFontOfSize(14.5)
            
            //            directionsButton.setBackgroundImage(UIImage(named: "bentArrow.jpg") as UIImage?, forState: .Normal)
            
            anView!.leftCalloutAccessoryView = directionsButton
            
        }
            
        else {
            anView!.annotation = annotation
        }
        
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        
        return anView
    }
    
    
    
    
    
    
    
    
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let extString = NSURL(fileURLWithPath: view.annotation!.title!!).relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        
        
        if control == view.rightCalloutAccessoryView{
            
            
            myNewURLPath  = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname,phone,weburl,discipl"
            
            let storyboard = UIStoryboard(name: "Main" , bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("detailViewController")
            self.showViewController(vc, sender: self)
            
            
            
        }else if control == view.leftCalloutAccessoryView
        {
            // look for it in myMusdata instead of sending a query
            
            let urlPath = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname"
            let url = NSURL(string: urlPath)
            
            if let musuemData=NSData(contentsOfURL:url!){
                
                
                do {let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                    
                    
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
                        
                        
                        
                        MKMapItem.openMapsWithItems([currentLoc, selectedLoc], launchOptions: launchOptions)
                        
                        
                    }else{
                        print("No points to plot/annotate")
                    }
                }catch{error}
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    @IBOutlet var searchBar: UISearchBar!
    //    @IBOutlet var tableView: UITableView!
    
    var data:[String] = []
    var adresses:[String] = []
    var filtered:[String] = []
    var limit = 5
    
    
    
    
    
    
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellforrow")
        
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
    
    
    
    
    
    
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        sendQueryAndGetNames()
        
        
        tblView.reloadData()
        
        print("updateSearchResultsForSearchController")
        
    }
    
    
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("BeginEditing")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("EndEditing")
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let ext = NSURL(fileURLWithPath: (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!)
        
        let extString = ext.relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        myNewURLPath = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname,phone,weburl,discipl"
        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
        
        
        
        
        tblView.hidden = true
        resultSearchController.active = false
        
        
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailViewController")
        self.showViewController(vc, sender: self)
        
        }
    
    
    
    
    
    
    
    func sendQueryAndGetNames(){
        var queryPath = "https://data.imls.gov/resource/bqh6-bapa.json?$select=commonname,location&$limit=\(limit)&$q=(\(resultSearchController.searchBar.text))"
        queryPath = queryPath.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        
        if let queryURL=NSURL(string: queryPath){
            if let positionData=NSData(contentsOfURL:queryURL){
                
                
                
                do{let positions: AnyObject! = try NSJSONSerialization.JSONObjectWithData(positionData, options: NSJSONReadingOptions(rawValue: 0))
                    
                    if let json = positions as? Array<NSDictionary> {
                        if json.count >= 1 {
                            
                            data.removeAll(keepCapacity: false)
                            adresses.removeAll(keepCapacity: false)
                            
                            for index in 0...json.count-1{
                                
                                let myEntry = json[index]
                                if let musName = myEntry["commonname"] as? String{
                                    data.append(musName)
                                }
                                
                                
                                
                                let myLoc : AnyObject! = myEntry["location"]
                                
                                if let human_address : AnyObject! = myLoc["human_address"]
                                    
                                {
                                    let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
                                    
                                    adresses.append(partialAddress)
                                }
                                
                                
                                
                                
                            }
                        }else{
                            data.removeAll(keepCapacity: false)
                            adresses.removeAll(keepCapacity: false)
                            print("No Matches")
                        }
                    }
                }catch{error}
            }else{
                
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



class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

