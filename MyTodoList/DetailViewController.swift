//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by Paco Guevara on 15/09/15.
//  Copyright (c) 2015 Paco Guevara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var item: TodoItem?
    var todoList: TodoList?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        print("Item: \(item)")
        showItem()
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.addTarget(self, action: "toggleDatePicker")
        self.dateLabel.addGestureRecognizer(tapGestureRecognizer)
        self.dateLabel.userInteractionEnabled = true
    }
    
    func showItem(){
        self.descriptionLabel.text = item?.todo
        if let date = item?.dueDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            self.dateLabel.text = formatter.stringFromDate(date)
        }
        if let img = item?.image {
            self.imageView.image = img
        }
    }
    
    func toggleDatePicker(){
        self.imageView.hidden = self.datePicker.hidden
        self.datePicker.hidden = !self.datePicker.hidden
    }

    @IBAction func dateSelected(sender: UIDatePicker) {
        self.dateLabel.text = formatDate(sender.date)
        toggleDatePicker()
    }
    
    @IBAction func addNotification(sender: UIBarButtonItem) {
        if let dateString = self.dateLabel.text{
            if let date = parseDate(dateString){
                self.item?.dueDate = date
                self.todoList?.saveItems()
                scheduleNotification(self.item!.todo!, date: date)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func addImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func scheduleNotification(message: String, date: NSDate){
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertBody = message
        localNotification.alertTitle = "Recuerda esta tarea: "
        localNotification.applicationIconBadgeNumber = 1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func formatDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.stringFromDate(date)
    }
    
    func parseDate(string: String) -> NSDate? {
        let parser = NSDateFormatter()
        parser.dateFormat = "dd/MM/yyyy HH:mm"
        return parser.dateFromString(string)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Image Picker Controller methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.item?.image = image
            self.todoList?.saveItems()
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
