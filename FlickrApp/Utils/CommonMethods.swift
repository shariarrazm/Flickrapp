
import Foundation
import UIKit
import CoreTelephony

class CommonMethods {
    
    
    //Singleton instance of the class.
    static let sharedInstance = CommonMethods()
    
    var viewController:UIViewController?

    func displayAlert(message andMessage:String, cancelButtonTitle andCancelButtonTitle:String,presentingController aOwner:AnyObject) {
        let alert:UIAlertController = UIAlertController.init(title: Constants.kAppName, message: andMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: andCancelButtonTitle, style: UIAlertActionStyle.default, handler:nil))
        aOwner.present(alert, animated: true, completion: nil)
    }
    func showLoader(_ controller:UIViewController,strMsg: String) {
        viewController = controller
        SwiftLoader.show(title: strMsg, animated: true)
    }
    func removeLoader(_ controller:UIViewController) {
        SwiftLoader.hide()
    }
}

