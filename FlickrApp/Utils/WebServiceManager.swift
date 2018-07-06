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
                        aOwner.perform(aSel, with: jsonData)
                        
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
                    //aOwner.perform(aSel, with: nil)
                }
            }
        }
        else
        {
            self.isFailure = true
            aOwner.perform(aSel, with: nil)
        }
    }
}
