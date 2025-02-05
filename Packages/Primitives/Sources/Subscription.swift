/*
 Generated by typeshare 1.7.0
 */

import Foundation

public struct Subscription: Codable, Equatable, Hashable {
	public let wallet_index: Int32
	public let chain: Chain
	public let address: String

	public init(wallet_index: Int32, chain: Chain, address: String) {
		self.wallet_index = wallet_index
		self.chain = chain
		self.address = address
	}
}
