//
//  DeliveryDateView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 31.01.25.
//

import SwiftUI

struct DeliveryDateView: View {
    @EnvironmentObject private var checkoutViewModel: CheckoutViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pick delivery date:")
                .font(.system(size: 13, weight: .regular))
            HStack {
                ForEach(checkoutViewModel.deliveryDates, id: \.self) { date in
                    VStack {
                        Text(checkoutViewModel.formatDateToDayAndMonth(date))
                            .foregroundStyle(date == checkoutViewModel.selectedDate ? Color.customWhite : Color.customPurple)
                            .font(.system(size: 13, weight: .regular))
                        Text("FREE")
                            .foregroundStyle(Color.green)
                            .font(.system(size: 13, weight: .regular))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(date == checkoutViewModel.selectedDate ? Color.customPurple : Color.customWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .onTapGesture {
                        checkoutViewModel.selectedDate = date
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    DeliveryDateView()
}
