//
//  ContentView.swift
//  BowCats
//
//  Created by Amanda Chaudhary on 11/15/20.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    
    @ObservedObject var viewModel: CatViewModel = CatViewModel()

    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(alignment: .top) {
                Button(action: {
                    viewModel.nextCatImage()
                }) {
                    Image("kitty").renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 48, height: 48, alignment: .center)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Button(action: {
                    
                }) {
                    Image("camera").renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 48, height: 48, alignment: .center)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            
            .background(Color.init(red: 0.294, green: 0, blue: 0.51, opacity: 1))
            if let image = viewModel.state.image {
                Image(uiImage:image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .colorMultiply (Color.init(red: viewModel.state.red,
                                               green: viewModel.state.green,
                                               blue: viewModel.state.blue,
                                               opacity: 1))
            } else {
               Image("kitty")
                   .resizable()
                   .scaledToFit()
                   .frame(maxWidth: .infinity)
                   .frame(maxHeight: .infinity)
                   .colorMultiply (Color.init(red: viewModel.state.red,
                                        green: viewModel.state.green,
                                        blue: viewModel.state.blue,
                                        opacity: 1))            }
            Slider(value: $viewModel.state.red)
            Slider(value: $viewModel.state.green)
            Slider(value: $viewModel.state.blue)
            Spacer()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
