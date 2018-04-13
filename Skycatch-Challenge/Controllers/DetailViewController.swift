//
//  DetailViewController.swift
//  Skycatch-Challenge
//
//  Created by Blake Barrett on 4/5/18.
//  Copyright © 2018 Blake Barrett. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionTextView: UITextView!
    
    var rows: [Row]? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let label = detailDescriptionTextView {
            var labelString = ""
            
            rows?.forEach({row in
                labelString += row.toString() + "\r\r"
            })
            
            label.text = labelString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
