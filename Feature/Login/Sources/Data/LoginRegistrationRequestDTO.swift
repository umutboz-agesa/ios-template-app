//
//  LoginRegistrationRequestDTO.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
 
/// Eski VIPER'daki `LoginRegistrationParameter` karşılığı.
struct LoginRegistrationRequestDTO: Encodable, Sendable {
    let uuid: String
    let identityNo: String
    let password: String
    let brand: String
    let model: String
    let osVersion: String
    let contractTextReaded: Bool
    let appVersion: String
}
 
struct LoginRegistrationResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String?
    let error: String?
}
