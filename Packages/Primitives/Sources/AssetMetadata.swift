/*
 Generated by typeshare 1.7.0
 */

import Foundation

public struct AssetMetaData: Codable {
	public let isEnabled: Bool
	public let isBuyEnabled: Bool
	public let isSwapEnabled: Bool
	public let isStakeEnabled: Bool

	public init(isEnabled: Bool, isBuyEnabled: Bool, isSwapEnabled: Bool, isStakeEnabled: Bool) {
		self.isEnabled = isEnabled
		self.isBuyEnabled = isBuyEnabled
		self.isSwapEnabled = isSwapEnabled
		self.isStakeEnabled = isStakeEnabled
	}
}
