
//

import Foundation
import UIKit
import CoreTelephony

class CommonMethods {
    
    static let sharedInstance = CommonMethods()//Singleton instance of the class.
    
    
    var viewController:UIViewController?
    
    /**
     This method is used to display alert message over presented view controller.
     - parameter title:  Header of the message
     - parameter message:   Actual message that should be displayed to the user
     - delegate:  Object of UIAlertViewDelege.  Add UIAlertViewDelegate as one of the deleage to the class and pass self or nil over here
     - CanelButtonTitel:  Title of canel button that should be displayed to the user.
     - presentingController:  Current view controller where alert should be displayed to the user.  Mostly self should be passed as parameter over here.
     
     - Date: 06-May-2016
     */
    
    
    func displayAlert(_ title:String, message andMessage:String, delegate andDelegate:UIAlertViewDelegate?, cancelButtonTitle andCancelButtonTitle:String,presentingController aOwner:AnyObject) {
        let alert:UIAlertController = UIAlertController.init(title: title, message: andMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: andCancelButtonTitle, style: UIAlertActionStyle.default, handler:nil))
        aOwner.present(alert, animated: true, completion: nil)
    }
    
   
    func displayLoader(_ controller:UIViewController, withMessage andMessage:String) {
        viewController = controller
        
        //EZLoadingActivity.showOnController(andMessage, disableUI: true, controller: controller)
    }
    
    
    /**
     This method would be used to hide loading indicator.  It would be used once long operation is completed (web service calling)
     - parameter controller:  This is currently presented view controller on the device. Mostly need to pass self over here.
     - Date: 06-May-2016
     */
    func removeLoader(_ controller:UIViewController) {
        //EZLoadingActivity.hide()
        
    }
    
    
    func FormatDateForEventsFromString(_ strSourceDate: String, forFormat strDateFormat:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormat
        return self.formatDateForEventList(dateFormatter.date(from: strSourceDate)!, isFromVitals: false, isEndDate: false)
    }
    
    func convertStringToDate(_ strSourceDate: String, forFormat strDateFormat:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormat
        return dateFormatter.date(from: strSourceDate)!
    }
    
    func convertDateToString(_ dtSourceDate: Date, forFormat strDateFormat:String) -> NSString
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormat
        return dateFormatter.string(from: dtSourceDate) as NSString
    }
    
    
    func formatDateForEventList(_ origDate: Date, isFromVitals:Bool, isEndDate:Bool) -> String
    {
        let todayDate = Date()
        var ti: Double = origDate.timeIntervalSince(todayDate)
        ti = ti * -1
        
        let dateFormatter = DateFormatter()
        if ti < -1 {
            ti = ti * -1
        }
        
        if ti < 24 * 60 * 60
        {
            //dateFormatter.dateFormat = "yyyy/MM/dd"
            dateFormatter.dateFormat = "M/d/yyyy"
            let dtStart = dateFormatter.date(from: dateFormatter.string(from: origDate))!
            let dtToday = dateFormatter.date(from: dateFormatter.string(from: todayDate))!
            
            if isEndDate {
                dateFormatter.dateFormat = "MM/dd h:mma"
            } else {
                
                if  isFromVitals
                {
                    if dtStart.compare(dtToday) == ComparisonResult.orderedSame
                    {
                        dateFormatter.dateFormat = "h:mma"
                    }
                    else if dtStart.compare(dtToday) == ComparisonResult.orderedAscending
                    {
                        return "yesterday"
                    }
                    else
                    {
                        dateFormatter.dateFormat = "EEE"
                    }
                }
                else {
                    if dtStart.compare(dtToday) == ComparisonResult.orderedSame
                    {
                        dateFormatter.dateFormat = "h:mma"
                    }
                    else
                    {
                        dateFormatter.dateFormat = "EEE"
                    }
                }
            }
            
            //Find the currrent Date.
            //
            
            // Need to return time in hrs e.g 10 am
            //dateFormatter.dateFormat = "hh:mm a"
            //dateFormatter.dateFormat = "h:mma"
            
        }
        else if ti <  7 * 24 * 60 * 60
        {
            // Check for Ending Year
            let unitFlags: NSCalendar.Unit = [.hour, .minute, .second, .day, .month, .year]
            let compToday = (Calendar.current as NSCalendar).components(unitFlags, from: todayDate)
            let compOrigin = (Calendar.current as NSCalendar).components(unitFlags, from: origDate)
            
            if isFromVitals {
                // return whole date as e.g. YYYY-MM-DD
                if compToday.year == compOrigin.year
                {
                    dateFormatter.dateFormat = "MM/dd"
                }
                else
                {
                    dateFormatter.dateFormat = "MM/dd"
                }
            } else if isEndDate {
                // return whole date as e.g. YYYY-MM-DD
                if compToday.year == compOrigin.year
                {
                    dateFormatter.dateFormat = "MM/dd h:mma"
                }
                else
                {
                    dateFormatter.dateFormat = "M/d/yyyy h:mma"
                }
            }else {
                // Need to return time in days e.g Monday
                //dateFormatter.dateFormat = "c"
                //dateFormatter.dateFormat = "EEEE"
                //In order to display mon,tue, wed, thu
                dateFormatter.dateFormat = "EEE"
                
            }
        }
        else
        {
            // Check for Ending Year
            let unitFlags: NSCalendar.Unit = [.hour, .minute, .second, .day, .month, .year]
            let compToday = (Calendar.current as NSCalendar).components(unitFlags, from: todayDate)
            let compOrigin = (Calendar.current as NSCalendar).components(unitFlags, from: origDate)
            
            if isFromVitals {
                // return whole date as e.g. YYYY-MM-DD
                if compToday.year == compOrigin.year
                {
                    dateFormatter.dateFormat = "MM/dd"
                }
                else
                {
                    dateFormatter.dateFormat = "MM/dd"
                }
            } else if isEndDate {
                // return whole date as e.g. YYYY-MM-DD
                if compToday.year == compOrigin.year
                {
                    dateFormatter.dateFormat = "MM/dd h:mma"
                }
                else
                {
                    dateFormatter.dateFormat = "M/d/yyyy h:mma"
                }
            }else {
                // return whole date as e.g. YYYY-MM-DD
                if compToday.year == compOrigin.year
                {
                    dateFormatter.dateFormat = "MM/dd"
                }
                else
                {
                    dateFormatter.dateFormat = "M/d/yyyy"
                }
            }
        }
        
        var strDate : String = String(dateFormatter.string(from: origDate).lowercased())
        //Checking whether current character contains value if yes then will replace the same blank
        strDate = strDate.replacingOccurrences(of: ":00", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        if strDate.range(of: "/0") != nil {
            strDate = strDate.replacingOccurrences(of: "/0", with: "/", options: NSString.CompareOptions.literal, range: nil)
        }
        
        let strSubString:String = (strDate as NSString).substring(to: 1)
        if strSubString == "0" {
            strDate = (strDate as NSString).substring(from: 1)
        }
        
        //Fetching all character
        let letters = CharacterSet.letters
        let range = strDate.rangeOfCharacter(from: letters)
        // range will be nil if no letters is found
        if let test = range {
            strDate = String(strDate.characters.first!).capitalized + String(strDate.characters.dropFirst())
        }
        //return dateFormatter.stringFromDate(origDate).lowercaseString
        return strDate
    }
    
    func createProfileImageFromFirstName(_ strFirstName: String, andLastName strLastName:String) -> UIImage {
        
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 100.0, height: 100.0)
        lblNameInitialize.textColor = UIColor.white
        lblNameInitialize.text = String(strFirstName.characters.first!) + String(strLastName.characters.first!)
        lblNameInitialize.textAlignment = NSTextAlignment.center
        //lblNameInitialize.backgroundColor = UIColor(netHex: Constants.kEventTableBackgroundColor)
        lblNameInitialize.layer.cornerRadius = 50.0
        
        
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
   
    func canDevicePlaceAPhoneCall() -> Bool {
        /*
         
         Returns YES if the device can place a phone call
         
         */
        // Check if the device can place a phone call
        if  UIApplication.shared.canOpenURL(URL(string: "tel://")!) {
            // Device supports phone calls, lets confirm it can place one right now
            let netInfo = CTTelephonyNetworkInfo()
            let carrier = netInfo.subscriberCellularProvider
            
            if (((carrier?.mobileNetworkCode?.isEmpty)) == nil)
            {
                //Constants.kAppDelegate.displayAlertView(Constants.kAPP_NAME, aStrMessage: Constants.kAlertCannotPlaceCall, aStrCancelTitle: Constants.kOK, aStrOtherTitle: nil)
                return false
            }
            
            let mnc = carrier!.mobileNetworkCode
            
            if (mnc?.characters.count == 0) || (mnc == "65535") {
                // Device cannot place a call at this time.  SIM might be removed.
                
                //Constants.kAppDelegate.displayAlertView(Constants.kAPP_NAME, aStrMessage: Constants.kAlertCannotPlaceCall, aStrCancelTitle: Constants.kOK, aStrOtherTitle: nil)
                return false
            }
            else {
                // Device can place a phone call
                return true
            }
        }
        else {
            
            //Constants.kAppDelegate.displayAlertView(Constants.kAPP_NAME, aStrMessage: Constants.kAlertDeviceDontSupportCalls, aStrCancelTitle: Constants.kOK, aStrOtherTitle: nil)
            return false
        }
    }
    
    
    
    
    
    
    //MARK:- Getting and setting profile Pic from document directory
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func downloadImageAndStore(from:String)
    {
        let strURL : String = from.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let url2 = URL(string: strURL)
        getDataFromUrl(url: url2!) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.sync() { () -> Void in
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("userImage.png")
                print(paths)
                let imageData = data
                fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func setProfileImageFromDocument(btnProfile: UIButton) {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("userImage.png")
        if fileManager.fileExists(atPath: imagePAth){
            btnProfile.contentMode = .scaleAspectFill
            btnProfile.setImage(UIImage(contentsOfFile: imagePAth), for: .normal)
        }else{
            print("No Image")
        }
    }
    
    func setProfileImageInImageViewDocument(imgVw: UIImageView) {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("userImage.png")
        if fileManager.fileExists(atPath: imagePAth){
            imgVw.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
        }
    }
    
    func removeProfileImage() {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/userImage.png"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }}
    
    
    
    func getDateFromString(strDate: String)->String{
        let strDateOnly = strDate.components(separatedBy: "T")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: strDateOnly[0])
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.string(from: date!)
        return newDate
    }
    
    func getLocalDateFromString(strDate: String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone=TimeZone(identifier: "UTC")
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date=dateFormatter.date(from: strDate)
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd/MM/yyyy"
        return displayDateFormatter.string(from: date!)
    }
    
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex: String = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with: candidate)
    }
    
    
    
    func calculateDaysBetweenTwoDates(start: Date, end: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone=TimeZone.current
        dateFormatter.dateFormat="yyyy-MM-dd"
        let startStr = dateFormatter.string(from: start)
        let endStr = dateFormatter.string(from: end)
        
        let startDate = dateFormatter.date(from: startStr)!
        let endDate = dateFormatter.date(from: endStr)!
        
        var currentCalendar = Calendar.current
        currentCalendar.timeZone = TimeZone.current
        let daysBetween = currentCalendar.dateComponents([.day], from: startDate, to: endDate)
        return daysBetween.day ?? 0
    }
    
    
}




