//
//  TodoList.swift
//  MyTodoList
//
//  Created by Paco Guevara on 24/08/15.
//  Copyright (c) 2015 Paco Guevara. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    var items: [TodoItem] = []
    
    override init() {
        super.init()
        loadItems()
    }
    
    private let fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print("path de documents \(documentDirectoryURL)")
        return documentDirectoryURL.URLByAppendingPathComponent("todolist.plist")
    }()
    
    func addItem(item: TodoItem){
        items.append(item)
        saveItems()
    }
    
    func saveItems(){
        let itemsArray = items as NSArray
        if NSKeyedArchiver.archiveRootObject(itemsArray, toFile: self.fileURL.path!){
            print("Guardado!")
        }else{
            print("No se pudo guardar")
        }
    }
    
    func loadItems(){
        if let itemsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(self.fileURL.path!) {
            self.items = itemsArray as! [TodoItem]
        }
    }
    
    func getItem(index: Int) -> TodoItem{
        return items[index]
    }
}

extension TodoList : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AnyObject = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel!!.text = item.todo
        return cell as! UITableViewCell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex(indexPath.row)
        saveItems()
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
        tableView.endUpdates()
    }
}
