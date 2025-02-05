import Foundation
import Primitives
import BigInt

public typealias ChainServiceable = ChainBalanceable &
    ChainBroadcastable &
    ChainTransactionPreloadable &
    ChainFeeCalculateable &
    ChainTransactionStateFetchable &
    ChainSyncable &
    ChainStakable &
    ChainTokenable

public protocol ChainBalanceable {
    func coinBalance(for address: String) async throws -> AssetBalance
    func tokenBalance(for address: String, tokenIds: [AssetId]) async throws -> [AssetBalance]
}

public protocol ChainFeeCalculateable {
    func fee(input: FeeInput) async throws -> Fee
}

public protocol ChainTransactionPreloadable {
    func load(input: TransactionInput) async throws -> TransactionPreload
}

public protocol ChainBroadcastable {
    func broadcast(data: String, options: BroadcastOptions) async throws -> String
}

public protocol ChainTransactionStateFetchable {
    func transactionState(for id: String, senderAddress: String) async throws -> TransactionChanges
}

public protocol ChainSyncable {
    func getInSync() async throws -> Bool
}

public protocol ChainStakable {
    func getValidators(apr: Double) async throws -> [DelegationValidator]
    func getStakeDelegations(address: String) async throws -> [DelegationBase]
}

public protocol ChainTokenable {
    func getTokenData(tokenId: String) async throws -> Asset
    func getIsTokenAddress(tokenId: String) -> Bool
}

extension ChainTokenable {
    public func getTokenData(tokenId: String) async throws -> Asset {
        throw AnyError("Not Implemented")
    }
}
