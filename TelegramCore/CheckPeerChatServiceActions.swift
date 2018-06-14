import Foundation
#if os(macOS)
    import PostboxMac
    import SwiftSignalKitMac
#else
    import Postbox
    import SwiftSignalKit
#endif

public func checkPeerChatServiceActions(postbox: Postbox, peerId: PeerId) -> Signal<Void, NoError> {
    return postbox.transaction { transaction -> Void in
        if peerId.namespace == Namespaces.Peer.SecretChat {
            if let state = transaction.getPeerChatState(peerId) as? SecretChatState {
                let updatedState = secretChatCheckLayerNegotiationIfNeeded(transaction: transaction, peerId: peerId, state: state)
                if state != updatedState {
                    transaction.setPeerChatState(peerId, state: updatedState)
                }
            }
        }
    }
}
