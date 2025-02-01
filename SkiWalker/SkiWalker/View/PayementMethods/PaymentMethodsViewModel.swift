//
//  PaymentMethodsViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import SwiftUI
import NetworkPackage

final class PaymentMethodsViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    @Published var paymentMethods: [CreditCard] = []
    @Published var fullname: String = ""
    @Published var cardNumber: String = ""
    @Published var cvc: String = ""
    @Published var validThru: String = ""
    private let url = "https://api.gargar.dev:8088/Payment"
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
    }
    
    func fetchPaymentMethods() async throws {
        let response: [CreditCard]? = try await authenticatedRequestHandler.sendRequest(
            urlString: url,
            method: .get,
            headers: nil,
            body: nil,
            decoder: JSONDecoder()
        )
        
        guard let creditCards = response else {
            print("Failed to fetch payment methods: No data received.")
            throw NetworkError.noData
        }
        
        await MainActor.run {
            paymentMethods = creditCards
        }
    }
    
    func addCreditCard() async throws {
        try validateCreditCard()
        
        let requestBody: [String: String] = [
            "cardNumber": cardNumber,
            "cvc": cvc,
            "validThru": validThru,
            "fullname": fullname
        ]
        
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            throw CreditCardValidationErrors.invalidRequestData
        }
        
        let _: CreditCard? = try await authenticatedRequestHandler.sendRequest(
            urlString: url,
            method: .post,
            headers: nil,
            body: bodyData,
            decoder: JSONDecoder()
        )
        await MainActor.run {
            fullname = ""
            cvc = ""
            validThru = ""
            cardNumber = ""
        }
        
    }
    
    func removeCreditCard(with id: String) async throws {
        let urlString = "https://api.gargar.dev:8088/Payment/\(id)"
        
        let _: CreditCard? = try await authenticatedRequestHandler.sendRequest(urlString: urlString, method: .delete, headers: nil, body: nil, decoder: JSONDecoder())
    }
    
    private func validateCreditCard() throws {
        if fullname.trimmingCharacters(in: .whitespaces).count < 2 {
            throw CreditCardValidationErrors.invalidFullName
        }
        
        let cleanedNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        if cleanedNumber.count != 16 || !cleanedNumber.allSatisfy({ $0.isNumber }) {
            throw CreditCardValidationErrors.invalidNumber
        }
        
        let components = validThru.split(separator: "/")
        if components.count == 2,
           let month = Int(components[0]),
           let year = Int(components[1]),
           (1...12).contains(month) {
            
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date()) % 100
            let currentMonth = calendar.component(.month, from: Date())
            
            if year < currentYear || (year == currentYear && month < currentMonth) {
                throw CreditCardValidationErrors.invalidValidThru
            }
        } else {
            throw CreditCardValidationErrors.invalidValidThru
        }
        
        if cvc.count < 3 || cvc.count > 4 || !cvc.allSatisfy({ $0.isNumber }) {
            throw CreditCardValidationErrors.invalidCvc
        }
    }
}
