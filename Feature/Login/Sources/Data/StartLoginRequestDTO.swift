//
//  StartLoginRequestDTO.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 24.07.2026.
//
import Foundation
 
struct StartLoginRequestDTO: Encodable, Sendable {
    let uuid: String
    let brand: String
    let osVersion: String
    let model: String
    let appVersion: String
}

struct StartLoginResponseDTO: Decodable, Sendable {
    let name: String
    let surname: String
}
