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
    }
    
    func start(port: UInt16){
        print("OSC Server starting on port \(port)")
        self.server.port = port
        self.server.startListening()
    }
    
    func stop(){
        print("OSC Server stopped")
        self.server.stopListening()
    }
}
