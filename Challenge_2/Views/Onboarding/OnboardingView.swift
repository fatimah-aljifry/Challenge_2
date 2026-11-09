//
//  Onboarding.swift
//  Challenge_2
//
//  Created by Fatimah Aljifry on 28/05/1448 AH.
//

import SwiftUI

struct Onboarding: View {
    @State private var learningGoal = ""
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                
                
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .font(.system(size: 36))
                    .scaleEffect(x: -1, y: 1)
                    .padding(.bottom,50)
                
                
                HStack{
                    Text("Hello")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                    
                    
                    
                    Text("Learner")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                }    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("This app will help you learn everyday!")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .padding(.bottom,30)
                
                
                Text("I want to learn")
                    .font(.default)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField(
                    "",
                    text: $learningGoal,
                    prompt: Text("Swift")
                        .foregroundColor(.gray)
                ).font(.system(size: 20))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.35))
                            .frame(height: 1)
                        
                    }
                
                
                
                Text("I want to learn it in a ")
                    .font(.default)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom,10)
                HStack{
                    Button("Week") {
                        
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.orange)
                    .controlSize(.large)
                    Button("Month"){
                    
                        
                    }
                    .buttonStyle(.glass)
                    .foregroundStyle(.white .opacity(0.3))
                    .controlSize(.large)
                    Button("Year"){
                        
                        
                    }
                    .buttonStyle(.glass)
                    .foregroundStyle(.white .opacity(0.3))
                    .controlSize(.large)
                }                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
                .padding(.bottom,300)
                
                Button("Start Learning"){

                }
                     .buttonStyle(.glassProminent)
                    .font(.title3)
                    .tint(.orange)
                    .fontWeight(.medium)
                    .controlSize(.extraLarge)
                    
                Text("You can edit your desire later")
                    .foregroundStyle(.gray)
                    
                
            
                
            
            
            }
            
            
            
        }
        
    }
}

#Preview {
    Onboarding()
}
