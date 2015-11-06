//
//  venues_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/19/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit
import CoreLocation

class venues_controller: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate{

    // MARK: Properties
    var searchController = UISearchController()
    var data :[String] = []
    var filtered:[String] = []
    
    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //get all my museum names
        getMyMusuemNames()
        
        
        //setting up the search bar and all its properties with the results view at the top
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.barStyle = UIBarStyle.Default
            controller.searchBar.barTintColor = UIColor.grayColor()
            controller.searchBar.backgroundColor = UIColor.whiteColor()
            controller.searchBar.placeholder = "Search this list by name"
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        // initial setup and delegation
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        //        self.tableView.scrollIndicatorInsets.top = 0
        //        tableView.contentInset = UIEdgeInsetsZero
        
        self.tableView.reloadData()
    }
    // MARK: Functions
    //method that parses the info and adds the info to an array
    func getMyMusuemNames(){
        
        var musNameArray = [String]()
        
        
        if myMusuemData.count >= 1
        {
            for index in 0...myMusuemData.count-1{
                
                let myEntry = myMusuemData[index]
                
                musNameArray.append(myEntry["commonname"] as! String)
            }
        }
        else
        {
            print("No musuems to parse")
            
        }
        
        data = musNameArray as [String]
        print(musNameArray.count)
        musNameArray.removeAll(keepCapacity: false)
        
    }
    
    // MARK: IBActions
    
    // MARK: - Protocols
    
    // MARK: TableViewDatasource, TableView Delegate
    
    //number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if the search is active then the number of rows is the filterd count
        if(self.searchController.active) {
            return filtered.count
        }else{
            return data.count;
        }
    }
    
    
    
    //method that makes all the cells in a table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier:"Cell")
        cell.selectionStyle =  UITableViewCellSelectionStyle.Blue
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textAlignment = NSTextAlignment.Left
        cell.textLabel?.numberOfLines = 3
        
        cell.textLabel?.textColor = self.view.tintColor
        cell.textLabel?.font = UIFont.systemFontOfSize(12.0)
        
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(8.0)
        
        
        //sets the name to the title
        if(self.searchController.active){
            if indexPath.row < filtered.count{
                cell.textLabel?.text = filtered[indexPath.row]
            }
            
        } else {
            cell.textLabel?.text = data[indexPath.row]
        }
        
        
        
        
        //send the query to get all the remaining details for that museum
        let extString = NSURL(fileURLWithPath: cell.textLabel!.text!).relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        let newurlPath = "https://data.imls.gov/resource/ku5e-zr2b.json?commonname=\(extString)&$select=location_1,commonname"
        
        
        if let musuemData=NSData(contentsOfURL:NSURL(string: newurlPath)!){
            
            
            do {
                let musuemInfo: AnyObject! = try NSJSONSerialization.JSONObjectWithData(musuemData, options: NSJSONReadingOptions(rawValue: 0))
                if let info = musuemInfo as? Array<NSDictionary> {
                    if info.count >= 1{
                        
                        let myEntry : AnyObject! = info[0]
                        let musName = myEntry["commonname"] as! String
                        
                        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
                        
                        
                        if musName == data[indexPath.row]{
                            
                            
                            //gets the location of the museum and calculates the distance from your locations for every cell
                            
                            let myLoc : AnyObject! = myEntry["location_1"]
                            
                            
                            let muscoordinates = CLLocationCoordinate2DMake(numberFormatter.numberFromString(myLoc["latitude"] as! String)!.doubleValue, numberFormatter.numberFromString(myLoc["longitude"] as! String)!.doubleValue)
                            
                            
                            let musLocation: CLLocation = CLLocation(latitude: muscoordinates.latitude, longitude: muscoordinates.longitude)
                            
                            
                            let distanceMeters = centerLocation.distanceFromLocation(musLocation)
                            let distanceMiles = (distanceMeters / 1609.344)
                            
                            
                            //sets the distance to the detail label
                            cell.detailTextLabel?.text = "\((round(10*distanceMiles))/10) mi."
                        }
                        
                        
                    }
                }
            }catch{error}
            
        }
        return cell
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // if the user selects one of the cells then prep the query string and show the detail view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let name = (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!
        
        
        let extString = NSURL(fileURLWithPath: name).relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26")
        newUrlPath = "https://data.imls.gov/resource/ku5e-zr2b.json?$select=location_1,commonname,phone,weburl,discipl&commonname=\(extString)"
        
        searchController.active = false
        
        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("detailController")
        self.showViewController(vc, sender: self)
    }
    
    // MARK: UISearchResultsUpdating, UISearchBarDelegate
    //method that gets called everytime the text changes
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        //filters the table with the the text in the search bar
        
        filtered = data.filter({ (text) -> Bool in
            
            let tmp: NSString = text
            let range = tmp.rangeOfString(self.searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
            
        })
        
        //if the search returns nothing then show all
        if(filtered.count == 0){
            filtered = data
        }
        
        
        self.tableView.reloadData()
        print("updateSearchResultsForSearchController")
        
    }
    
}
