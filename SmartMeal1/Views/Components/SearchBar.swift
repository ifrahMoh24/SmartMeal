//
//  SearchBar.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
                TextField("Search recipes or ingredients...", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isFocused)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isEditing = true
                        }
                    }
                
                if !text.isEmpty {
                    Button(action: {
                        withAnimation {
                            text = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: isEditing ? Color.orange.opacity(0.2) : Color.black.opacity(0.05),
                           radius: isEditing ? 10 : 5,
                           x: 0,
                           y: isEditing ? 5 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isEditing ? Color.orange.opacity(0.5) : Color.clear, lineWidth: 2)
            )
            
            if isEditing {
                Button("Cancel") {
                    withAnimation {
                        isEditing = false
                        isFocused = false
                        text = ""
                    }
                }
                .foregroundColor(.orange)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .animation(.spring(), value: isEditing)
    }
}
