// Copyright (c). Gem Wallet. All rights reserved.

import Foundation

enum WalletImportType: String, Hashable, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case phrase = "Phrase"
    case address = "Address"
    
    var field: ImportWalletScene.Field {
        switch self {
        case .phrase:
            return .phrase
        case .address:
            return .address
        }
    }
}

extension WalletImportType: Equatable {
    public static func == (lhs: WalletImportType, rhs: WalletImportType) -> Bool {
        lhs.id == rhs.id
    }
}
