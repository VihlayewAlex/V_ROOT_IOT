//
//  myTableViewController.swift
//  V_ROOT_IOT
//
//  Created by Andrew on 2/17/18.
//  Copyright © 2018 Alex Vihlayew. All rights reserved.
//

import UIKit

class myTableViewController: UITableViewController {

    
    // MARK: - Properties
    
    var visits = [Visit]()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APIService.shared
            .getVisits()
            .then(execute: { [weak self] (visits) -> Void in
                self?.visits = visits
                self?.tableView.reloadData()
            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.barStyle = UIBarStyle.black
        navigationBar?.tintColor = UIColor.white
        
        // let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        // imageView.contentMode = .scaleAspectFit
        
        // let image = UIImage(named: "icon")
        // imageView.image = image
        
        // navigationItem.titleView = imageView
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let ratationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = ratationTransform
        UIView.animate(withDuration: 1.0, animations: {cell.layer.transform = CATransform3DIdentity})
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTableViewCell
        cell.cellImage?.image = visits[indexPath.row].photos.first
        cell.cellLabel?.text = visits[indexPath.row].date.stringRepresentation()
        
        cell.cellImage?.layer.cornerRadius = 30.0
        cell.cellImage?.clipsToBounds = true
        
        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue"{
            if let indexPath = tableView.indexPathForSelectedRow,
                let destinationController = segue.destination as? ViewController {
                
                destinationController.visit = visits[indexPath.row]
            }
        }
        
    }

}
