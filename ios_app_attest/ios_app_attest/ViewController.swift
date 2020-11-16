import UIKit
import DeviceCheck

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = DCAppAttestService.shared
        if service.isSupported {
            print("Service supported")
        
            service.generateKey { keyId, error in
                guard error == nil else {
                    return                   
                }
                // Cache keyId for subsequent operations.
            }
        }
    }
}

