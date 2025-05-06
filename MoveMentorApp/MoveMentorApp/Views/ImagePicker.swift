import SwiftUI
import UIKit

struct ProfileImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: Image?
    @EnvironmentObject var session: UserSession  // To store raw UIImage

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ProfileImagePicker

        init(_ parent: ProfileImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let uiImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
                parent.session.rawProfileUIImage = uiImage  // Save for upload
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
