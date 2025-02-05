/*
 Generated by typeshare 1.7.0
 */

import Foundation

public struct ConfigAppVersion: Codable {
	public let production: String
	public let beta: String
	public let alpha: String

	public init(production: String, beta: String, alpha: String) {
		self.production = production
		self.beta = beta
		self.alpha = alpha
	}
}

public struct ConfigIOSApp: Codable {
	public let version: ConfigAppVersion

	public init(version: ConfigAppVersion) {
		self.version = version
	}
}

public struct ConfigAndroidApp: Codable {
	public let version: ConfigAppVersion

	public init(version: ConfigAppVersion) {
		self.version = version
	}
}

public struct ConfigApp: Codable {
	public let ios: ConfigIOSApp
	public let android: ConfigAndroidApp

	public init(ios: ConfigIOSApp, android: ConfigAndroidApp) {
		self.ios = ios
		self.android = android
	}
}

public struct ConfigVersions: Codable {
	public let nodes: Int32
	public let fiatAssets: Int32
	public let swapAssets: Int32

	public init(nodes: Int32, fiatAssets: Int32, swapAssets: Int32) {
		self.nodes = nodes
		self.fiatAssets = fiatAssets
		self.swapAssets = swapAssets
	}
}

public struct ConfigResponse: Codable {
	public let app: ConfigApp
	public let versions: ConfigVersions

	public init(app: ConfigApp, versions: ConfigVersions) {
		self.app = app
		self.versions = versions
	}
}
