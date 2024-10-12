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
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
