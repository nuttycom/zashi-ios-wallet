//
//  BalanceFormatter.swift
//
//
//  Created by Lukáš Korba on 19.10.2023.
//

import Foundation
import ZcashLightClientKit

extension Zatoshi {
    public func decimalZashiFormatted() -> String {
        NumberFormatter.zashiBalanceFormatter.string(from: decimalValue.roundedZec) ?? ""
    }
}
