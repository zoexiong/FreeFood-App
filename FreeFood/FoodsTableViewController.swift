//  FoodsTableViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/11/27.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase


var foodDict=[String:Food]()

class Food {
    var foodName:String
    var foodImage:UIImage?
    var eventsIndex:[Int]
    init(foodName:String, foodImage:UIImage?, eventsIndex:[Int]){
        self.foodImage=foodImage
        self.foodName=foodName
        self.eventsIndex = eventsIndex
    }
}

//let cookie = Food(foodName:"cookie",foodImage:#imageLiteral(resourceName: "Cookie"),eventsIndex:[])

class FoodsTableViewController: UITableViewController {
    
    var events2 = [FIRDataSnapshot]()
    var foods=[Food]()
    var dateFormatter = DateFormatter()
    
    var refresher: UIRefreshControl!
    var ref: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    
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
            self.loadData()
            self.tableView.reloadData()
            print("finally loaded")
        }
        print("Size of list =")
        print(self.events2.count)
        
    }
    
    func loadData() {
        events.events=[]
        let zipcode = userDefault.string(forKey: "zipcode")!
        
        
        
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        
        let current_date: NSDate = NSDate()
        
        //var i=0
        for i in events2{
            
            
            let eventSnapshot : FIRDataSnapshot! = i
            var event = eventSnapshot.value as! [String:String]
            
            let given_end_time = event[Constants.Event2.eventEndTime]!
            //print(given_end_time)
            
            
            let given_date = event[Constants.Event2.eventDate]!
            
            //dateFormatter.date(from: event[Constants.Event2.eventDate]!)
            
            let end = given_date+" "+given_end_time
            
            //print(end)
            
            
            //let this_date = dateFormatter.date(from: end)
            //this_date?.addingTimeInterval(-28800)
            //print(dateFormatter.date(from: end)!)
            
            let compareResult = current_date.compare(dateFormatter.date(from: end)! as Date)
            
            if event[Constants.Event2.eventZipcode]! == zipcode && compareResult == ComparisonResult.orderedAscending{
                
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
                events.events.append(newEvent)
                //i=i+1
            }
        }
        
        getFoodList()
        print(foodDict.count)
    }
    
    func getFoodList(){
        var i=0
        foodDict=[String:Food]()
        foods=[Food]()
        for event in events.events{
            let foods = event.eventFoods
            let foodsNoSpace = foods.replacingOccurrences(of: " ", with: "")
            let foodArray = foodsNoSpace.characters.split{$0 == ","}.map(String.init)
            for food in foodArray{
                if foodDict[food]==nil{
                    foodDict[food]=Food(foodName:food,foodImage:nil,eventsIndex:[i])
                }else{
                    //foodDict[food]?.eventsIndex.append(i)
                }
            }
            i=i+1
        }
        for (_,foodItem) in foodDict{
            foods.append(foodItem)
        }
    }
    
    override func viewDidLoad() {
        configureDataBase()
        
        self.loadData()
        
        //when user click eventsView(not entering from food to events map), set the filter to false and load all the events
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        
        refresher.addTarget(self, action: #selector(FoodsTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        //self.tableView.contentInset = UIEdgeInsetsMake(66,0,0,0)
        
        //refresh()
        //print("Hulle")
        
        //self.loadData()
        self.tableView.reloadData()
        refresher.endRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FoodsTableViewController.refresh), name:NSNotification.Name(rawValue: "NotificationIdentifier2"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh() {
        
        //configureDataBase()
        loadData()
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
        return foods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodTableViewCell
        let food = foods[indexPath.row]
        switch(food.foodName){
        case "Assorted Dessert":
            food.foodImage = #imageLiteral(resourceName: "Assorted Dessert")
        case "Barbeque":
            food.foodImage = #imageLiteral(resourceName: "Barbeque")
        case "Bread":
            food.foodImage = #imageLiteral(resourceName: "Bread")
        case "Burger":
            food.foodImage = #imageLiteral(resourceName: "Burger")
        case "Cake":
            food.foodImage = #imageLiteral(resourceName: "Cake")
        case "Coffee":
            food.foodImage = #imageLiteral(resourceName: "Coffee")
        case "Coke":
            food.foodImage = #imageLiteral(resourceName: "Coke")
        case "Cookie":
            food.foodImage = #imageLiteral(resourceName: "Cookie")
        case "Fries":
            food.foodImage = #imageLiteral(resourceName: "Fries")
        case "Fruit":
            food.foodImage = #imageLiteral(resourceName: "Fruit")
        case "Hotdog":
            food.foodImage = #imageLiteral(resourceName: "Hotdog")
        case "Ice Cream":
            food.foodImage = #imageLiteral(resourceName: "Ice Cream")
        case "Juice":
            food.foodImage = #imageLiteral(resourceName: "Juice")
        case "Muffin":
            food.foodImage = #imageLiteral(resourceName: "Muffin")
        case "Pasta":
            food.foodImage = #imageLiteral(resourceName: "Pasta")
        case "Pastry":
            food.foodImage = #imageLiteral(resourceName: "Pastry")
        case "Pie":
            food.foodImage = #imageLiteral(resourceName: "Pie")
        case "Pizza":
            food.foodImage = #imageLiteral(resourceName: "Pizza")
        case "Rice":
            food.foodImage = #imageLiteral(resourceName: "Rice")
        case "Salad":
            food.foodImage = #imageLiteral(resourceName: "Salad")
        case "Sandwich":
            food.foodImage = #imageLiteral(resourceName: "Sandwich")
        case "Taco":
            food.foodImage = #imageLiteral(resourceName: "Taco")
        default:
            food.foodImage = #imageLiteral(resourceName: "Defaultfood")
            
        }
        cell.foodImage.image = food.foodImage
        cell.foodName.text = food.foodName
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "foodToEvents",
            let destination = segue.destination as? EventsTableViewController,
            let foodIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.foodName = foods[foodIndex].foodName
            destination.filter = true
        }
        
        /*
         print(eventSelected.eventName)
         
         viewController.eventSelected = self.eventSelected
         */
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}


