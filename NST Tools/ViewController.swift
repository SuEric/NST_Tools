//
//  ViewController.swift
//  NST Tools
//
//  Created by Eric García on 30/11/16.
//  Copyright © 2016 Procodific. All rights reserved.
//

import UIKit

import Crashlytics


class ViewController: UIViewController {
    
    let urlRequest = URLRequest(url: URL(string: "http://192.168.100.253/openDoor")!)
    let urlConfig = URLSessionConfiguration.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlConfig.timeoutIntervalForRequest = 6
        urlConfig.timeoutIntervalForResource = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func openDoor(_ sender: UIButton) {
        
        let session = URLSession(configuration: urlConfig);
        
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            let doorOpened = (data != nil) ? true : false
            
            self.doorAction(successfully: doorOpened)
            
            let title = (doorOpened) ? "Door is open" : "Unable to open door"
            let message = (doorOpened) ? "Have a nice day!" : "Check your current Wi-Fi network"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let _ = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
            
            let closeButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil)
            
            // alert.addAction(settingsAction)
            alert.addAction(closeButton)
            self.present(alert, animated: true, completion: nil)
        }).resume()
    }

    func doorAction(successfully: Bool) {
        Answers.logCustomEvent(withName: "DoorOpen", customAttributes: ["success": successfully])
    }

}

