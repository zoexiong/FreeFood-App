
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
    
    var eventSelected : Event = Event()
    var events = [Event]()
    
    var refresher: UIRefreshControl!
    var events2 = [FIRDataSnapshot]()

    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!

    override func viewDidLoad() {
        configureDataBase()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        //self.tableView.reloadData()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refresher.addTarget(self, action: #selector(FoodsTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        super.viewDidLoad()
       
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
            
            /*
             print("Item goes here -")
             //print(snapshot.value(forKey: "Event"))
             print(snapshot.children.allObjects)
             */

 
        }
        /*
        print("Size of list =")
        print(self.events2.count)
 */
    }
    
    func refresh() {
        // clears previous events 
        // searches for new events from the same link (JSON File, which could have been updated)
        //events = [Event]()
        //loadData()
        //self.events2 = []
        //configureDataBase()
        self.tableView.reloadData()
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
        return events2.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you selected \(indexPath.row)")
        let temp: FIRDataSnapshot = events2[indexPath.row]
        /*
        print("check this")
        print(temp)
        */
        //eventSelected = events2[indexPath.row]
        performSegue(withIdentifier: "DetailsVC", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        
        //print("See this")
        for singleEvent in events2{
            let eventSnapshot : FIRDataSnapshot! = events2[indexPath.row]
            var event = eventSnapshot.value as! [String:String]
            
            var newEvent = Event()
            
            newEvent.eventName = event[Constants.Event2.eventName] ?? "[name]"
            newEvent.eventLocation = event[Constants.Event2.eventLocation] ?? "[text]"
            newEvent.eventStartTime = event[Constants.Event2.eventStartTime] ?? "[text]"
            newEvent.eventEndTime = event[Constants.Event2.eventEndTime] ?? "[text]"
            newEvent.eventDate = event[Constants.Event2.eventDate] ?? "[text]"
            newEvent.eventFoods = event[Constants.Event2.eventFoods] ?? "[text]"
            newEvent.eventUrl = event[Constants.Event2.eventUrl] ?? "[text]"
            newEvent.eventZipcode = event[Constants.Event2.eventZipcode] ?? "[text]"
            newEvent.eventDescription = event[Constants.Event2.eventDescription] ?? "[text]"
            
            events.append(newEvent)
        }
        /*
         foods = foods.replacingOccurrences(of: ",", with: ", ", options: .literal, range: nil)
         */
        let event = events[indexPath.row]
        cell.eventName.text = event.eventName
        cell.eventLocation.text = event.eventLocation
        //看这里看这里
        //cell.eventDate.text = date
        cell.eventTime.text = event.eventStartTime+" to "+event.eventEndTime
        cell.eventFoods.text = event.eventFoods

        
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
        if segue.identifier == "DetailsVC" {
            let viewController = segue.destination as! EventDetailViewController
            
            // eventSelected = events[IndexPath]
            
            /*
            print(eventSelected.eventName)
            
            viewController.eventSelected = self.eventSelected
                */
        }
    }
}
