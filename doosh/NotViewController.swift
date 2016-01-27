//
//  ViewController.swift
//  doosh
//
//  Created by Abigail Russell on 1/20/16.
//  Copyright © 2016 Abigail Russell. All rights reserved.
//
/*
import UIKit
import OAuthSwift

class ViewController: UIViewController {
    
    
    
    var results: [AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hell yes:)")
        // Do any additional setup after loading the view, typically from a nib.
        
        //parameters["name"] = "Fitbit"
        
        //doOAuthFitbit2()
    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func doOAuthFitbit2(serviceParameters: [String:String]) {
            print("Fitbit 2")
        
            let oauthswift = OAuth2Swift(
                consumerKey:    Fitbit["consumerKey"]!,
                consumerSecret: Fitbit["consumerSecret"]!,
                
                //serviceParameters["consumerSecret"]!,
                authorizeUrl:   "https://www.fitbit.com/oauth2/authorize",
                accessTokenUrl: "https://api.fitbit.com/oauth2/token",
                responseType:   "code"
            )
            oauthswift.accessTokenBasicAuthentification = true
            let state: String = generateStateWithLength(20) as String
            oauthswift.authorize_url_handler = SafariURLHandler(viewController: self)
            
            
        oauthswift.authorizeWithCallbackURL(NSURL(string: "FitAlarmHelper://oauth-callback/fitbit2")!,
            scope: "profile",
            state: state, success: {
                credential, response, parameters in
            
                print(response)
                print(credential.oauth_token)
                print("okay")
                //self.showTokenAlert("Fitbit", credential: credential)
                self.testFitbit2(oauthswift)
            
                }, failure: { error in
                    print(error.localizedDescription)
            })
        
    }
    
    func testFitbit2(oauthswift: OAuth2Swift) {
        print("test")
        oauthswift.client.get("https://api.fitbit.com/1/user/-/profile.json", parameters: [:],
            success: {
                data, response in
                let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                print(jsonDict)
            }, failure: { error in
                print(error.localizedDescription)
        })
    }




}
*/
