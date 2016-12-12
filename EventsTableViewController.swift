
//
//  EventsTableViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/11/27.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
//test data goes here


var events = Events(events: [])
extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}

class EventsTableViewController: UITableViewController {
    
    var foodName : String = ""
    var filter: Bool = false
    
    var eventSelected : Event = Event()
    
    var dateFormatter = DateFormatter()
    
    
    var refresher: UIRefreshControl!
    var events2 = [FIRDataSnapshot]()
    
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        //self.tableView.reloadData()
        configureDataBase()
        self.tableView.reloadData()
        
        loadData()
        
        //when user click eventsView(not entering from food to events map), set the filter to false and load all the events
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refresher.addTarget(self, action: #selector(EventsTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        //self.tableView.contentInset = UIEdgeInsetsMake(66,0,0,0)
        
        //print("Hulle")
        
        //loadData()
        //self.tableView.reloadData()
        
        //self.loadData()
        
        refresher.endRefreshing()
        //super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(EventsTableViewController.turnOffFilter), name:NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func configureDataBase() {
        
        
        
        ref = FIRDatabase.database().reference()
        
        
        
        //print(ref.child("Events").observe(.childAdded))
        _refHandle = ref.child("Events").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            self.events2.append(snapshot)
            self.loadData()
            self.tableView.reloadData()
            
            
        }
    }
    
    func loadData() {
        
        let zipcode = userDefault.string(forKey: "zipcode")!
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        
        let current_date: NSDate = NSDate()//.addingTimeInterval(-28800)
        
        //let lol = NSDate().addingTimeInterval(-28800)
        
        
        
        /*
         print("Given date")
         print(current_date)
         */
        events.events=[]
        //var i=0
        for i in events2{
            let eventSnapshot : FIRDataSnapshot! = i
            var event = eventSnapshot.value as! [String:String]
            var filtered: Bool = false
            
            
            
            
            
            
            
            
            
            
            //let given_date = dateFormatter.string(from: event[Constants.Event2.eventDate]!)
            
            
            //print("Given end time")
            
            
            let given_end_time = event[Constants.Event2.eventEndTime]!
            //print(given_end_time)
            
            
            let given_date = event[Constants.Event2.eventDate]!
            
            //dateFormatter.date(from: event[Constants.Event2.eventDate]!)
            
            let end = given_date+" "+given_end_time
            
            //print(end)
            
            
            //let this_date = dateFormatter.date(from: end)
            //this_date?.addingTimeInterval(-28800)
            //print(dateFormatter.date(from: end)!)
            
            
            let new_event_date = dateFormatter.date(from: end)!
            
            let compareResult = current_date.compare(new_event_date as Date)
            
            //print(compareResult == ComparisonResult.orderedAscending)
            
            
            
            
            //print(NSDate(event[Constants.Event2.eventDate]))
            
            if event[Constants.Event2.eventZipcode]! == zipcode {
                if compareResult == ComparisonResult.orderedAscending{
                    if filter == true{
                        if event[Constants.Event2.eventFoods]!.range(of: foodName) != nil{
                            filtered = false
                        }else{
                            filtered = true
                        }
                    }
                    if filtered == false {
                        
                        
                        
                        //print(compareResult)
                        let newEvent = Event()
                        newEvent.eventName = event[Constants.Event2.eventName] ?? "[name]"
                        newEvent.eventLocation = event[Constants.Event2.eventLocation] ?? "[text]"
                        newEvent.eventStartTime = event[Constants.Event2.eventStartTime] ?? "[text]"
                        newEvent.eventEndTime = event[Constants.Event2.eventEndTime] ?? "[text]"
                        newEvent.eventDate = event[Constants.Event2.eventDate] ?? "[text]"
                        newEvent.eventFoods = event[Constants.Event2.eventFoods] ?? "[text]"
                        newEvent.eventUrl = event[Constants.Event2.eventUrl] ?? "[text]"
                        //newEvent.eventZipcode = event[Constants.Event2.eventZipcode] ?? "[text]"
                        newEvent.eventDescription = event[Constants.Event2.eventDescription] ?? "[text]"
                        
                        
                        var i: Int = 0
                        var inserted: Bool = false
                        
                        while i<events.events.count && inserted == false{
                            
                            let entry = events.events[i]
                            
                            
                            
                            //var i_date = events.events[i].
                            
                            
                            let entry_end_time = entry.eventEndTime
                            
                            let entry_given_date = entry.eventDate
                            
                            
                            let entry_end = entry_given_date+" "+entry_end_time
                            
                            
                            
                            //True if entry_end is bigger
                            let entry_compareResult = new_event_date.compare(dateFormatter.date(from: entry_end)! as Date)
                            
                            if entry_compareResult == ComparisonResult.orderedAscending{
                                //print("INSERTING! TYAY")
                                events.events.insert(newEvent, at: i)
                                
                                inserted = true
                                
                            }
                            else {
                                i += 1
                            }
                            
                        }
                        
                        if inserted == false {
                            events.events.append(newEvent)
                        }
                        
                        
                        
                        //events.events.append(newEvent)
                        
                        self.tableView.reloadData()
                    }
                    //i=i+1
                }
                else{
                    eventSnapshot.ref.removeValue()
                }
            }
        }
        
        //print("LET US SORT")
        //sort()
    }
    /*
     func sort(){
     
     
     var temp = events.events
     
     
     print("count of events is")
     
     print(events.events.count)
     
     //anArray.insert("This String", atIndex: 0)
     
     for item in events.events{
     var i: Int = 0
     
     
     }
     
     }
     */
    
    //turn off filter
    func turnOffFilter(){
        filter = false
        refresh()
    }
    
    func refresh() {
        // clears previous events
        // searches for new events from the same link (JSON File, which could have been updated)
        //        events = [Event]()
        //        self.events2 = []
        //        configureDataBase()
        self.tableView.reloadData()
        loadData()
        refresher.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.events.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("you selected \(indexPath.row)")
        
        /*
         print("YO CHECK THIS")
         print(events.events[indexPath.row].eventName)
         */
        
        // let temp: FIRDataSnapshot = events2[indexPath.row]
        /*
         print("check this")
         print(temp)
         */
        //eventSelected = events2[indexPath.row]
        
        
        //performSegue(withIdentifier: "DetailsVC", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        //print("See this")
        
        /*
         foods = foods.replacingOccurrences(of: ",", with: ", ", options: .literal, range: nil)
         */
        
        //print(indexPath.row)
        
        if indexPath.row<events.events.count{
            let event = events.events[indexPath.row]
            cell.eventName.text = event.eventName
            /*
             print("Check it out")
             print(event.eventName)
             */
            cell.eventLocation.text = event.eventLocation
            cell.eventDate.text = event.eventDate
            cell.eventTime.text = event.eventStartTime+" to "+event.eventEndTime
            cell.eventFoods.text = event.eventFoods
            
            
        }
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "DetailsVC",
            let destination = segue.destination as? EventDetailViewController,
            let eventIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.eventSelected = events.events[eventIndex]
        }
        
        /*
         print(eventSelected.eventName)
         
         viewController.eventSelected = self.eventSelected
         */
    }
}

