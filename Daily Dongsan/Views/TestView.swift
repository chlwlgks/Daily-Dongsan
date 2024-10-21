//
//  TestView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/12/24.
//

import SwiftUI
import FirebaseFirestore

struct TestView: View {
    @State private var db: Firestore = Firestore.firestore()
    
    @State var toggling = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    Toggle(isOn: $toggling) {
                        Text("Toggly")
                    }
                    Button("Save changes") {
                        Task {
                            await getCollection()   
                        }
                    }.disabled(!toggling)
                }
            }.navigationBarTitle(Text("Settings"))
        }
        .onAppear {
            Task {
                await getCollection()
            }
        }
    }
    
    private func getCollection() async {
        let docRef = db.collection("menus").document("2024").collection("10").document("21")
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("document does not exist.")
            }
        } catch {
            print("Error getting document: \(error)")
        }
        
//        db.document("menus/2024/10/21").getDocument() { documentSnapshot, error in
//            if let error {
//                print("dd")
//            } else if let documentSnapshot, documentSnapshot.exists {
//                if let data = documentSnapshot.data() {
//                    print(data)
//                }
//            }
//        }
    }
}

#Preview {
    TestView()
}
