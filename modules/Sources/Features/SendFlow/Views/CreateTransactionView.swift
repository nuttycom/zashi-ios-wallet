import SwiftUI
import ComposableArchitecture
import Generated
import UIComponents
import Utils

public struct CreateTransaction: View {
    let store: SendFlowStore
    let tokenName: String

    public init(store: SendFlowStore, tokenName: String) {
        self.store = store
        self.tokenName = tokenName
    }

    public var body: some View {
        UITextView.appearance().backgroundColor = .clear

        return WithViewStore(store) { viewStore in
            VStack(spacing: 5) {
                VStack(spacing: 0) {
                    BalanceTitle(balance: viewStore.shieldedBalance.data.verified)
                }
                .foregroundColor(Asset.Colors.primary.color)
                .padding(.horizontal)

                VStack(alignment: .leading) {
                    TransactionAddressTextField(
                        store: store.scope(
                            state: \.transactionAddressInputState,
                            action: SendFlowReducer.Action.transactionAddressInput
                        )
                    )
                    
                    if viewStore.isInvalidAddressFormat {
                        Text(L10n.Send.Error.invalidAddress)
                            .foregroundColor(Asset.Colors.error.color)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)

                VStack(alignment: .leading) {
                    TransactionAmountTextField(
                        store: store.scope(
                            state: \.transactionAmountInputState,
                            action: SendFlowReducer.Action.transactionAmountInput
                        ),
                        tokenName: tokenName
                    )

                    if viewStore.isInvalidAmountFormat {
                        Text(L10n.Send.Error.invalidAmount)
                            .foregroundColor(Asset.Colors.error.color)
                    } else if viewStore.isInsufficientFunds {
                        Text(L10n.Send.Error.insufficientFunds)
                            .foregroundColor(Asset.Colors.error.color)
                    }
                }
                .padding(.horizontal)

                Button {
                    viewStore.send(.updateDestination(.memo))
                } label: {
                    Text(
                        viewStore.memoState.textLength > 0 ?
                        L10n.Send.editMemo
                        : L10n.Send.includeMemo
                    )
                    .foregroundColor(Asset.Colors.primary.color)
                }
                .padding(.top, 10)
                .disabled(!viewStore.isMemoInputEnabled)

                Button(
                    action: { viewStore.send(.sendPressed) },
                    label: { Text(L10n.General.send.uppercased()) }
                )
                .zcashStyle()
                .disabled(!viewStore.isValidForm)
                .padding(.top, 10)
                .padding(.horizontal, 70)

                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Previews

struct Create_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StateContainer(
                initialState: ( false )
            ) { _ in
                CreateTransaction(store: .placeholder, tokenName: "ZEC")
            }
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.light)
        }
    }
}
