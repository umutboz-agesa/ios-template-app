//
//  StartLoginMapper.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 24.07.2026.
//
import Foundation
 
/// boş `name`, "tanınmıyor" (`nil`) anlamına gelir.
extension StartLoginResponseDTO {
    func toDomain() -> RecognizedUser? {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return nil }
        return RecognizedUser(
            firstName: trimmedName,
            lastName: surname.trimmingCharacters(in: .whitespaces)
        )
    }
}
