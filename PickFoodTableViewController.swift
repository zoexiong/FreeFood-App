
//
//  PickFoodTableViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/11/28.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class PickFoodTableViewController: UITableViewController {
    
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            if selected.items != []{
                for index in selected.items{
                    //print("selected:",index)
                    self.tableView.selectRow(at: [0,index], animated: true, scrollPosition:UITableViewScrollPosition.bottom)
                }
            }
            return
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func save(_ sender: Any) {
        //add selected items to selected.items
        setSelectedItems()
        //dismiss won't lead to view reload, but we need to reload view to refresh the post event table, so this is added to call the do_table_refresh() function inside postEventTableViewController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        self.dismiss(animated: true, completion: {})
    }
    
    
    @IBAction func addNewFood(_ sender: Any) {
        setSelectedItems()
        let alertController = UIAlertController(title: "Add New Food", message: "Please enter new food name.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("Canceld")
        }
        let okAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { (action: UIAlertAction!) -> Void in
            let newItem = (alertController.textFields?.first)! as UITextField
            foodList.list.append(newItem.text!)
            selected.items.append(foodList.list.count-1)
            print("Saved")
            print("new item:",newItem.text!)
            self.do_table_refresh()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addTextField { (newFoodTextField) -> Void in
            newFoodTextField.placeholder = "Input here..."
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        
        //create a reuseable cell for each food item displayed in the food list
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        
        // if already selected some food items, show them in the tableView
        if selected.items != []{
            for index in selected.items{
                print("selected:",index)
                self.tableView.selectRow(at: [0,index], animated: true, scrollPosition:UITableViewScrollPosition.none)
                //print(tableView.indexPathsForSelectedRows ?? [])
            }
        }
        navigationController?.setToolbarHidden(false, animated: false)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return foodList.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = foodList.list[indexPath.row]
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 168, green: 227, blue: 255)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func setSelectedItems(){
        let indexes = tableView.indexPathsForSelectedRows
        //clear history and then save
        selected.items = []
        if indexes != nil{
            for index in indexes! {
                selected.items.append(index[1])
            }
            print(selected.items)
        }
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

