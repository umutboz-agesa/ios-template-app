//
//  OtpConfirmationRequestDTO.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation

struct OtpConfirmationRequestDTO: Encodable, Sendable {
    let uuid: String
    let confirmationCode: String
    let source: Int8
    let pushToken: String
}

/// Not: `customData` artık paylaşılan `AuthenticationCustomDataDTO` (bkz.
/// AuthenticationDTOs.swift) — login ile birebir aynı şema, ayrı tip tutmaya gerek yoktu.
struct OtpConfirmationResponseDTO: Decodable, Sendable {
    let success: Bool
    let message: String?
    let error: String?
    let customData: AuthenticationCustomDataDTO?
}
