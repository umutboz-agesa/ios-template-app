//
//  DataPlatformModule.swift
//  iOSTemplate
//
//  Created by AVS21862 on 22.07.2026.
//
import Foundation
import DataNetwork

/// Data'nın kompozisyon kapısı (`AuthModule` kalıbı).
/// App composition root, HTTPClient'ı kurup buradan repository üretir ve
/// `DependencyValues.versionRepository`'ye bağlar (Android `@Binds` + Hilt `@Module`).
public enum DataPlatformModule {
    public static func makeVersionRepository(client: HTTPClient) -> any VersionRepository {
        VersionRepositoryImpl(remote: VersionRemoteDataSource(api: VersionApi(client: client)))
    }
}
