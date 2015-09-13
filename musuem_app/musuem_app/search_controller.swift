//
//  search_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/28/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit

class search_controller: UIViewController
//, UISearchBarDelegate, UITableViewDelegate , UITableViewDataSource
{
    
//    @IBOutlet var searchBar: UISearchBar!
//    @IBOutlet var tableView: UITableView!
//    
//    var searchActive : Bool = false
//    var data = Array<String>()
//    var adresses = Array<String>()
//    var filtered:[String] = []
//    var limit = 5
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    
//    
//    
//    
//    func sendQueryAndGetNames(){
//    var queryPath = "https://data.imls.gov/resource/bqh6-bapa.json?$select=commonname,location&$limit=\(limit)&$q=(\(searchBar.text))"
//        queryPath = queryPath.stringByReplacingOccurrencesOfString(" ", withString: "%20")
//        
//        
//        if let queryURL=NSURL(string: queryPath){
//            
////            println("URL'd")
//            
//            if let positionData=NSData(contentsOfURL:queryURL){
//                if let positions: AnyObject! = NSJSONSerialization.JSONObjectWithData(positionData, options: NSJSONReadingOptions(0), error: nil){
//                    
//                    if let json = positions as? Array<NSDictionary> {
//                        if json.count >= 1 {
//                            
//                            data.removeAll(keepCapacity: false)
//                            adresses.removeAll(keepCapacity: false)
//                            
//                                for index in 0...json.count-1{
//                                    
//                                     let myEntry = json[index]
//                                        if let musName = myEntry["commonname"] as? String{
//                                            data.append(musName)
//                                        }
//                                    
//                                    
//                                    
//                                    let myLoc : AnyObject! = myEntry["location"]
//                                    
//                                    if let human_address : AnyObject! = myLoc["human_address"]
//                                        
//                                    {
//                                        let partialAddress = (human_address as? String)!.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString(",", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("address", withString: "").stringByReplacingOccurrencesOfString("city", withString: "").stringByReplacingOccurrencesOfString("state", withString: "").stringByReplacingOccurrencesOfString("zip", withString: "").stringByReplacingOccurrencesOfString(":", withString: "")
//                                        
//                                        adresses.append(partialAddress)
//                                    }
//                                    
//                                    
//                                    
//                                    
//                                }
//                        }else{
//                            data.removeAll(keepCapacity: false)
//                            adresses.removeAll(keepCapacity: false)
//                            println("No Matches")
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchActive = true;
//        println("BeginEditing")
//    }
//    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        searchActive = false;
//        println("EndEditing")
//    }
//    
//    
//    
//    
//    
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        sendQueryAndGetNames()
//        self.tableView.reloadData()
//    }
//    
//    
//    
//    
//    
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count;
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
//        
//        cell.textLabel?.text = data[indexPath.row]
//        cell.detailTextLabel?.text = adresses[indexPath.row]
//        
//        return cell;
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        if let ext = NSURL(fileURLWithPath: data[indexPath.row])
//        {
//            
//            let extString = ext.relativeString!.stringByReplacingOccurrencesOfString("&", withString: "%26").stringByReplacingOccurrencesOfString("+", withString: "%2B")
//            myNewURLPath = "https://data.imls.gov/resource/bqh6-bapa.json?commonname=\(extString)&$select=location,commonname,phone,weburl,discipl"
//            let storyboard = UIStoryboard(name: "Main" , bundle: nil)
//                
//            
//            if let vc = storyboard.instantiateViewControllerWithIdentifier("detailViewController") as? UIViewController
//                
//            {
//                self.showViewController(vc, sender: self)
//                
//            }
//        }
//    }
//    
//    
//    
}
