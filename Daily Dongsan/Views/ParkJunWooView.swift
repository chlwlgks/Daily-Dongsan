//
//  ParkJunWooView.swift
//  Daily Dongsan
//
//  Created by 최지한 on 10/26/24.
//

import SwiftUI

@available(iOS 17, *)
struct ParkJunWooView: View {
    var body: some View {
        NavigationStack {
            let photos = [
                Photo("ParkJunWoo1"),
                Photo("ParkJunWoo2")
            ]
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(photos) { photo in
                        VStack {
                            ZStack {
                                ItemPhoto(photo)
                                    .scrollTransition(axis: .horizontal) { content, phase in
                                        content
                                            .offset(x: phase.isIdentity ? 0 : phase.value * -200)
                                    }
                            }
                            .containerRelativeFrame(.horizontal)
                            .clipShape(RoundedRectangle(cornerRadius: 36))
                        }
                    }
                }
            }
            .contentMargins(32)
            .scrollTargetBehavior(.paging)
            .navigationTitle("박준우")
        }
    }
}

struct Photo: Identifiable {
    var title: String
    
    var id: Int = .random(in: 0 ... 100)
    
    init(_ title: String) {
        self.title = title
    }
}

struct ItemPhoto: View {
    var photo: Photo
    
    init(_ photo: Photo) {
        self.photo = photo
    }
    
    var body: some View {
        Image(photo.title)
            .resizable()
            .scaledToFill()
            .frame(height: 500)
    }
}

#Preview {
    if #available(iOS 17, *) {
        ParkJunWooView()
    }
}
