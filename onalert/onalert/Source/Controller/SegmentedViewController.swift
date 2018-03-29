//
//  SegmentedViewController.swift
//  onalert
//
//  Created by Maria Rodriguez on 3/1/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//

import UIKit


class SegmentedViewController : UIViewController {
    @IBAction private func segmentedControlUpdated(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            listContainerView.isHidden = false
            mapContainerView.isHidden = true
        }
        else {
            listContainerView.isHidden = true
            mapContainerView.isHidden = false
        }
    }
    
    @IBOutlet private weak var listContainerView: UIView!
    @IBOutlet private weak var mapContainerView: UIView!
}
