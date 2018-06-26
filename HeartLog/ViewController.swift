//
//  ViewController.swift
//  HeartLog
//
//  Created by Marko Stajic on 6/26/18.
//  Copyright © 2018 markostajic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var jsonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DataService.getPostWithId(id: 1) { (post, errorMessage) in
            if let post = post {
                print("Post: \(post.toJsonString())")
                self.jsonLabel.text = post.toJsonString()
            } else {
                print("Error: \(errorMessage)")
                self.jsonLabel.text = errorMessage
            }
        }
    }

}

