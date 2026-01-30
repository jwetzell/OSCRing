import F53OSC

class OSCServer: NSObject, F53OSCServerDelegate {
    
    private var server: F53OSCServer = F53OSCServer()
    private var callManager: CallManager = CallManager()
    func take(_ message: F53OSCMessage?) {
        let address = message?.addressPattern ?? ""
        print("address \(address)")
        if address == "/call/incoming" {
            // TODO(jwetzell): make handle configurable from incoming message
            callManager.reportIncomingCall(uuid: UUID(), handle: "+12345678910")
        }
    }
    
    
    override init(){
        super.init()
        self.server.delegate = self
        // TODO(jwetzell): make port configurable
        self.server.port = 8080
    }
    
    func start(){
        self.server.startListening()
    }
    
    func stop(){
        self.server.stopListening()
    }
}
