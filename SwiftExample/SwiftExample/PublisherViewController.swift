//
//  PublisherViewController.swift
//  SwiftExample
//
//  Created by Jeffrey Wescott on 11/17/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

import UIKit

class PublisherViewController: CineBroadcasterViewController {

    override func viewDidLoad() {
        //-- A/V setup
        self.videoSize = CGSizeMake(720, 1280) // start in portrait mode to avoid shrinking video bug (https://github.com/jgh-/VideoCore/issues/84)
        self.framesPerSecond = 30
        self.videoBitRate = 1500000
        self.sampleRateInHz = 44100 // either 44100 or 22050
        
        // must be called _after_ we set up our properties, as our superclass
        // will use them in its viewDidLoad method
        super.viewDidLoad()
        
        //-- cine.io setup
        
        // read our cine.io configuration from a plist bundle
        let path:NSString = NSBundle.mainBundle().pathForResource("cineio-settings", ofType: "plist")!
        let settings:NSDictionary = NSDictionary(contentsOfFile: path)!
        NSLog("settings: %@", settings)
        
        // create a new CineClient to fetch our stream information
        var cine = CineClient()
        cine.projectSecretKey = settings["CINE_IO_PROJECT_SECRET_KEY"] as String!
        self.updateStatus("Configuring stream using cine.io ...")
        cine.getStream(settings["CINE_IO_STREAM_ID"] as String!, withCompletionHandler: { (error: NSError!, stream: CineStream!) -> Void in
            if (error != nil) {
                self.updateStatus("ERROR: couldn't get stream information from cine.io")
            } else {
                self.publishUrl = stream.publishUrl
                self.publishStreamName = stream.publishStreamName
                // once we've fully-configured our properties, we can enable the
                // UI controls on our view
                self.enableControls()
            }
        })
    }

    override func toggleStreaming(sender: AnyObject!) {
        
        switch(self.streamState) {
        case .None, .PreviewStarted, .Ended, .Error:
            UIApplication.sharedApplication().idleTimerDisabled = true
        default:
            UIApplication.sharedApplication().idleTimerDisabled = false
        }

        // start / stop the actual stream
        super.toggleStreaming(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
