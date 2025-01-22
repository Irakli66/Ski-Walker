//
//  OrderPaymentsView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 22.01.25.
//

import SwiftUI

struct OrderPaymentsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Payment Method")
                .font(.system(size: 16, weight: .bold))
            HStack(alignment: .center) {
                Image(systemName: "creditcard")
                    .foregroundStyle(Color.customPurple)
                    .font(.system(size: 24))
                VStack(alignment: .leading) {
                    Text("Credit Cart")
                        .font(.system(size: 13, weight: .regular))
                    Text("4567 **** **** 657")
                        .font(.system(size: 13, weight: .regular))
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OrderPaymentsView()
}
