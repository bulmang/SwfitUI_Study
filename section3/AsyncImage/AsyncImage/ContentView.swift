//
//  ContentView.swift
//  AsyncImage
//
//  Created by 하명관 on 2023/05/30.
//

import SwiftUI

extension Image {
    func imageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
    
    func iconeModifier() -> some View {
        self
            .imageModifier()
            .frame(maxWidth: 128)
            .foregroundColor(.purple)
            .opacity(0.5)
    }
}

struct ContentView: View {
    private let imageURL: String = "https://credo.academy/credo-academy@3x.png"
    
    var body: some View {
        // MARK: - 1. BASIC
        
        //        AsyncImage(url: URL(string: imageURL))
        
        
        // MARK: - 2. SCALE
        //        AsyncImage(url: URL(string: imageURL), scale: 3.0)
        
        // MARK: - 3. PLACEHOLDER
        // image는 클로저 매개변수
        /*
         AsyncImage(url: URL(string: imageURL)) { image in
         image.imageModifier()
         
         } placeholder: {
         Image(systemName: "photo.circle.fill").iconeModifier()
         
         }
         .padding(40)
         */
        // MARK: -4. PHASE(AsyncImage)
        /*
         AsyncImage(url: URL(string: imageURL)) { phase in
         // 성공: 이미지 불러오기 성공
         // 실패: 이미지 불러오기 실패 오류
         // 없음: 불러올 이미지가 없음
         
         if let image = phase.image {
         image.imageModifier()
         } else if phase.error != nil {
         Image(systemName: "ant.circle.fill").iconeModifier()
         } else {
         Image(systemName: "photo.circle.fill").iconeModifier()
         }
         }
         .padding(40)
         */
        // MARK: -5. ANIMATION
        AsyncImage(url: URL(string: imageURL),transaction: Transaction(animation: .spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
            switch phase {
            case .success(let image):
                image
                    .imageModifier()
//                    .transition(.move(edge: .bottom))
//                    .transition(.slide)
                    .transition(.scale)
            case .failure(_):
                Image(systemName: "ant.circle.fill").iconeModifier()
            case .empty:
                Image(systemName: "photo.circle.fill").iconeModifier()
            @unknown default:
                ProgressView()
            }
        }
        .padding(40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
