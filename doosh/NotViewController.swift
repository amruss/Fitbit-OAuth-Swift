//
//  ViewController.swift
//  doosh
//
//  Created by Abigail Russell on 1/20/16.
//  Copyright © 2016 Abigail Russell. All rights reserved.
//
/*

import OAuthSwift

#if os(iOS)
    import UIKit
    class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
      //  var alarmList: [Alarms]
        
        @IBOutlet
        var AlarmTable: UITableView!
        
        //var AlarmTimeText: UILabel!
        //var RepetitionText: UILabel!
        
        var items: [Alarms] = []
       // self.possibleTableData = [NSArray arrayWithObjects:@"Spicy garlic Lime Chicken"]
        var secondsTill: [Int] = []
        
        
    

    
    }



extension ViewController {
    
    
    func doAuthService(service: String) {

        guard var parameters = services[service] else {
            showAlertView("Miss configuration", message: "\(service) not configured")
            return
        }
        
        
        if Services.parametersEmpty(parameters) { // no value to set
            let message = "\(service) seems to have not weel configured. \nPlease fill consumer key and secret into configuration file \(self.confPath)"
            print(message)
            showAlertView("Miss configuration", message: message)
            // TODO here ask for parameters instead
        }
        
        parameters["name"] = service

        switch service {
        
        case "Fitbit2":
            doOAuthFitbit2(parameters)
        
        default:
            print("\(service) not implemented")
        }
    }
    
    
    func doOAuthFitbit2(serviceParameters: [String:String]) {
            let oauthswift = OAuth2Swift(
                consumerKey:    serviceParameters["consumerKey"]!,
                consumerSecret: serviceParameters["consumerSecret"]!,
                authorizeUrl:   "https://www.fitbit.com/oauth2/authorize",
                accessTokenUrl: "https://api.fitbit.com/oauth2/token",
                responseType:   "code"
               
        )
        oauthswift.accessTokenBasicAuthentification = true
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorize_url_handler = SafariURLHandler(viewController: self)
        //Get profile data
        oauthswift.authorizeWithCallbackURL( NSURL(string: "YourCallBackUrl")!, scope: "activity%20profile%20settings", state: state, success: {
            credential, response, parameters in
            self.showTokenAlert(serviceParameters["name"], credential: credential)
            let oauth_token = credential
            print(oauth_token)
            self.testFitbit2(oauthswift)
            self.getFitbitDevices(oauthswift)
            
            }, failure: { error in
                print("error")
                print(error.localizedDescription)
        })

        
    }
    func testFitbit2(oauthswift: OAuth2Swift) {
        oauthswift.client.get("https://api.fitbit.com/1/user/-/profile.json", parameters: [:],
            success: {
            data, response in
            let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            
                //Get display name
            let currentWeather = jsonDict?["user"] as? [String: AnyObject]
            let currentProfileName = currentWeather?["displayName"] as? String
            print(currentProfileName)
                //Get timezone
            let current_timezone = currentWeather?["timezone"] as? String
            print (current_timezone)
            }, failure: { error in
            print(error.localizedDescription)
            })
        }
    
    func getFitbitDevices(oauthswift: OAuth2Swift) {
        oauthswift.client.get("https://api.fitbit.com/1/user/-/devices.json", parameters: [:],
            success: {
            data, response in
            let devicesList: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                print(devicesList)
                //right now only for one device-- need to fix this
                //Get specks of first device
                let first_device = devicesList[0]
                let type = first_device?["type"] as? String
                let first_device_id = first_device?["id"] as? String
                let first_device_version = first_device?["deviceVersion"] as? String
                
                self.getFitbitDevicesAlarms(oauthswift, trackerID: first_device_id!)
                
                
            }, failure: { error in
                print(error.localizedDescription)
            })
    }
    func getFitbitDevicesAlarms(oauthswift: OAuth2Swift, trackerID: String) {
        oauthswift.client.get("https://api.fitbit.com/1/user/-/devices/tracker/" + trackerID + "/alarms.json", parameters: [:],
            success: {
                data, response in
                let AlarmsList1: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                let trackerAlarms = AlarmsList1?["trackerAlarms"] as? NSArray
                var counter = 0
                for i in trackerAlarms!{
                    var current_alarm = i
                    var new_alarm = Alarms(alarmID: (current_alarm["alarmId"] as? Int)!,
                        enabled: (current_alarm["enabled"] as? Bool)!,
                        recurring: (current_alarm["recurring"] as? Bool)!,
                        time: (current_alarm["time"] as? String)!,
                        weekDays: (current_alarm["weekDays"] as? [String])!)
                    //Cut down time string
                    var time = new_alarm.time
                    var index1 = time.startIndex.advancedBy(5)
                    var substring1 = time.substringToIndex(index1)
                    new_alarm.time = substring1
                 
                    self.items.append(new_alarm)
                    
                    self.AlarmTable.reloadData()
                    
                    //self.secondsTill.append(self.calculateSeconds(substring1))
                    
                    
                    let date = NSDate().dateByAddingTimeInterval(self.calculateSeconds(substring1))
                    let timer = NSTimer(fireDate: date, interval: 0, target: self, selector: "runCode", userInfo: nil, repeats: false)
                    NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
                    
                    counter += 1
                
                    
                }
             
                
                
                //right now only for one device-- need to fix this
                //Get specks of first device
                
                
                
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    

    

   
}

let services = Services()
let DocumentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
let FileManager: NSFileManager = NSFileManager.defaultManager()



extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Custom cell
        //self.AlarmTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        var nib = UINib(nibName: "viewTableCell", bundle: nil)
        AlarmTable.registerNib(nib, forCellReuseIdentifier: "cell")
        
        // Load config from files
        initConf()
        
        // init now
        get_url_handler()
        
        self.navigationItem.title = "OAuth"
        
        
       
        
        
        
        
        
        /*#if os(iOS)
            self.navigationItem.title = "OAuth"
            //et tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
            //tableView.delegate = self
            //tableView.dataSource = self
           // self.view.addSubview(tableView)
        #endif*/
    }
    
    // MARK: utility methods
    
    var confPath: String {
        let appPath = "\(DocumentDirectory)/.oauth/"
        if !FileManager.fileExistsAtPath(appPath) {
            do {
                try FileManager.createDirectoryAtPath(appPath, withIntermediateDirectories: false, attributes: nil)
            }catch {
                print("Failed to create \(appPath)")
            }
        }
        return "\(appPath)Services.plist"
    }
    
    func initConf() {
        initConfOld()
        print("Load configuration from \n\(self.confPath)")
        
        // Load config from model file
        if let path = NSBundle.mainBundle().pathForResource("Services", ofType: "plist") {
            services.loadFromFile(path)
            
            if !FileManager.fileExistsAtPath(confPath) {
                do {
                    try FileManager.copyItemAtPath(path, toPath: confPath)
                }catch {
                    print("Failed to copy empty conf to\(confPath)")
                }
            }
        }
        services.loadFromFile(confPath)
        

    }
    
    func initConfOld() { // TODO Must be removed later

        services["Fitbit"] = Fitbit
    }
    
    func snapshot() -> NSData {
     
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
            return  UIImageJPEGRepresentation(fullScreenshot, 0.5)!

    }
    
    func showAlertView(title: String, message: String) {
     
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
   
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauth_token)"
        if !credential.oauth_token_secret.isEmpty {
            message += "\n\noauth_toke_secret:\(credential.oauth_token_secret)"
        }
        self.showAlertView(name ?? "Service", message: message)
        
        if let service = name {
            services.updateService(service, dico: ["authentified":"1"])
            // TODO refresh graphic
        }
    }
    

    }
    
    func get_url_handler() -> OAuthSwiftURLHandlerType {
        // Create a WebViewController with default behaviour from OAuthWebViewController
        let url_handler = createWebViewController()
        #if os(OSX)
            self.addChildViewController(url_handler) // allow WebViewController to use this ViewController as parent to be presented
        #endif
        return url_handler
        
        
    
    }
    
    
    @IBAction func connectButtonPress(sender: AnyObject) {
        items.removeAll()
        doAuthService("Fitbit2")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
        //return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //var cell:UITableViewCell = self.AlarmTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        //cell.textLabel?.text = self.items[indexPath.row].time
        
        
        var cell: AlarmTableCell = self.AlarmTable.dequeueReusableCellWithIdentifier("cell") as! AlarmTableCell
        
        cell.AlarmTimeCell.text = self.items[indexPath.row].time
        
        var weekDays = ""
        for i in self.items[indexPath.row].weekDays {
            var index1 = i.startIndex.advancedBy(1)
            var substring1 = i.substringToIndex(index1)
            weekDays = weekDays + "\(substring1) "
        }
        if weekDays == "" {
            weekDays = "ONCE"
        }
        
        
        cell.AlarmRepetitionCell.text = weekDays
        
            //self.items[indexPath.row].weekDays[0]
        //ell.AlarmOnCell.backgroundColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         var cell: AlarmTableCell = self.AlarmTable.dequeueReusableCellWithIdentifier("cell") as! AlarmTableCell
        print (self.items[indexPath.row].weekDays)
        cell.AlarmOnCell.backgroundColor = UIColor.blackColor()
        print("selected")
        
        
    
}
    func runCode() {
        print("ALARM")
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        print(convertedDate)
        
    }
    func calculateSeconds(time: String) -> Double {
        
        //Current Time
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        
        var index1 = convertedDate.startIndex.advancedBy(2)
        var hour = convertedDate.substringToIndex(index1)
        
        var index2 = convertedDate.startIndex.advancedBy(3)
        var minuteSec = convertedDate.substringFromIndex(index2)
        
        var index3 = minuteSec.startIndex.advancedBy(2)
        var minute = minuteSec.substringToIndex(index3)
        
        var index4 = minuteSec.startIndex.advancedBy(3)
        var second = minuteSec.substringFromIndex(index4)
    
        var intHour = Int(hour)
        var intMinute = Int(minute)
        var intSecond = Int(second)
        
        var index12 = time.startIndex.advancedBy(2)
        var hour2 = time.substringToIndex(index1)
        
        var index32 = time.startIndex.advancedBy(3)
        var minute2 = time.substringFromIndex(index32)
        
        var intHourAlarm = Int(hour2)
        var intMinuteAlarm = Int(minute2)
        
        
        if intHour > intHourAlarm {
            var hoursTill = 23 - intHour! + intHourAlarm!
            var minutesTill = 0
            if intMinute > intMinuteAlarm {
                minutesTill = 59 - intMinute! + intMinuteAlarm!
            } else {
                minutesTill = intMinuteAlarm! - intMinute!+5
            }
            
            var secondsTill = intSecond! + minutesTill*60 + hoursTill*60*60
            return Double(secondsTill)
            
        
        }
        if intHour == intHourAlarm {
            if intMinute > intMinuteAlarm {
                var hoursTill = 23 - intHour! + intHourAlarm!
                var minutesTill = 0
                if intMinute > intMinuteAlarm {
                    minutesTill = 59 - intMinute! + intMinuteAlarm!
                } else {
                    minutesTill = intMinuteAlarm! - intMinute!+5
                }
                
                var secondsTill = intSecond! + minutesTill*60 + hoursTill*60*60
                return Double(secondsTill)
            }
            else {
                var minutesTill = intMinuteAlarm! - intMinute! + 5
                var secondsTill = minutesTill*60
                return Double(secondsTill)
            }
        }
        else {
            var hoursTill = intHourAlarm! - 1 - intHour!
            var minutesTill = intMinuteAlarm! + intMinute! + 5
            var secondsTill = hoursTill + minutesTill*60
            return Double(secondsTill)
                    }
        
    }
}





}
*/
