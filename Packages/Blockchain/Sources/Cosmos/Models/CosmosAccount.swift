/*
 Generated by typeshare 1.7.0
 */

import Foundation

public struct CosmosAccount: Codable {
	public let account_number: String
	public let sequence: String

	public init(account_number: String, sequence: String) {
		self.account_number = account_number
		self.sequence = sequence
	}
}

public struct CosmosAccountResponse<T: Codable>: Codable {
	public let account: T

	public init(account: T) {
		self.account = account
	}
}

public struct CosmosInjectiveAccount: Codable {
	public let base_account: CosmosAccount

	public init(base_account: CosmosAccount) {
		self.base_account = base_account
	}
}
