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
                HStack{
                    Text("Activity")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    

                    
                    Button(action: {
                        print("Button tapped")
                    }) {
                        Image(systemName: "pencil.and.outline")
                            .font(.system(size:24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 44)
                    }
                    .buttonStyle(.glass)
                    
                    Button(action: {
                        print("Button tapped")
                    }) {
                        Image(systemName: "calendar")
                            .font(.system(size:24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 44)
                    }
                    .buttonStyle(.glass)
                    
                    
                    
                                    } //Hstack
                
                Text("Thursday , 24 October") //Use the Foundation Calander
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
            }//Vstack
            
        }//Zstack
                
                
            }
            
            
        }
        
        
        
        
        
        
        
        
        
    


#Preview {
    Default_ActivityPage()
}
