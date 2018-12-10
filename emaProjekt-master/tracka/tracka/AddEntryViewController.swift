//
//  AddEntryViewController.swift
//  tracka
//
//  Created by David Michel on 07.12.18.
//  Copyright © 2018 David Michel. All rights reserved.
//
import SQLite3
import UIKit

class AddEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
        
        print("values read in")
    }
    
    
    // MARK : PROPERTIES
    var db: OpaquePointer?
    @IBOutlet weak var FoodNameTextField: UITextField!
    @IBOutlet weak var IngredientsTextField: UITextField!
    @IBOutlet weak var TimeTextField: UITextField!
    @IBOutlet weak var DescriptionTextField: UITextField!
    @IBOutlet weak var InstructionsTextField: UITextField!
    @IBOutlet weak var DifficultyTextField: UITextField!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var ratingChosen: RatingController!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var debugImage: UIImageView!
    
    
    
    // MARK : UIImagePickerControllerDelegates
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        var path = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        print(path)
        
    }
    
    // MARK : ACTIONS
    
    
    
    @IBAction func pickPhotoFromLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func saveEntry(_ sender: UIButton) {
        
        //getting values from textfields
        //        let kategorie = textFieldKategorie.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let foodName = FoodNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = DescriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let instructions = InstructionsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let difficulty = ratingChosen.rating
//        let difficulty = DifficultyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let url = URLTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(difficulty)
        
        print("Zeile 31")
        //        if(kategorie?.isEmpty)!{
        //            textFieldKategorie.layer.borderColor = UIColor.red.cgColor
        //            return
        //        }
        
        
        //CHECK IF INPUT IS GIVEN IN TEXTFIELDS
        if(foodName?.isEmpty)!{
            FoodNameTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if(description?.isEmpty)!{
            DescriptionTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if(instructions?.isEmpty)!{
            InstructionsTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
//        if(difficulty?.isEmpty)!{
//            DifficultyTextField.layer.borderColor = UIColor.red.cgColor
//            return
//        }
        if(url?.isEmpty)!{
            URLTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        print("42")
        //creating a statement
        var stmt: OpaquePointer?
        let foodNameCast = FoodNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptionCast = DescriptionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let instructionsCast = InstructionsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let difficultyCast = DifficultyTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let urlCast = URLTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //the insert query
        
        let queryString = "INSERT INTO Recipes (name, description, instructions, difficulty, url) VALUES ('\(foodNameCast)', '\(descriptionCast)', '\(instructionsCast)', '\(difficulty)', '\(urlCast)')"
        
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        print("55")
        //binding the parameters
//        if sqlite3_bind_text(stmt, 1, foodName, -1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding Name: \(errmsg)")
//
//        }
//        if sqlite3_bind_text(stmt, 2, description, -1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding Description: \(errmsg)")
//
//        }
//        if sqlite3_bind_text(stmt, 3, instructions, -1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding Instructions: \(errmsg)")
//
//        }
//        if sqlite3_bind_int(stmt, 4, (difficulty! as NSString).intValue) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding Difficulty: \(errmsg)")
//
//        }
//        if sqlite3_bind_text(stmt, 5, url, -1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure binding URL: \(errmsg)")
//            return
//        }
        
        
        
        print("68")
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Task: \(errmsg)")
            return
        }
        print("74")
        //emptying the textfields
        print(description)
        FoodNameTextField.text=""
        DescriptionTextField.text=""
        InstructionsTextField.text=""
        DifficultyTextField.text=""
        URLTextField.text=""
        
        
        //displaying a success message
        print("Food saved successfully")
        
    }
    

}
