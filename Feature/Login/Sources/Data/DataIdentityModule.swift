//
//  DataIdentityModule.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 4.08.2026.
//
import Foundation
import CoreSession
import DataNetwork

public enum DataIdentityModule {
    public static func makeRepository(
        client: HTTPClient,
        session: any SessionManaging
    ) -> any AuthRepository {
        AuthRepositoryImpl(
            remote: AuthRemoteDataSource(api: AuthApi(client: client)),
            session: session
        )
    }
    
    public static func makeLoginRegistrationRepository(
        client: HTTPClient
    ) -> any LoginRegistrationRepository {
        LoginRegistrationRepositoryImpl(
            remote: LoginRegistrationRemoteDataSource(api: LoginRegistrationApi(client: client))
        )
    }
    
    public static func makeOtpConfirmationRepository(client: HTTPClient) -> any OtpConfirmationRepository {
        OtpConfirmationRepositoryImpl(
            remote: OtpConfirmationRemoteDataSource(api: OtpConfirmationApi(client: client))
        )
    }
    
    public static func makeStartLoginRepository(client: HTTPClient) -> any StartLoginRepository {
        StartLoginRepositoryImpl(
            remote: StartLoginRemoteDataSource(api: StartLoginApi(client: client))
        )
    }
}
