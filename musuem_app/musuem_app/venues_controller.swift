//
//  venues_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/19/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit
import CoreLocation

class venues_controller: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    
    
    @IBOutlet var searchBar: UITableView!
    @IBOutlet var tableView: UITableView!
    
    
    let textCellIdentifier = "TextCell"
    var searchActive : Bool = false
    
    var data :[String] = []
    var filtered:[String] = []
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getMyMusuemNames()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        searchActive = false
    }
    
    
    
    
    
    
    
    
    
    var musCordArray = [CLLocationCoordinate2D]()
    
    func getMyMusuemNames(){
        
        
        musCordArray.removeAll(keepCapacity: false)
        var musNameArray = [String]()
        
        
        if myMusuemData.count >= 1
        {
            for index in 0...myMusuemData.count-1{
                
                let myEntry = myMusuemData[index]
                let myLoc : AnyObject! = myEntry["location"]
                
                let newCord = CLLocationCoordinate2DMake(numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue, numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
                
                musNameArray.append(myEntry["commonname"] as! String)
                musCordArray.append(newCord)
            }
        }
        else
        {
            println("No musuems to parse")
            
        }
        
        
        
        data = musNameArray as [String]
        println(musNameArray.count)
        musNameArray.removeAll(keepCapacity: false)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        println("1")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        println("2")
    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchActive = false;
////        println("3")
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchActive = false;
////        println("4")
//    }
//    
    
    
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({ (text) -> Bool in
            
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
            
        })
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(searchActive) {
            return filtered.count
        }else{
            return data.count;
        }
    }
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        
        if(searchActive){
            if indexPath.row < filtered.count{
                cell.textLabel?.text = filtered[indexPath.row]
            }
            
        } else {
            cell.textLabel?.text = data[row]
        }
        
        
        
        
        
        
        
        
            let extString = NSURL(fileURLWithPath: cell.textLabel!.text!)!.relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
            let newurlPath = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname"
        
        
            if let musuemData=NSData(contentsOfURL:NSURL(string: newurlPath)!){
                if let musuemInfo: AnyObject! = NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(0), error: nil){
                    if let info = musuemInfo as? Array<NSDictionary> {
                        if info.count >= 1{
                            
                            let myEntry : AnyObject! = info[0]
                            var musName:String = myEntry["commonname"] as! String
                            
                            var centerLocation: CLLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
//                            if musName == data[row]{
//                                
//                                let myLoc : AnyObject! = myEntry["location"]
//                                
//                                
//                                let muscoordinates = CLLocationCoordinate2DMake(numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue, numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
//                                
//                                
//                                let musLocation: CLLocation = CLLocation(latitude: muscoordinates.latitude, longitude: muscoordinates.longitude)
//                                
//                                
//                                var distanceMeters = centerLocation.distanceFromLocation(musLocation)
//                                var distanceMiles = (distanceMeters / 1609.344)
//                                
//                                cell.detailTextLabel?.text = "\((round(10*distanceMiles))/10) mi."
//                            }
                        }
                    }
                }
        }
        
        
        return cell
   
    }
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let row = indexPath.row
        var name = ""
        
        if(searchActive){
            if indexPath.row < filtered.count{
             name = filtered[row]
            }
        } else {
            
            name = (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!
        }
        
        
        let extString = NSURL(fileURLWithPath: name)!.relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26")
        myNewURLPath = "https://data.imls.gov/resource/bqh6-bapa.json?$select=location,commonname,phone,weburl,discipl&commonname=\(extString)"
        
        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailViewController") as! UIViewController
        self.showViewController(vc, sender: self)
    }
    

}
