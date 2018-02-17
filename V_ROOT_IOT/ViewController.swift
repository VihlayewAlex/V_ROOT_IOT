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
    var secImage = ""
    var secLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        secondImage?.image = UIImage(named:secImage)
        secondLabel?.text = secLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

