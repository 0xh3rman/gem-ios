// Copyright (c). Gem Wallet. All rights reserved.

import Foundation
import WalletConnector
import Keystore
import Store
import Primitives
import BigInt

public class WalletConnectorSigner: WalletConnectorSignable {    
    let store: ConnectionsStore
    let keystore: any Keystore
    var walletConnectorInteractor: WalletConnectorInteractable
    
    init(
        store: ConnectionsStore,
        keystore: any Keystore,
        walletConnectorInteractor: WalletConnectorInteractable
    ) {
        self.store = store
        self.keystore = keystore
        self.walletConnectorInteractor = walletConnectorInteractor
    }
    
    var currentWallet: Wallet {
        return keystore.currentWallet!
    }
    
    public func getWallet() throws -> Wallet {
        return currentWallet
    }

    public func getChains() -> [Primitives.Chain] {
        let chains = [
            Chain.ethereum,
            Chain.smartChain,
            Chain.opBNB,
            Chain.base,
            Chain.avalancheC,
            Chain.polygon,
            Chain.arbitrum,
            Chain.optimism,
            Chain.fantom,
            Chain.gnosis,
            Chain.solana,
            Chain.manta,
            Chain.blast,
        ]
        return currentWallet.accounts.map { $0.chain }.asSet().intersection(chains).asArray()
    }
    
    public func getAccounts() throws -> [Primitives.Account] {
        return currentWallet.accounts
    }
    
    public func getEvents() throws -> [WalletConnectionEvents] {
        return WalletConnectionEvents.allCases
    }
    
    public func getMethods() throws -> [WalletConnectionMethods] {
        return WalletConnectionMethods.allCases
    }
    
    public func sessionApproval(payload: WalletConnectionSessionProposal) async throws -> Bool {
        return try await walletConnectorInteractor.sessionApproval(payload: payload)
    }
    
    public func signMessage(sessionId: String, chain: Chain, message: SignMessage) async throws -> String {
        let session = try store.getConnection(id: sessionId)
        let payload = SignMessagePayload(chain: chain, session: session.session, wallet: session.wallet, message: message)
        return try await walletConnectorInteractor.signMessage(payload: payload)
    }
    
    public func updateSessions(sessions: [WalletConnectionSession]) throws {
        if sessions.isEmpty {
            try? self.store.deleteAll()
        } else {
            let newSessionIds = sessions.map { $0.id }.asSet()
            let sessionIds = try self.store.getSessions().filter { $0.state == .active }.map { $0.id }.asSet()
            let deleteIds = sessionIds.subtracting(newSessionIds).asArray()

            try? self.store.delete(ids: deleteIds)

            for session in sessions {
                try? self.store.updateConnectionSession(session)
            }
        }
    }
    
    public func sessionReject(id: String, error: Error) throws {
        try self.store.delete(ids: [id])
        walletConnectorInteractor.sessionReject(error: error)
    }
    
    public func signTransaction(sessionId: String, chain: Chain, transaction: WalletConnectorTransaction) async throws -> String {
        throw AnyError("Not supported yet")
    }
    
    public func sendTransaction(sessionId: String, chain: Chain, transaction: WalletConnectorTransaction) async throws -> String {
        let session = try store.getConnection(id: sessionId)
        switch transaction {
        case .ethereum(let transaction):
            let address = transaction.to
            let value = try BigInt.fromHex(transaction.value ?? .zero)
            let gasLimit: BigInt? = {
                if let value = transaction.gasLimit {
                    return BigInt(hex: value)
                } else if let gas = transaction.gas {
                    return BigInt(hex: gas)
                }
                return .none
            }()
            
            let gasPrice: GasPriceType? = {
                if let maxFeePerGas = transaction.maxFeePerGas,
                   let maxPriorityFeePerGas = transaction.maxPriorityFeePerGas,
                   let maxFeePerGasBigInt = BigInt(hex: maxFeePerGas),
                   let maxPriorityFeePerGasBigInt = BigInt(hex: maxPriorityFeePerGas)
                {
                    return .eip1559(gasPrice: maxFeePerGasBigInt, minerFee: maxPriorityFeePerGasBigInt)
                }
                return .none
            }()
            let data: Data? = {
                if let data = transaction.data {
                    return Data(hex: data)
                }
                return .none
            }()
            
            let transferData = TransferData(
                type: .generic(asset: chain.asset, metadata: session.session.metadata, extra: TransferDataExtra(
                    gasLimit: gasLimit,
                    gasPrice: gasPrice,
                    data: data
                )),
                recipientData: RecipientData(
                    asset: chain.asset,
                    recipient: Recipient(name: .none, address: address, memo: .none)
                ),
                value: value
            )
            
            return try await walletConnectorInteractor.sendTransaction(transferData: transferData)
        case .solana(let data):
            let transferData = TransferData(
                type: .generic(asset: chain.asset, metadata: session.session.metadata, extra: TransferDataExtra(data: data.data(using: .utf8))),
                recipientData: RecipientData(
                    asset: chain.asset,
                    recipient: Recipient(name: .none, address: "", memo: .none)
                ),
                value: .zero
            )
            return try await walletConnectorInteractor.sendTransaction(transferData: transferData)
        }
    }
    
    public func sendRawTransaction(sessionId: String, chain: Chain, transaction: String) async throws -> String {
        throw AnyError("Not supported yet")
    }
}
