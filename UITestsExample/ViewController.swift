//
//  ViewController.swift
//  UITestsExample
//
//  Created by Rafał Kwiatkowski on 16/10/2020.
//

import UIKit

class ViewController: UIViewController {

    var tracker: TrackerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func button1Tapped(_ sender: Any) {
        tracker?.trackEvent(.init(name: "button_tapped", params: [
            .eventName: "button1_tapped",
            .screen: "main_screen",
            .custom(key: "screen_orientation"): view.frame.size.orientation
        ]))
    }
    
    @IBAction func button2Tapped(_ sender: Any) {
        tracker?.trackEvent(.init(name: "button_tapped", params: [
            .eventName: "button2_tapped",
            .screen: "main_screen",
            .custom(key: "screen_orientation"): view.frame.size.orientation
        ]))
    }
}

extension CGSize {
    var orientation: String {
        if width > height {
            return "landscape"
        } else {
            return "portrait"
        }
    }
}

