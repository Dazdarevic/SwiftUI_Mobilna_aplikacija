//
//  ImageTitleRowCell.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 02.06.24.
//

import SwiftUI

struct ImageTitleRowCell: View {
    
    var imageSize: CGFloat = 20
    var imageName: String = Constants.randomImage
    var title: String = "Some title name"
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageSize, height: imageSize)
            Text(title)
                .font(.body)
                .foregroundColor(Color("MuslimBlack"))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: imageSize)
    }
}

struct ImageTitleRowCell_Previews: PreviewProvider {
    static var previews: some View {
        ImageTitleRowCell(imageSize: 70, imageName: "qurankerim", title: "Kur'an")
    }
}
