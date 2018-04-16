//
//  MasterViewController.swift
//  Skycatch-Challenge
//
//  Created by Blake Barrett on 4/5/18.
//  Copyright © 2018 Blake Barrett. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData(_:)))
    
    var rows: [Row]?
    var movies: [String]?
    
    let reuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = nil

        navigationItem.rightBarButtonItem = refreshButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func refreshData(_ sender: Any) {
        fetch() // stop trying to make "fetch" happen ;p
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            DispatchQueue.main.async(execute: { () -> Void in
                self.prepare(controller: controller, with: (rows: self.rows!, movies: self.movies!))
            })
        }
    }
}

extension MasterViewController {
    
    func prepare(controller: DetailViewController, with data: SFGovAPIResponse) {
        if let indexPath = tableView.indexPathForSelectedRow {
            
            let movie = data.movies[indexPath.row]
            let movieLocations = data.rows.filter({
                $0.movieString == movie
            })
            
            controller.rows = movieLocations
        }
        
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
    }
    
}

extension MasterViewController {
    func fetch() {
        refreshButton.isEnabled = false
        SFGovAPI.fetch({[weak self] rows, movies in
            self?.rows = rows
            self?.movies = movies
            
            self?.tableView.reloadData()
            self?.refreshButton.isEnabled = true
        })
    }
}

extension MasterViewController {
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let loc = movies?[indexPath.row] {
            cell.textLabel?.text = loc
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
