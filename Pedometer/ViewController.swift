//
//  ViewController.swift
//  Pedometer
//
//  Created by Desai, Rikin on 2/24/15.
//  Copyright (c) 2015 Desai, Rikin. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var stepLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //StepManager.sharedInstance.ste
        StepManager.sharedInstance.addObserver(self, forKeyPath: "stepsToday", options: .New | .Initial, context: nil)
        StepManager.sharedInstance.startCounting()
    }

    deinit{
        StepManager.sharedInstance.removeObserver(self, forKeyPath: "stepsToday")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "stepsToday" {
            if StepManager.sharedInstance.isUpdating{
                updateUI(StepManager.sharedInstance.stepsToday)
            }else{
                updateUI(nil)
            }
        }
    }

    func updateUI(stepCount: Int?){
        
        let message = stepCount.map { toString($0)} ?? "_ _ _"
        dispatch_async(dispatch_get_main_queue(), {
            self.stepLabel.text = message
        })
    }
    
    
    
    
    
}

