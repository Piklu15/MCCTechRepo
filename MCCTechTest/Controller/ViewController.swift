//
//  ViewController.swift
//  MCCTechTest
//
//  Created by Zert Interactive on 7/23/18.
//  Copyright © 2018 MCC. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadJsonData(_ sender: UIButton) {
        
        let photoGridController = self.storyboard?.instantiateViewController(withIdentifier: "photogrid") as! PhotoGridViewController
        self.navigationController?.pushViewController(photoGridController, animated: true)
    }
    
}



