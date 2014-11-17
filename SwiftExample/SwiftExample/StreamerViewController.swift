//
//  StreamerViewController.swift
//  SwiftExample
//
//  Created by Jeffrey Wescott on 11/17/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

import UIKit

class StreamerViewController: CinePlayerViewController {
    @IBOutlet weak var playButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.hidden = false
        playButton.enabled = true
        
        //-- cine.io setup
        
        // read our cine.io configuration from a plist bundle
        let path:NSString = NSBundle.mainBundle().pathForResource("cineio-settings", ofType: "plist")!
        let settings:NSDictionary = NSDictionary(contentsOfFile: path)!
        NSLog("settings: %@", settings)
        
        // create a new CineClient to fetch our stream information
        var cine = CineClient()
        cine.projectSecretKey = settings["CINE_IO_PROJECT_SECRET_KEY"] as String!
        cine.getStream(settings["CINE_IO_STREAM_ID"] as String!, withCompletionHandler: { (error: NSError!, stream: CineStream!) -> Void in
            if (error != nil) {
                let alert:UIAlertView = UIAlertView(title: "Network error", message: "Couldn't get stream settings from cine.io", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            } else {
                self.stream = stream
            }
        })
    }
    
    @IBAction func playButtonPressed(sender:AnyObject!) {
        playButton.enabled = false
        playButton.hidden = true
        UIApplication.sharedApplication().idleTimerDisabled = true
        self.startStreaming()
    }
    
    override func finishStreaming() {
        UIApplication.sharedApplication().idleTimerDisabled = false
        playButton.hidden = false
        playButton.enabled = true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
}
