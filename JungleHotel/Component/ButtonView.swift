//
//  ButonComp.swift
//  DataFlowPrac2
//
//  Created by TS2 on 10/6/25.
//

import SwiftUI

struct ButtonCompView: View {
    var textBtn: String
    var action: () -> Void = { }
    var body: some View {
    
        Button(action: {
          action()
        }) {
            Text(textBtn)
                .foregroundColor(.white)
              
                .frame(maxWidth: .infinity, alignment: .center)
//                .padding(.horizontal, 24)
                .padding(.vertical, 16)
//                .frame(height: 50)
                .background(
                    Capsule()
                        .fill(Color.green)
                )
        }//close btn
        .buttonStyle(.plain)
            
    }
}

#Preview {
    ButtonCompView(textBtn:"")
}
