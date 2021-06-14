//
//  InterfaceController.swift
//  RunTrackrWatch Extension
//
//  Created by Mo Ahmad on 13/06/2021.
//  Copyright © 2021 Mohammed Ahmad. All rights reserved.
//

import WatchKit
import Foundation


final class InterfaceController: WKInterfaceController {

    @IBOutlet weak var startRunButton: WKInterfaceButton!

    @IBAction func didTapStartRunButton() {
        print("Run started!!!")
    }

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
