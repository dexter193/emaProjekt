//
//  RezepteListeViewController.swift
//  tracka
//
//  Created by David Michel on 06.12.18.
//  Copyright © 2018 David Michel. All rights reserved.
//
import SQLite3

import UIKit

class RezepteListeViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("entryDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, instructions TEXT, difficulty INTEGER, url TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        readValues()
    }
    
    
    // MARK : PROPERTIES
    var db: OpaquePointer?
    @IBOutlet weak var FoodNameTextField: UITextField!
    var entryList = [Entry]()
    @IBOutlet weak var tableViewFood: UITableView!
    var selectedTest = 0
    // MARK : ACTIONS
    
    
    // MARK : TABLE VIEW ACTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this method is giving the row count of table view which is
        //total number of heroes in the list
        return entryList.count
    }
    
    // MARK: SEGUE ACTIONS
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "showEntrySegue"){
        let secondViewController = segue.destination as! ShowEntryViewController
        print(selectedTest.description)
        // set a variable in the second view controller with the data to pass
        secondViewController.test2 = selectedTest
        }
        
        
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("69")
        // Segue to the second view controller
        selectedTest = entryList[indexPath.row].id
        self.performSegue(withIdentifier: "showEntrySegue", sender: self)
        print("73")
        print(selectedTest.description)
    }
    
    
    
    //this method is binding the hero name with the tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let entryHelp: Entry
        entryHelp = entryList[indexPath.row]
        cell.textLabel?.text = entryHelp.name
        return cell
    }
    
    

    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let selected = entryList[indexPath.row].id
            let deleteString = "DELETE FROM Recipes WHERE id = \(selected)"
            
            
            var stamt: OpaquePointer?
            if sqlite3_prepare(db, deleteString, -1, &stamt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            print("36")
            if sqlite3_step(stamt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting Task: \(errmsg)")
                return
            }
            readValues()
        }
        
    }
    
    @IBAction func deleteList(_ sender: UIButton) {
        //the insert query
        let deleteString = "DELETE FROM Recipes"
    
        var stamt: OpaquePointer?
        print("29")
        //preparing the query
        if sqlite3_prepare(db, deleteString, -1, &stamt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        print("36")
        if sqlite3_step(stamt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Task: \(errmsg)")
            return
        }
        readValues()
    }
    
    func readValues(){
        
        //first empty the list of heroes
        entryList.removeAll()
        print("110")
        //this is our select query
        let queryString = "SELECT * FROM Recipes"
        
        
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        print("123")
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let description = String(cString: sqlite3_column_text(stmt, 2))
            let instructions = String(cString: sqlite3_column_text(stmt, 3))
            let difficulty = sqlite3_column_int(stmt, 4)
            let url = String(cString: sqlite3_column_text(stmt, 5))
            print(id)
            print(name)
            print(description)
            //adding values to list
            entryList.append(Entry(id: Int(id), name: String(describing:  name), description: String(describing:  description), instructions: String(describing:  instructions), difficulty: Int(difficulty), url: String(describing:  url)))
        }
        self.tableViewFood.reloadData()
        print("readValues success")
        
        
    }
    
    
    
    @IBAction func saveEntry(_ sender: UIButton) {
        readValues()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
