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
                        print("Saved")
                    }.disabled(!toggling)
                }
            }.navigationBarTitle(Text("Settings"))
        }
        .onAppear {
            setupFirestore()
            Task {
                await getCollection()
            }
        }
    }
    
    private func setupFirestore() {
        let settings = FirestoreSettings()
        db.settings = settings
    }
    
    private func getCollection() async {
        do {
            let snapshot = try await db.collection("menus").getDocuments()
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
        } catch {
            print("문서를 가져오는 중 오류 발생: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TestView()
}
