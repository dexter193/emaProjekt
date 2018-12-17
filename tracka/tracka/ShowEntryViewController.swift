//
//  ShowEntryViewController.swift
//  tracka
//
//  Created by David Michel on 07.12.18.
//  Copyright © 2018 David Michel. All rights reserved.
//

import SQLite3
import UIKit

class ShowEntryViewController: UIViewController {

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
        updateValues()

        // Do any additional setup after loading the view.
        
    }
    
    // MARK : PROPERTIES
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var ratingFood: RatingController!
    
    
    var test2 = 0
    var db: OpaquePointer?
    var test = ""
    
    
        
        
        
    
    
    // MARK: ACTIONS+
    
    func updateValues(){
        //this is our select query
        print(test2)
        let queryString = "SELECT * FROM Recipes WHERE ID = '\(test2)'"
        
        
        
        
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
            nameLabel.text = String(cString: sqlite3_column_text(stmt, 1))
            descriptionLabel.text = String(cString: sqlite3_column_text(stmt, 2))
            instructionsLabel.text = String(cString: sqlite3_column_text(stmt, 3))
            ratingFood.rating = Int((sqlite3_column_int(stmt, 4)))
            urlLabel.text = String(cString: sqlite3_column_text(stmt, 5))
            print(description)
            //adding values to list
        }
        print("readValues success")
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
