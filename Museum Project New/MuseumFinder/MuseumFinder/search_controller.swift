//
//  search_controller.swift
//  MuseumFinder
//
//  Created by AJ Beckner on 10/27/15.
//  Copyright © 2015 IMLS. All rights reserved.
//

import UIKit

class search_controller: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating, UISearchBarDelegate {

    // MARK: Properties
    
    var resultSearchController = UISearchController()
    // Search bar and updater
    var data:[String] = []
    var addresses:[String] = []
    //    var filtered:[String] = []
    var limit = 100 //the amount of matches you want returned
    
    // MARK: IBOutlets
    
    /// tableview for displaying search results
    @IBOutlet weak var searchTableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.searchTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        
        //initial setup and delegation
        resultSearchController.searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        self.searchTableView.reloadData()
        //searchTableView.hidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    
    /**
    Manually parses a dictionary from raw JSON string using two functions to strip delimiters and split the data appropriately.
    
    WARNING: only intended for use with IMLS JSON. Needs to be reformatted for other uses
    
    the the JSON returned by IMLS' API has a bad array as one of the object properties I could not figure out how to parse it correctly with swiftyjson so I did it manually using these functions
    
    - Parameter str: string of JSONData to parse
    */
    func getDictionaryFromIMLSJSON(str:String)->Dictionary<String,String>{
        
        
        /**
         Removes the formatting of the bad JSON from a string
         
         the the JSON returned by IMLS' API has a bad array as one of the object properties
         I could not figure out how to parse it correctly with swiftyjson so I did it manually
         
         - Parameter addressDictionary: string value of bad JSON
         */
        func removeFormatting(addressDictionary:String) -> String{
            return addressDictionary
                .stringByReplacingOccurrencesOfString("{", withString: "")
                .stringByReplacingOccurrencesOfString("}", withString: "")
                .stringByReplacingOccurrencesOfString(",", withString: "")
                .stringByReplacingOccurrencesOfString("\"", withString: "")
                .stringByReplacingOccurrencesOfString(":", withString: "")
        }
        
        /**
         Takes an array of strings and splits them up at points that match the token; returns new array
         
         e.g. splitAllStringsInArray(["1foo2foo3","4foo5"],"foo")
         
         returns: ["1","2","3","4","5"]
         
         the the JSON returned by IMLS' API has a bad array as one of the object properties I could not figure out how to parse it correctly with swiftyjson so I did it manually using these functions
         
         - Parameter strArray: string array
         - Parameter token: token string to remove and split at
         */
        func splitAllStringsInArray(inout strArray:[String],at token:String){
            for s in strArray{
                if let pos = strArray.indexOf(s){
                    let front = Array(strArray[0..<pos])
                    let middle = s.componentsSeparatedByString(token)
                    let end = Array(strArray[pos+1..<strArray.count])
                    strArray = front + middle + end
                } else {
                    print("split failed")
                }
            }
        }
        if (str != ""){
            var strArray = [removeFormatting(str)]
            splitAllStringsInArray(&strArray, at: "address")
            splitAllStringsInArray(&strArray, at: "city")
            splitAllStringsInArray(&strArray, at: "state")
            splitAllStringsInArray(&strArray, at: "zip")
            //expected output after four method calls: strArray[0] is blank 2...4 have address,city,state,zip in that order
            let humanAddress = ["address":strArray[1],"city":strArray[2],"state":strArray[3],"zip":strArray[4]]
            return humanAddress
        } else {return ["address":"","city":"","state":"","zip":""]}
    }
    
    
    
    func sendQueryAndGetNames(){
            
            var queryPath = "https://data.imls.gov/resource/ku5e-zr2b.json?$select=commonname,location_1&$q=(\(self.resultSearchController.searchBar.text!))"
            
            queryPath = queryPath.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            let queryURL = NSURL(string: queryPath)
            
            let posData = try? NSData(contentsOfURL: queryURL!,options: [])
            let json = JSON(data: posData!)
            
            //removes the previous info
            print("remove info")
            self.data.removeAll(keepCapacity: false)
            self.addresses.removeAll(keepCapacity: false)
            
            for i in 0 ..< json.count {
                self.data.append(json[i]["commonname"].stringValue)
                let humanAddressJSONString = json[i]["location_1"]["human_address"].stringValue
                let addressText = self.getDictionaryFromIMLSJSON(humanAddressJSONString)["city"]! + ", "+self.getDictionaryFromIMLSJSON(humanAddressJSONString)["state"]!
                self.addresses.append(addressText)
            }
    }
    
    // MARK: IBActions
    
    // MARK: Protocols

    //MARK: UITableViewDataSource, UITableViewDelegate
    
    // if a cell is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //deselct the row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //prep the query
        if let text = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text {
            let ext = NSURL(fileURLWithPath: text)
        
            let extString = ext.relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
            newUrlPath = "https://data.imls.gov/resource/ku5e-zr2b.json?commonname=\(extString)&$select=location_1,commonname,phone,weburl,discipl"
            //show the details view
            let storyboard = UIStoryboard(name: "Main" , bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("detailController")
            self.showViewController(vc, sender: self)
        } else {
            self.searchTableView.reloadData()
        }
    }
    
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
        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
        
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(12.0)
        if indexPath.row < data.count{
            cell.textLabel?.text = data[indexPath.row]
            cell.detailTextLabel?.text = addresses[indexPath.row]
        }
        
        return cell;
    }
    
    //MARK: UISearchResultsUpdating, UISearchBarDelegate
    
    //everytime the user adds a new charcter then send the query and update the table view
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in

            self.sendQueryAndGetNames()
            //removes the previous info
            
            dispatch_async(dispatch_get_main_queue()) {
                self.searchTableView.reloadData()
                print("updateSearchResultsForSearchController")
            }
        }
    }
}
