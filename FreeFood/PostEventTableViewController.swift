//
//  PostEventTableViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/11/28.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit
import Firebase

var foodItems = [String]()

//hide keyboard when tap elsewhere
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


class PostEventTableViewController: UITableViewController {
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    @IBOutlet weak var endPickerTextField: UITextField!
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var eventZipcode: UITextField!
    
    @IBOutlet weak var eventURL: UITextField!
    
    @IBOutlet weak var eventDescription: UITextField!
    
    var ref: FIRDatabaseReference!
    var dateFormatter = DateFormatter()
    var startDate: String=""
    var endDate: String=""
    var pickerView = UIDatePicker()
    var endPickerView = UIDatePicker()
    
    //var foodItems = [Food]() // of a particular event added by host

    func submitFailedAlert(){
        alert(message: "You must fill all the required fields (indicated by *) to post the event", "submission failed")
    }
    
    @IBAction func pickDateAction(_ sender: Any) {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        startDate = dateFormatter.string(from: pickerView.date)
        pickerTextField.text = startDate
    }
    
    @IBAction func endPickDateAction(_ sender: Any) {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        endDate = dateFormatter.string(from: endPickerView.date)
        endPickerTextField.text = endDate
    }

    
    //add alert
    func alert(message: String, _ submitLog:String){
        let alertController:UIAlertController = {
            return UIAlertController(title: "Submit", message: message, preferredStyle: UIAlertControllerStyle.alert)
        }()
        
        let okAlert:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (alert: UIAlertAction!) -> Void in
            self.do_table_refresh()
            NSLog(submitLog)}
        alertController.addAction(okAlert)
        self.present(alertController, animated: true, completion: nil);
    }
    
    func submitSuccessful(){
        alert(message: "submit successful", "submitted!")
    }
    
    //submit alert
    func submitAlert(message: String, _ submitLog:String){
        let alertController:UIAlertController = {
            return UIAlertController(title: "Submit", message: message, preferredStyle: UIAlertControllerStyle.alert)
        }()
        
        let okAlert:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alert: UIAlertAction!) -> Void in
            
            for foodIndex in selected.items{
                foodItems.append(foodList.list[foodIndex])
            }
            
            //submit success alert and back to main screen
            let data =  [Constants.Event2.eventName: self.eventName.text! as String]
            self.storeInDB(data: data)
            self.eventName.resignFirstResponder()
            
            self.submitSuccessful()
            
            self.eventName.text! = ""
            self.pickerTextField.text! = ""
            self.endPickerTextField.text! = ""
            self.pickerView = UIDatePicker()
            self.endPickerView = UIDatePicker()
            self.eventLocation.text! = ""
            self.eventZipcode.text! = ""
            self.eventURL.text! = ""
            self.eventDescription.text! = ""
            foodItems = []
            selected.items = []
            self.startDate = ""
            self.endDate = ""
            self.do_table_refresh()

            NSLog(submitLog)}
        
        let cancelAlert:UIAlertAction = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel) { (alert: UIAlertAction!) -> Void in
        }
        
        alertController.addAction(okAlert)
        alertController.addAction(cancelAlert)
        self.present(alertController, animated: true, completion: nil);
    }
    
    open func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            return
        })
    }
    
    func storeInDB(data: [String: String]) {
        var copyData = data
        
        if !eventLocation.text!.isEmpty {
            copyData[Constants.Event2.eventLocation] = eventLocation.text! as String
        } else {
            let alertController = UIAlertController(title: "Required Section", message: "Location is a required field", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        if !eventZipcode.text!.isEmpty {
            copyData[Constants.Event2.eventZipcode] = eventZipcode.text! as String
        } /*else {
         // create an alert - > Reqd field
         let alertController = UIAlertController(title: "Required Section", message: "Zipcode is a required field", preferredStyle: UIAlertControllerStyle.alert)
         alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
         }*/
        
        if !eventDescription.text!.isEmpty {
            copyData[Constants.Event2.eventDescription] = eventDescription.text! as String
        }
        
        if !eventURL.text!.isEmpty {
            copyData[Constants.Event2.eventUrl] = eventURL.text! as String
        }
        
        let start_time_text = pickerTextField.text! as String
        
        if !start_time_text.isEmpty {
            
            
            let index_date = start_time_text.index(start_time_text.startIndex, offsetBy: 10)
            
            let index_start_time = start_time_text.index(start_time_text.startIndex, offsetBy: 11)
            
            
            copyData[Constants.Event2.eventDate] = start_time_text.substring(to: index_date)
            
            copyData[Constants.Event2.eventStartTime] = start_time_text.substring(from: index_start_time)
        }
        
        let end_time_text = endPickerTextField.text! as String
        
        if !end_time_text.isEmpty {
            
            
            let index_end_time = end_time_text.index(end_time_text.startIndex, offsetBy: 11)
            
            //let end_time = endTend_time_textim.substring(from: index_end_time)  // playground
            //print(end_time)
            
            
            copyData[Constants.Event2.eventEndTime] = end_time_text.substring(from: index_end_time)
        }
        
        if foodItems.count>0 {
            var foods = ""
            
            for food in foodItems{
                foods += food
                foods += ", "
            }
            
            
            //let name: String = "Dolphin"
            let range = foods.index(foods.endIndex, offsetBy: -2)..<foods.endIndex
            foods.removeSubrange(range)
            
            /*
             let index_foods = foods.index(foods.startIndex, offsetBy: 2)
             
             foods = foods.substring(from: index_foods)
             */
            //foods.remove(at: foods.index(before: foods.endIndex))
            //foods = foods.replacingOccurrences(of: ",", with: ", ", options: .literal, range: nil)
            copyData[Constants.Event2.eventFoods] = foods
        }
        
        
        ref.child("Events").childByAutoId().setValue(copyData)
    }
    
    @IBAction func submitEvent(_ sender: Any) {
        
        
        if !eventName.text!.isEmpty {
            //get the values in form and construct JSON
            let name = eventName.text!
            let location = eventLocation.text!
            let zipcode = eventZipcode.text!
            let startTime = pickerTextField.text!
            let endTime = pickerTextField.text!
            let compareResult = pickerView.date.compare(endPickerView.date as Date)

            //let url = eventURL.text!
            //let description = eventDescription.text!
            //test if user completed required fields
            if name != "" && startTime != "" && endTime != "" && location != "" && zipcode != "" {
                if selected.items.count >= 1 {
                    if compareResult == ComparisonResult.orderedAscending {
                        //print("\(startTime) is earlier than \(endTime)")
                        
                        //double check if they want to submit
                        
                   submitAlert(message: "Are you sure all the information is correct and you want to submit now?", "Submit")
                   
                    }else{
                    alert(message: "The end time must be later than start time", "submit failed")
                    }
                } else{
                    alert(message: "You must enter at least one food item to post the event", "submit failed")
                }
            }
            else{
                submitFailedAlert()
            }
        }else{
            alert(message: "Please enter event name","submit failed")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a reuseable cell for each food item displayed in the food list
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "foodItemCell")
        //remove additional unecessary cells
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        //set up text color
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = UIColor.gray
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .font = UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)
        //set up date picker for the event time text field
        pickerView = UIDatePicker()
        //prevent the user from choosing a past date
        pickerView.minimumDate = NSDate() as Date
        endPickerView = UIDatePicker()
        //prevent the user from choosing a past date
        endPickerView.minimumDate = NSDate() as Date
        pickerTextField.inputView = pickerView
        endPickerTextField.inputView = endPickerView
        
        //        eventZipcode.returnKeyType = .next
        //        eventURL.returnKeyType = .next
        //        eventLocation.returnKeyType = .next
        //        self.eventLocation.nextField = self.eventZipcode
        //        self.eventZipcode.nextField = self.eventURL
        //        self.eventURL.nextField = self.eventDescription
        
        eventName.clearButtonMode = .whileEditing
        eventZipcode.clearButtonMode = .whileEditing
        eventURL.clearButtonMode = .whileEditing
        eventLocation.clearButtonMode = .whileEditing
        eventDescription.clearButtonMode = .whileEditing
        do_table_refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(PostEventTableViewController.updateTable), name:NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
        //add toolbar 'done' to date picker, so when we trigger date picker we can tap 'done' button to dismiss picker
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.dismissKeyboard))
        
        //hide keyboard when tap elsewhere
        self.hideKeyboardWhenTappedAround()
        toolbarDone.items = [doneButton] // we can even add cancel button too
        pickerTextField.inputAccessoryView = toolbarDone
        endPickerTextField.inputAccessoryView = toolbarDone

        // connecting to firebase databse
        ref = FIRDatabase.database().reference()
    }
    
  //prepared for the notificationCenter
    func updateTable() {
        do_table_refresh()
    }
    
    //2 sections in total
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //the 1st section has 6 rows for basic event info and 1 row to edit food items, the 2nd section (with index 1) has 1 row to dynamically populate multiple rows for a list of food items that the user adds
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            if section == 1 {
                return selected.items.count
            }else{
                return 8
            }
    }
    
    
    //cell set up
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            //only the 2nd section (with index 1) is dynamic
            if indexPath.section == 1 {
                //when it reaches the dynamic section, generate the reusable cell identified by "foodItemCell", which we init it at the beginning of this code file
                let cell = tableView.dequeueReusableCell(withIdentifier: "foodItemCell",for: indexPath)
                //disable cell selection highlight
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                //fetch the corresponding name of the food item and populate many rows
                cell.textLabel?.text = foodList.list[selected.items[indexPath.row]]
                //disable the selected row highlight
                return cell
            }else{ //for the 1st section (the more static one)
                //                let cellS = super.tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                //                cellS.selectionStyle = .none
                return super.tableView(tableView, cellForRowAt: indexPath)
            }
    }
    
    //set up the dynamic sectoin's row's height
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 44
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    //data source and delegate, dynamically insert new row when we get new data
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1{
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }else{
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    //    disable highlight for each row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class SelectedList {
    var items : [Int]
    init(_ items:[Int]){
        self.items = items
    }
}

var selected = SelectedList([])

class FoodList{
    var list: [String]
    init(_ list:[String]){
        self.list = list
    }
}

var foodList = FoodList(["Pizza","Cookie","Coke","Salad","Taco","Coffee","Rice","Fries","Burrito","Pasta","Juice","Muffin","Assorted Desserts","Barbeque","Bread","Burger","Cake","Donut","Fruit","Hotdog","Ice Cream","Pastry","Pie","Sandwich"])
