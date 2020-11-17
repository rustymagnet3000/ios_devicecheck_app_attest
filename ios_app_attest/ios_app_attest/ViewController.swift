import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let attest = AppAttest(){
            print(attest.keyIdentifier())
            attest.preAttestation()
        }
    }
}

