import CallKit
import AVFAudio

class CallManager: NSObject, CXProviderDelegate {
    
    
    var provider: CXProvider?

    override init() {
        super.init()
        let configuration = CXProviderConfiguration()
        configuration.supportsVideo = false
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportedHandleTypes = [.phoneNumber]

        provider = CXProvider(configuration: configuration)
        provider?.setDelegate(self, queue: nil)
    }

    func reportIncomingCall(uuid: UUID, handle: CXHandle) {
        let update = CXCallUpdate()
        update.remoteHandle = handle
        update.hasVideo = false

        provider?.reportNewIncomingCall(with: uuid, update: update, completion: { error in
            if let error = error {
                print("incoming call failed: \(error.localizedDescription)")
            } else {
                print("incoming call reported")
            }
        })
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("Call answered")
        // TODO(jwetzell): do something?
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("Call ended")
        // TODO(jwetzell): do something?
        action.fulfill()
    }
    
    func providerDidReset(_ provider: CXProvider) {
        print("provider reset")
        // what does this mean?
    }
}
