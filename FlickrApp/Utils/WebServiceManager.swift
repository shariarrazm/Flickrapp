import Foundation
import Alamofire

class WebServiceManager : NSObject {
    
    static let sharedInstance = WebServiceManager()//Singleton instance of the class.
    let configuration = URLSessionConfiguration.default
    var alamofireManager: Alamofire.SessionManager//For webservice calls
    var net = NetworkReachabilityManager()//For checking internet connectivity
    var isFailure : Bool = false // This variable is set to true or false depending on the result of the webservice.
    // This variable can be used by other class to show alert to the user.
    var strAPIName : String? // This varibale will store the name of API currently executing.
    var sourceController : AnyObject?
    var sourceSelector : Selector?
    var objPredicate : NSCompoundPredicate?
    var strTableName : NSString?
    var strAction : String?
    var dictPredicates : NSDictionary?
    var dateFormatter:DateFormatter = DateFormatter()
    var strServerDateTime:NSString?
    var arrSortDescriptors:NSArray?
    var strResponseMessage:NSString?
    
    //5th Jan
    var iSeriesId:Int?
    //
    
    /**
     Initializer for setting up the WebServiceManger for using through out the app. Used this method for setting the time out for all service calls and for starting the listener for internet connectivity. The main class "" using which the webservice calls are performed is also initialized here.
     */
    override init() {
        self.configuration.timeoutIntervalForRequest = 60.0
        self.alamofireManager = Alamofire.SessionManager(configuration: self.configuration)
        net?.startListening()
    }
    
    func getHeader()->HTTPHeaders {
        
        var headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        return headers
    }
    
    func uploadImageAndData(_ aDictParams:[String: AnyObject]?=nil, andURLString aStrURL:String, withOwner aOwner:AnyObject, withSelector aSel:Selector, withImage aImage:UIImage?, withFileName aFileName:String){

        self.alamofireManager.upload(multipartFormData: { (multipartFormData) in
            if  let image1 = aImage {
                if  let imageData = UIImagePNGRepresentation(image1) {
                    multipartFormData.append(imageData, withName: "image", fileName: aFileName, mimeType: "image/png")
                }
            }
            for (key, value) in aDictParams! {
                if(key == "password_flag" || key == "id" || key == "modified_by" || key == "photo_flag" || key == "associated_person_id" || key == "relationship"){
                    multipartFormData.append( "\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                else{
                    if let aData = value as? Data {
                        multipartFormData.append(aData, withName: key)
                    }else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }
        }, to:aStrURL, method: HTTPMethod.post, headers:getHeader())
        { (result) in
            self.sourceController = aOwner
            self.sourceSelector = aSel
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            let jsonData: AnyObject = response.result.value! as AnyObject
                           
                        } else {
                            var strMessage : String
                            if  let msg = (response.result.value! as! NSDictionary).value(forKey: "message") {
                                strMessage = "\(msg)"
                            }
                            else if let msg = (response.result.value! as! NSDictionary).value(forKey: "error") {
                                strMessage = "\(msg)"
                            }
                            else {
                                strMessage = "Something went wrong"
                            }
                            //let strMessage = (data.result.value! as! NSDictionary).value(forKey: "message")!
                            CommonMethods.sharedInstance.displayAlert(Constants.kAppName, message: strMessage as! String, delegate: nil, cancelButtonTitle: Constants.kOk, presentingController: aOwner)
                            aOwner.perform(aSel, with: nil)
                        }
                    }
                    else
                    {
                        self.isFailure = true
                        aOwner.perform(aSel, with: nil)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
    
    func sendAPIRequestForGet(_ aDictParams:[String: AnyObject]?=nil, andURLString aStrURL:String, withOwner aOwner:AnyObject, withSelector aSel:Selector)
    {
        if net?.isReachable == true {
            self.alamofireManager.request(aStrURL, method: .get, encoding: JSONEncoding.default, headers : self.getHeader()) .responseJSON(options: .allowFragments) { data in
                if !data.result.isFailure {
                    self.isFailure = false
                    self.sourceController = aOwner
                    self.sourceSelector = aSel
                    //
                    
                    if data.response?.statusCode == 200 || data.response?.statusCode == 201 {
                        let jsonData: AnyObject = data.result.value! as AnyObject
                        aOwner.perform(aSel, with: nil)
                        
                    } else if data.response?.statusCode == 401 {
                        
                        //Displaying alert
                    }
                    else
                    {
                        var strMessage : String
                        if  let msg = (data.result.value! as! NSDictionary).value(forKey: "message") {
                            strMessage = "\(msg)"
                        }
                        else if let msg = (data.result.value! as! NSDictionary).value(forKey: "error") {
                            strMessage = "\(msg)"
                        }
                        else {
                            strMessage = "Something went wrong"
                        }
                        
                    }
                    
                } else {
                    self.isFailure = true
                    aOwner.perform(aSel, with: nil)
                }
            }
        }
        else
        {
            self.isFailure = true
            aOwner.perform(aSel, with: nil)
        }
        
        
    }
    
    func sendAPIRequestForPost(_ aDictParams:[String: AnyObject]?=nil, andURLString aStrURL:String, withOwner aOwner:AnyObject, withSelector aSel:Selector)
    {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers , for: URL(string:aStrURL)!)
        self.alamofireManager.session.configuration.httpCookieStorage?.setCookies(cookies, for: URL(string:aStrURL)!, mainDocumentURL: nil)
        
        var dict0:[String:AnyObject] = [String:AnyObject]()
        if aDictParams != nil {
            dict0 = aDictParams!
        }
        
        if net?.isReachable == true
        {
            self.alamofireManager.request(aStrURL, method: .post, parameters: dict0, encoding: JSONEncoding.default, headers : headers) .responseJSON {data in
                if !data.result.isFailure {
                    self.isFailure = false
                    if data.response?.statusCode == 200 || data.response?.statusCode == 201 {
                        let jsonData: AnyObject = data.result.value! as AnyObject
                        
                        self.sourceController = aOwner
                        self.sourceSelector = aSel
                        
                        aOwner.perform(aSel, with: jsonData)

                    } else if data.response?.statusCode == 401 {/*
                        let alert = UIAlertController(title: "Session Expired", message: "Please login again to get new session.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                            if let navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                                navVC.popToRootViewController(animated: true)
                            }
                        }))*/
                    } else {
                        var strMessage : String
                        if  let msg = (data.result.value! as! NSDictionary).value(forKey: "error") {
                            strMessage = "\(msg)"
                        }
                        else if let msg = (data.result.value! as! NSDictionary).value(forKey: "message") {
                            strMessage = "\(msg)"
                        }
                        else {
                            strMessage = "Something went wrong"
                        }
                        
                        CommonMethods.sharedInstance.displayAlert(Constants.kAppName, message: strMessage , delegate: nil, cancelButtonTitle: Constants.kOk, presentingController: aOwner)
                        aOwner.perform(aSel, with: nil)
                    }
                    
                } else {
                    self.isFailure = true
                    aOwner.perform(aSel, with: nil)
                }
                }
                .responseString { response in
                    self.sourceController = aOwner
                    self.sourceSelector = aSel
                    print("Response Error: \(response.result.error)")
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
            }
        }
        else {
            self.isFailure = true
            aOwner.perform(aSel, with: nil)
        }
        
    }
}
