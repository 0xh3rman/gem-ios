/*
 Generated by typeshare 1.7.0
 */

import Foundation

public struct CosmosBalance: Codable {
	public let denom: String
	public let amount: String

	public init(denom: String, amount: String) {
		self.denom = denom
		self.amount = amount
	}
}

public struct CosmosBalances: Codable {
	public let balances: [CosmosBalance]

	public init(balances: [CosmosBalance]) {
		self.balances = balances
	}
}
