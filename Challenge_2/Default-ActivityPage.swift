//
//  Default-ActivityPage.swift
//  Challenge_2
//
//  Created by Fatimah Aljifry on 29/05/1448 AH.
//

import SwiftUI

struct Default_ActivityPage: View {
    var body: some View {
      
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            
            VStack{
                
               Text("Activity")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Thursday , 24 October") //Use the Foundation Calander
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                
                
            }
            
            
        }
        
        
        
        
        
        
        
        
        
    }
}

#Preview {
    Default_ActivityPage()
}
