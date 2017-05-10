//
//  ViewControllerLoggedIn.swift
//  GigyaPOC
//
//  Created by Hamada, Zied on 5/1/17.
//  Copyright © 2017 Hamada, Zied. All rights reserved.
//

import UIKit

class ViewControllerLoggedIn: UIViewController {
    var userProfile: String? = nil

    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var DisplayProfile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logOut.addTarget(self, action: #selector(didTapLogout(_:)), for: .touchUpInside)
        //let sec: ViewControllerLoggedIn = ViewControllerLoggedIn(nibName: nil, bundle: nil)
        //self.appDelegate!.user = account
        DisplayProfile.text=self.userProfile
    }
    
    // MARK: Actions
    
    func didTapLogout(_ sender: UIButton) {
        Gigya.logout( completionHandler:{ (response, error) -> Void in
            if (error != nil) {
                let alert = UIAlertController(title: "Gigya Native Mobile Logout",
                                              message: "There was a problem logging out off Gigya. Gigya returned error code \(error)",
                    preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) -> Void in
                    print("Alert closed")
                })
                self.present(alert, animated: true, completion: nil)
                print("logout Error:\(error!.localizedDescription)")
            } else {
                // Center View updates
                print("logout succesfully")
                self.navigationController?.popViewController(animated: true)
                
            }
        })

        
    }

    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
