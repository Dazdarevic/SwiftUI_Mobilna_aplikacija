//
//  ListaAllahovihImena.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 03.06.24.
//

import SwiftUI


struct ListaAllahovihImena: View {
    
    var redniBroj: String = "50"
    var imeSureNaArapskom: String = "Some surah name goes here"
    var prevodImenaSure: String = "Some surah name"
    var tipSure: String = ""
    var sura: String = ""
    var brojAjeta: Int = 99
//    var onCellPressed: (() -> Void)? = nil

    var body: some View {
            HStack(spacing: 8) {
                Text(redniBroj)
                    .font(.title)
//                    .bold()
                    .foregroundColor(Color("MuslimBlack").opacity(0.9))
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(sura)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("DarkGreen").opacity(0.9))
                    HStack {
                        Text(prevodImenaSure)
                            .font(.callout)
                            .foregroundColor(Color("MuslimLightGray"))
                        if tipSure == "mekkanska" {
                            Image("mekka")
                                .resizable()
                                .opacity(0.8)
                                .frame(width: 20, height: 20)
                        } else {
                             Image("medina")
                                 .resizable()
                                 .opacity(0.8)
                                 .frame(width: 20, height: 20)
                        }
                    }

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing) {
                    Text(imeSureNaArapskom)
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("MuslimBlack").opacity(0.8))
                    
                    Text("\(brojAjeta) imena")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .foregroundColor(Color("MuslimLightGray").opacity(0.9))
                }
            
            }
            .padding()
            .background(Color.white.opacity(0.6))
//            .cornerRadius(8)
    }
}

struct ListaAllahovihImena_Previews: PreviewProvider {
    static var previews: some View {
        ListaAllahovihImena()
    }
}
