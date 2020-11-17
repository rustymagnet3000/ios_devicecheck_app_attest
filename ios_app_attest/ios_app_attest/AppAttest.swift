import DeviceCheck
import CryptoKit

final class AppAttest {
    private let keyName = "AppAttestKeyIdentifier"
    private let attestService = DCAppAttestService.shared
    private let userDefaults = UserDefaults.standard
    private var keyID: String? {
        didSet
        {
            print("🐝 Key ID:", keyID!)
        }
    }
    
    init?() {
        
        guard attestService.isSupported == true else {
            print("[!] Attest service not available:")
            return nil
        }
        
        guard let id = userDefaults.object(forKey:keyName) as? String else {
            attestService.generateKey { keyIdentifier, error in
                
                guard error == nil, keyIdentifier == nil else { return }
                self.keyID = keyIdentifier
                if self.keyID != nil {
                    print("🐝 Generated key")
                    self.userDefaults.set(self.keyID, forKey: self.keyName)
                }
                
            }
            return nil
        }
        keyID = id
        
        
    }
    
    func keyIdentifier() -> String {
        return ("🐝 Key Identifier: \(self.keyID ?? "Error in Key ID")")
    }

    // https://developer.apple.com/documentation/devicecheck/dcappattestservice/3573911-attestkey
    // A SHA256 hash of a unique, single-use data block that embeds a challenge from your server.

    func preAttestation() -> Void {
        
        // MARK: get the Session ID from my server ( and not generate it locally )
        let randomSessionID = NSUUID().uuidString
        let challenge = randomSessionID.data(using: .utf8)!
        let hash = Data(SHA256.hash(data: challenge))
        
        /* invokes network call to Apple's attest service */
        attestService.attestKey(self.keyID!, clientDataHash: hash) { attestationObject, error in
            guard error == nil else { return }
            let attestStr = attestationObject?.base64EncodedString()    // Optional<Data>

            print(attestStr ?? "Problem reading ")
        }
    }
}
