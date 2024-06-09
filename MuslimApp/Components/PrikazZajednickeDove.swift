//
//  PrikazZajednickeDove.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 03.06.24.
//

import SwiftUI

struct PrikazZajednickeDove: View {
    let idZajednickeDove: Int
    let dova: String
    let brojLajkova: Int
    @State private var isLiked = false
    var lajkovanjeAction: ((Int, Bool) -> Void)?

    
    var body: some View {
        ScrollView {
            Group {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Biege").opacity(0.9))
                    .frame(height: 200)
                    .frame(width: .infinity)
                    .padding()
                    .cornerRadius(70)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    .overlay {
                        VStack(alignment: .leading) {
                            Text(dova)
                                .padding(.all)
                                .font(.body)
                                .padding(.all)
                                .lineLimit(3)
                            
                            HStack {
                                
                                HStack {
                                    Image(systemName: isLiked ? "heart.fill" : "heart")
                                        .font(.title)
                                        .foregroundColor(Color("DarkGreen"))
                                        .onTapGesture {
                                            isLiked.toggle()
                                            lajkovanjeAction?(idZajednickeDove, !isLiked)
                                        }

                                    Text("Prouči dovu")
                                        .font(.title3)
                                        .foregroundColor(Color("DarkGreen"))
                                }
                                .padding(.bottom)
                                
                                Spacer()
                                
                                HStack {
                                    Text("\(brojLajkova)")
                                        .font(.title3)
                                        .padding(.bottom)
                                    Circle()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(width: 40, height: 40)
                                        .padding(.bottom)
                                        .overlay {
                                            Image(systemName: "heart.fill")
                                                .font(.title3)
                                                .foregroundColor(Color("DarkGreen"))
                                                .padding(.bottom)
                                    }
                                
                                }
                                
                            }
                            .padding(.horizontal, 30)
                        }
                    }
            }
        }
    }
}

struct PrikazZajednickeDove_Previews: PreviewProvider {
    static var previews: some View {
        PrikazZajednickeDove(idZajednickeDove: 1, dova: "Dova za Palestinu", brojLajkova: 122)
        

    }
}
