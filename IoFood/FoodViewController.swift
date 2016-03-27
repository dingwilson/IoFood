//
//  FoodViewController.swift
//  IoFood
//
//  Created by Wilson Ding on 3/26/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import Firebase

class FoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var foodTableView: UITableView!
    
    let firebaseRef = Firebase(url:"https://iofood.firebaseio.com/Items")
    
    var foodArray = Array<Food>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        
        self.foodTableView.reloadData()

        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.getData()
            dispatch_async(dispatch_get_main_queue()) {
                self.foodTableView.reloadData()
            }
        }*/
    }
    
    func getData() {
        firebaseRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let name = snapshot.value["name"] as! String
            let count = snapshot.value["count"] as! Int
            let imageURL = snapshot.value["imageURL"] as! String
            
            let food = Food(name: name, count: count, imageURL: imageURL)
            
            self.foodArray.append(food)
            
            self.foodTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.foodTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FoodTableViewCell
        
        let foodItem = foodArray[indexPath.row]
        
        cell.name.text = "\(foodItem.name())"
        
        cell.count.text = "Count: \(foodItem.count())"
        
        let url = NSURL(string:"\(foodItem.imageURL())")

        let data = NSData(contentsOfURL:url!)

        if data != nil {
            cell.photo.image = UIImage(data:data!)
        }

        return cell
     }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
