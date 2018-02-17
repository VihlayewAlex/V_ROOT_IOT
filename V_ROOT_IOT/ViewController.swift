//
//  ViewController.swift
//  V_ROOT_IOT
//
//  Created by Alex Vihlayew on 2/17/18.
//  Copyright © 2018 Alex Vihlayew. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    
    var visit: Visit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondImage?.image = visit?.photos.first
        secondLabel?.text = visit?.date.stringRepresentation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

