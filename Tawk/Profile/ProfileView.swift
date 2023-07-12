//
//  ProfileView.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import SwiftUI
import Combine

struct ProfileView<ViewModel: ProfileViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var notes: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var keyboardHeight: CGFloat = 0 // Track the height of the keyboard
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isNavigationBarHidden = false
    
    var onDismiss: (() -> Void)?
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    AvatarHeaderView(profileData: viewModel.profileData)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    InformationView(profileData: viewModel.profileData)
                        .padding(.bottom, 10)
                    
                    Text("Notes")
                        .font(.headline)
                    
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding([.leading, .trailing], 8)
                        .onChange(of: viewModel.profileData?.note) { value in
                            if let note = value {
                                notes = note
                            }
                        }
                }
                
                Button(action: saveNotes) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .background(Color(.systemBackground))
            .onAppear {
                // Subscribe to the keyboardWillShow notification
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                    .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                    .sink { keyboardFrame in
                        isNavigationBarHidden = true
                        keyboardHeight = keyboardFrame.height
                    }
                    .store(in: &cancellables)
                
                // Subscribe to the keyboardWillHide notification
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                    .sink { _ in
                        isNavigationBarHidden = false
                        keyboardHeight = 0
                    }
                    .store(in: &cancellables)
                viewModel.startObservingNetworkChanges()
                viewModel.getData()
            }
            .onDisappear {
                viewModel.stopObservingNetworkChanges()
                onDismiss?()
                cancellables.removeAll()
            }
            .gesture(
                // Dismiss the keyboard when tapping outside the text input area
                TapGesture()
                    .onEnded { _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
            .alert(item: $viewModel.onError) { currentAlert in
                Alert(
                    title: Text("Error"),
                    message: Text(currentAlert.errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .modifier(KeyboardAwareModifier(offset: keyboardHeight))
        }
        .navigationTitle(viewModel.profileData?.name ?? "")
        .navigationBarHidden(isNavigationBarHidden)
    }
    
    
    func saveNotes() {
        // Implement your save notes logic here
        guard let profileData = viewModel.profileData, let login = profileData.login else {
            return
        }
        
        var updatedProfile = profileData
        updatedProfile.note = notes
        
        if let existingUser = viewModel.coreDataHelper.getUser(withLogin: login) {
            existingUser.note = notes
            viewModel.coreDataHelper.updateUser(withLogin: login, newData: UserEntityElement(user: existingUser))
        }
        
        viewModel.coreDataHelper.updateProfile(withLogin: login, newData: updatedProfile)
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardOffset: CGFloat = 0
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardOffset)
            .animation(.easeOut(duration: 0.25))
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size
                    keyboardOffset = (keyboardSize?.height ?? 0) - (offset + 200)
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    keyboardOffset = 0
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self)
            }
    }
}

struct AvatarHeaderView: View {
    var profileData: ProfileEntity?
    
    var body: some View {
        VStack(spacing: 10) {
            if let avatarURL = profileData?.avatarURL {
                RemoteImage(urlString: avatarURL)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
            } else {
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
            }
            
            Text(profileData?.name ?? "")
                .font(.title)
                .bold()
            
            HStack {
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(profileData?.followers ?? 0)")
                        .font(.headline)
                        .bold()
                    
                    Text("Followers")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(profileData?.following ?? 0)")
                        .font(.headline)
                        .bold()
                    
                    Text("Following")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .background(Color(.systemGray5))
            .cornerRadius(10)
        }
        
        .padding()
    }
    
}

struct InformationView: View {
    var profileData: ProfileEntity?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            InfoRow(label: "Company", value: profileData?.company ?? "")
            InfoRow(label: "Blog", value: profileData?.blog ?? "")
        }
        .font(.body)
    }
}

struct InfoRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
        }
    }
}
