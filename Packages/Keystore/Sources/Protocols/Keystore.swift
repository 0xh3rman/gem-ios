import Foundation
import Primitives
import SwiftUI

public protocol Keystore: ObservableObject {
    var directory: URL { get }
    var currentWallet: Primitives.Wallet? { get }
    func setCurrentWallet(wallet: Primitives.Wallet?)
    var wallets: [Wallet] { get }
    func createWallet() -> [String]
    @discardableResult
    func importWallet(name: String, type: KeystoreImportType) throws -> Wallet
    func setupChains(chains: [Chain]) throws
    func renameWallet(wallet: Wallet, newName: String) throws
    func deleteWallet(for wallet: Wallet) throws
    func getNextWalletIndex() throws -> Int
    func getPrivateKey(wallet: Wallet, chain: Chain) throws -> Data
    func getMnemonic(wallet: Wallet) throws -> [String]
    func getPasswordAuthentication() throws -> KeystoreAuthentication
    func sign(wallet: Wallet, message: SignMessage, chain: Chain) throws -> Data
    func destroy() throws
}

public enum KeystoreImportType {
    case phrase(words: [String], chains: [Chain])
    case single(words: [String], chain: Chain)
    case address(chain: Chain, address: String)
}
