//
//  AddressViewModel.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import Foundation

final class AddressViewModel: ObservableObject {
    private let authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol
    @Published var fullname: String = ""
    @Published var country: String = ""
    @Published var city: String = ""
    @Published var street: String = ""
    @Published var postalCode: String = ""
    @Published var addresses: [Address] = []
    
    init(authenticatedRequestHandler: AuthenticatedRequestHandlerProtocol = AuthenticatedRequestHandler()) {
        self.authenticatedRequestHandler = authenticatedRequestHandler
    }
    
    func fetchAddresses() async throws {
        let url = "https://api.gargar.dev:8088/Shipping"
        
        let response: [Address]? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        guard let addressesResponse = response else {
            fatalError("Failed to fetch payment methods: No data received.")
        }
        
        await MainActor.run {
            addresses = addressesResponse
        }
    }
    
    func addAddress() async throws {
        let url = "https://api.gargar.dev:8088/Shipping"
        
        try validateAddress()
        
        let requestBody: [String: String] = [
            "fullname": fullname,
            "street": street,
            "city": city,
            "country": country,
            "postalCode": postalCode,
        ]
        
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            throw AddressValidationError.invalidRequestData
        }
        
        let _: Address? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
        
        await MainActor.run() {
            fullname = ""
            street = ""
            city = ""
            country = ""
            postalCode = ""
        }
    }
    
    func removeAddress(with id: String) async throws {
        let url = "https://api.gargar.dev:8088/Shipping/\(id)"
        
        let _: Address? = try await authenticatedRequestHandler.sendRequest(urlString: url, method: .delete, headers: nil, body: nil, decoder: JSONDecoder())
        
    }
    
    private func validateAddress() throws {
        if fullname.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidFullName
        }
        if country.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidCountry
        }
        if city.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidCity
        }
        if street.trimmingCharacters(in: .whitespaces).isEmpty {
            throw AddressValidationError.invalidStreet
        }
        if postalCode.trimmingCharacters(in: .whitespaces).isEmpty || !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: postalCode)) {
            throw AddressValidationError.invalidPostalCode
        }
    }
}
