import UIKit
import DeviceCheck



class ViewController: UIViewController {

    fileprivate let keyName = "AppAttestKeyIdentifier"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let service = DCAppAttestService.shared
        if service.isSupported {

            let defaults = UserDefaults.standard

            guard let keyId = defaults.object(forKey:keyName) as? String  else {
                service.generateKey { keyIdentifier, error in
                    guard error == nil else { return }
                    print("🐝 Generated key in Secure Enclave")
                    defaults.set(keyIdentifier, forKey: self.keyName)
                }
                return
            }
            print("🐝 Found key identifier:", keyId)

            

        }
    }
}

