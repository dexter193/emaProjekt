//
//  ViewController.swift
//  tracka
//
//  Created by David Michel on 03.12.18.
//  Copyright © 2018 David Michel. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        
        // Do any additional setup after loading the view.
    }
    func assignbackground(){
        let background = UIImage(named: "background_main")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    
    // MARK: PROPERTIES
    
    var counter = 0
    
    
    // MARK : ACTIONS
    
    

    @IBAction func counterAction(_ sender: UIButton) {
        counter += 1
        
        sender.setTitle(String(counter), for: UIControl.State.normal)
    }
    
    // MARK: NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ShowCounterSegue"
        {
            if let destinationVC = segue.destination as? OtherViewController {
                destinationVC.numberToDisplay = counter
            }
        }
    }
    
}

