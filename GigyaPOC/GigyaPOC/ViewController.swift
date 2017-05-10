//
//  ViewController.swift
//  GigyaPOC
//
//  Created by Hamada, Zied on 4/27/17.
//  Copyright © 2017 Hamada, Zied. All rights reserved.
//

import UIKit



class ViewController: UIViewController,GSPluginViewDelegate,GSAccountsDelegate{
    
    var appDelegate: AppDelegate?
    var userProfile: String?
     @IBOutlet weak var sessionInfo: UITextView!

    @IBOutlet weak var loginInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInButton.addTarget(self, action: #selector(didTapLogin(_:)), for: .touchUpInside)
        //loginInButton.layer.borderWidth = 1
        //loginInButton.layer.borderColor = UIColor.black.cgColor
    }


    
    // MARK: Actions
    
    func didTapLogin(_ sender: UIButton) {
        print("showScreenSet called")
        if Gigya.isSessionValid() {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc : ViewControllerLoggedIn = mainStoryboard.instantiateViewController(withIdentifier: "ViewControllerLoggedIn") as? ViewControllerLoggedIn else { return }
            
            vc.userProfile = self.userProfile
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            self.userProfile=""
            var params = [String: AnyObject]()
            //params["screenSet"] = "DefaultMobile-RegistrationLogin"
            //params["screenSet"] = "Default-RegistrationLogin" as AnyObject
            params["screenSet"] = "Craig-RegistrationLogin" as AnyObject
            Gigya.showPluginDialogOver(self,
                                   plugin: "accounts.screenSet",
                                   parameters: params,
                                   
            //account.requestAccessToAccounts(with: accountType, options: nil, completion: {(success: Bool, error: NSError!) -> Void in
            //account.requestAccessToAccounts(with: accountType, options: nil, completion: {(success, error) -> Void in
            
            completionHandler: {(closedByUser, error) -> Void in
                if (error == nil && !closedByUser) {
                    print("Login was successful")
                    //Transition to main screen
                    /*let loggedInViewController:ViewControllerLoggedIn = ViewControllerLoggedIn()
                    
                    self.present(loggedInViewController, animated: true, completion: nil)
                     */
                    self.getProfileDetails()
                    
                }
                else if error != nil {
                    // Handle error
                    let alert = UIAlertController(title: "Error with login",
                                                  message: error!.localizedDescription,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) -> Void in
                        print("Alert closed")
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            },
            delegate:self)
        }
    }
    // MARK: Get GIGYA session details
    func getProfileDetails() {
        
        if Gigya.isSessionValid() {
            //let ad = appDelegate
               //if ad.gigyaUserAccount == nil {
            
                        let request = GSRequest(forMethod: "accounts.getAccountInfo")!
                        request.send(responseHandler:{(response, error) -> Void in
                        if (error == nil) {
                                //ad!.gigyaUserAccount = response as? GSAccount
                            //print(response!)
                            //var sResponse : GSResponse?
                            let sJsonResponseData=response?.jsonString().data(using: String.Encoding.utf8, allowLossyConversion: false)
                            print(sJsonResponseData!)
                            /*Optional(GSResponse = {
                                                    method = "accounts.getAccountInfo";
                                                    response =     {
                                                                    UID = "_guid_ig8gWuy-D0bFD2aOjppko0HXqz5e5a3ZzaWuS6PpIkk=";
                                                                    UIDSignature = "DYDJ3afC0TLSOeUSeUw4tJyAo34=";
                                                                    callId = 5be5347f73c446ce9cbf9495e07cb58b;
                                                                    created = "2017-04-26T16:29:47.828Z";
                                                                    createdTimestamp = 1493224187828;
                                                                    data =         {};
                                                                    errorCode = 0;
                                                                    isActive = 1;
                                                                    isLockedOut = 0;
                                                                    isRegistered = 1;
                                                                    isVerified = 1;
                                                                    lastLogin = "2017-05-04T14:12:32.157Z";
                                                                    lastLoginTimestamp = 1493907152157;
                                                                    lastUpdated = "2017-05-04T14:12:32.316Z";
                                                                    lastUpdatedTimestamp = 1493907152316;
                                                                    loginProvider = googleplus;
                                                                    oldestDataUpdated = "2017-05-04T14:12:32.125Z";
                                                                    oldestDataUpdatedTimestamp = 1493907152125;
                                                                    profile =      {
                                                                                    email = "zied.hamada.cr@gmail.com";
                                                                                    firstName = Zied;
                                                                                    lastName = HAMADA;
                                                                                    photoURL = "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg?sz=500";
                                                                                    thumbnailURL = "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg?sz=50";
                                                                                    };
                                                                    registered = "2017-04-26T16:29:47.893Z";
                                                                    registeredTimestamp = 1493224187893;
                                                                    signatureTimestamp = 1493907153;
                                                                    socialProviders = googleplus;
                                                                    statusCode = 200;
                                                                    statusReason = OK;
                                                                    time = "2017-05-04T14:12:33.627Z";
                                                                    verified = "2017-04-26T16:29:47.844Z";
                                                                    verifiedTimestamp = 1493224187844;
                                                                    };
                                                        }
                                        )
                             */

                               do {
                                    let responseJSONObject = try JSONSerialization.jsonObject(with : sJsonResponseData!, options: []) as! [String:AnyObject]
                                    let loginProvider=responseJSONObject["loginProvider"] as? String
                                    let socialProviders=responseJSONObject["socialProviders"] as? String
                                    let lastLogin = responseJSONObject["lastLogin"] as? String
                                    let UID = responseJSONObject["UID"] as? String
                                    if let responseProfile=responseJSONObject["profile"] as? [ String : Any ]
                                        {
                                            let userName = responseProfile["firstName"] as? String ?? "NA"
                                            let lastName = responseProfile["lastName"] as? String ?? "NA"
                                            let email = responseProfile["email"] as? String ?? "NA"
                                            self.userProfile="userName: \(userName)\nlastName: \(lastName)\nemail: \(email)\nLast Logged In: \(lastLogin!)\nLogin Provider: \(loginProvider!)\nSocialProvider: \(socialProviders!)\nUID: \(UID!)"
                                        }
                                    //self.userProfile=responseJSONObject["profile"] as? [ String : String]
                                    } catch let error as NSError {
                                            print(error)
                                    }
                            
                            
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let vc : ViewControllerLoggedIn = mainStoryboard.instantiateViewController(withIdentifier: "ViewControllerLoggedIn") as? ViewControllerLoggedIn else { return }
                            
                            vc.userProfile = self.userProfile
                            self.navigationController?.pushViewController(vc, animated: true)
                         
                            }
                        else {
                            self.userProfile = "Got error on getAccountInfo: \(error)"
                            print(self.userProfile!)
                        }
                    })
            
            //}
        }
        else {
            self.userProfile = "Invalid Gigya Session -- Not logged in"
            print(self.userProfile!)
            //self.profilePhoto.image = nil
        }
    }
    // MARK: JSON Parsing
    /*func parseResponse(response: String) -> Void{
    
        do {
                //let data = response,
                    let json = try JSONSerialization.jsonObject(with: response) as? [String: Any],
                    let profile = json["profile"] as? [[String: Any]]
            
            }
            } catch {
            print("Error deserializing JSON: \(error)")
            }
    }*/

 

    //
    // GSAccountsDelegate
    //
    /*func accountDidLogin(account: GSAccount) -> Void {
        self.appDelegate!.user = account
        let alert = UIAlertController(title: "Gigya Session Test",
                                      message: "You have logged in",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) -> Void in
            print("Alert closed")
        })
        self.present(alert, animated: true, completion: nil)
    }
 */
    
    //func accountDidLogout() -> Void {
    //    self.appDelegate!.user = nil
    //}
    
    //
    // GSPluginViewDelegate methods
    //
    func pluginView(pluginView: GSPluginView!, finishedLoadingPluginWithEvent event: [NSObject : AnyObject]!) {
        print("Finished loading plugin with event: \(event)")
    }
    
    func pluginView(pluginView: GSPluginView!, firedEvent event: [NSObject : AnyObject]!) {
        print("Plugin fired event: \(event)")
    }
    
    func pluginView(pluginView: GSPluginView!, didFailWithError error: NSError!) {
        print("Plugin failed with error: \(error)")
    }
    
    //Navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ViewControllerLoggedIn
    }*/
    

}

