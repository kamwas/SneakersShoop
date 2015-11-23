//
//  SRGenderSelectionViewController.swift
//  Sneakers
//
//  Created by Kamil Wasag on 16/11/15.
//  Copyright © 2015 Figure8. All rights reserved.
//

import UIKit
import RESTAPI


class SRGenderSelectionViewController: UIViewController {
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func womansSneakersButtonSelected(sender: UIButton) {
        self.setGender(SRFGenderParemeters.GenderFemale.unretainedString)
    }
    
    @IBAction func mansSneakersButtonSelected(sender: UIButton) {
        self.setGender(SRFGenderParemeters.GenderMale.unretainedString)
    }
    
    private func setGender(gender:String){
        self.selectGender(gender)
        showSneakersViewController()
    }
    
    private func selectGender(gender: String){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(gender, forKey: UserDefaultsKeys.genderParameter)
        userDefaults.synchronize()
    }
    
    private func showSneakersViewController(){
        let sneakersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(StoryboardIdentifiers.sneakersCollection)
        UIView.transitionFromView(self.view,
            toView: sneakersViewController.view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve) { (Bool) -> Void in
                let mainWindow = UIApplication.sharedApplication().delegate!.window!
                mainWindow!.rootViewController = sneakersViewController
                
        }
    }
}
