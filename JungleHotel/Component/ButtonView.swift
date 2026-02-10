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
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
//                .padding(.horizontal, 24)
                .padding(.vertical, 14)
//                .frame(height: 30)
                .background(Colors.primary)
                .cornerRadius(24)
        }//close btn
        .buttonStyle(.plain)
            
    }
}

#Preview {
    ButtonCompView(textBtn:"")
}
