//
//  ProfilePhotoView.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 3.09.2026.
//
import SwiftUI
import PhotosUI
import DesignSystem

/// LinkedIn tarzı ayarlanabilir profil fotoğrafı modülü (demo, backend'siz).
/// Foto @AppStorage'da base64 JPEG olarak saklanır → kalıcı, oturumlar arası kalır.
enum ProfilePhotoStore {
    static let key = "profile_photo_b64"
    static func image(_ b64: String) -> UIImage? {
        guard !b64.isEmpty, let data = Data(base64Encoded: b64) else { return nil }
        return UIImage(data: data)
    }
}

/// Header'daki dairesel avatar + kamera rozeti. Tıklayınca düzenleyici açılır.
struct ProfileAvatarButton: View {
    var size: CGFloat = 88
    @AppStorage(ProfilePhotoStore.key) private var photoB64 = ""
    @State private var showEditor = false

    var body: some View {
        Button { showEditor = true } label: {
            ZStack(alignment: .bottomTrailing) {
                avatar
                Image(systemName: "camera.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(SabancimTheme.Colors.primary)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(SabancimTheme.Colors.cardSurface, lineWidth: 2))
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showEditor) {
            ProfilePhotoEditorSheet(photoB64: $photoB64)
        }
    }

    @ViewBuilder private var avatar: some View {
        if let ui = ProfilePhotoStore.image(photoB64) {
            Image(uiImage: ui)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(SabancimTheme.Colors.primary.opacity(0.2), lineWidth: 1))
        } else {
            Image("maleUserAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

/// Foto seç + dairesel kırpma (yakınlaştır/kaydır) + kaydet — LinkedIn benzeri.
struct ProfilePhotoEditorSheet: View {
    @Binding var photoB64: String
    @Environment(\.dismiss) private var dismiss

    @State private var pickerItem: PhotosPickerItem?
    @State private var picked: UIImage?

    // Kırpma jest durumu
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    private let cropSize: CGFloat = 300

    var body: some View {
        VStack(spacing: SabancimTheme.Spacing.lg) {
            header
            Spacer(minLength: 0)
            if let picked {
                cropArea(picked)
                Text("Yakınlaştırmak için iki parmakla sık, konumlandırmak için sürükle.")
                    .font(.caption)
                    .foregroundStyle(SabancimTheme.Colors.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SabancimTheme.Spacing.lg)
            } else {
                placeholder
            }
            Spacer(minLength: 0)
            controls
        }
        .padding(SabancimTheme.Spacing.md)
        .background { SabancimHeroBackground() }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onChange(of: pickerItem) { _, item in
            guard let item else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let ui = UIImage(data: data) {
                    await MainActor.run {
                        picked = ui
                        scale = 1; lastScale = 1
                        offset = .zero; lastOffset = .zero
                    }
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Button("İptal") { dismiss() }
                .foregroundStyle(SabancimTheme.Colors.muted)
            Spacer()
            Text("Profil Fotoğrafı")
                .font(.headline)
                .foregroundStyle(SabancimTheme.Colors.onSurface)
            Spacer()
            Button("Kaydet") { save() }
                .fontWeight(.semibold)
                .foregroundStyle(picked == nil ? SabancimTheme.Colors.muted : SabancimTheme.Colors.primary)
                .disabled(picked == nil)
        }
    }

    private func cropArea(_ img: UIImage) -> some View {
        Image(uiImage: img)
            .resizable()
            .scaledToFill()
            .scaleEffect(scale)
            .offset(offset)
            .frame(width: cropSize, height: cropSize)
            .clipShape(Circle())
            .overlay(Circle().stroke(.white, lineWidth: 3))
            .overlay(Circle().stroke(SabancimTheme.Colors.primary.opacity(0.35), lineWidth: 1))
            .contentShape(Circle())
            .gesture(
                SimultaneousGesture(
                    MagnifyGesture()
                        .onChanged { v in scale = max(1, min(lastScale * v.magnification, 4)) }
                        .onEnded { _ in lastScale = scale },
                    DragGesture()
                        .onChanged { v in
                            offset = CGSize(width: lastOffset.width + v.translation.width,
                                            height: lastOffset.height + v.translation.height)
                        }
                        .onEnded { _ in lastOffset = offset }
                )
            )
    }

    private var placeholder: some View {
        VStack(spacing: SabancimTheme.Spacing.md) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(SabancimTheme.Colors.primary)
            Text("Bir fotoğraf seç")
                .font(.subheadline)
                .foregroundStyle(SabancimTheme.Colors.muted)
        }
        .frame(width: cropSize, height: cropSize)
    }

    private var controls: some View {
        VStack(spacing: SabancimTheme.Spacing.sm) {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                Label(picked == nil ? "Fotoğraf Seç" : "Farklı Fotoğraf Seç",
                      systemImage: "photo.on.rectangle")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SabancimTheme.Spacing.sm + 4)
                    .background(SabancimTheme.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.button, style: .continuous))
            }
            if !photoB64.isEmpty {
                Button(role: .destructive) { remove() } label: {
                    Text("Fotoğrafı Kaldır")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(SabancimTheme.Brand.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, SabancimTheme.Spacing.sm + 4)
                }
            }
        }
    }

    // MARK: - Kaydet / Kaldır
    @MainActor private func save() {
        guard let picked else { return }
        if let cropped = renderCrop(picked),
           let data = cropped.jpegData(compressionQuality: 0.8) {
            photoB64 = data.base64EncodedString()
        }
        dismiss()
    }

    private func remove() {
        photoB64 = ""
        picked = nil
        dismiss()
    }

    /// Ekrandaki dairesel kırpmayı ImageRenderer ile UIImage'e çevirir.
    @MainActor private func renderCrop(_ img: UIImage) -> UIImage? {
        let content = Image(uiImage: img)
            .resizable()
            .scaledToFill()
            .scaleEffect(scale)
            .offset(offset)
            .frame(width: cropSize, height: cropSize)
            .clipShape(Circle())
        let renderer = ImageRenderer(content: content)
        renderer.scale = 2   // ~600px çıktı
        return renderer.uiImage
    }
}
