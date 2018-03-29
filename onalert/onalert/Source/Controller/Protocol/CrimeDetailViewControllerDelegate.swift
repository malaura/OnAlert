//
//  CrimeDetailViewControllerDelegate.swift
//  onalert
//
//  Created by Maria Rodriguez on 3/7/17.
//  Copyright © 2017 Maria Laura Rodriguez. All rights reserved.
//


import Foundation


protocol CrimeDetailViewControllerDelegate: class {
    func crimeDetailViewController(_ viewController: CrimeDetailViewController, didChange crime: Crime)
}
