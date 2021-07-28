//
//  Book.swift
//  ReadMe
//
//  Created by Andrii Nepodymka on 7/27/21.
//

import UIKit


struct Book {
    
    let title: String
    let author: String
    
    
    var image: UIImage {
        Library.loadImage(forBook: self)
       ?? LibrarySymbol.letterSquare(letter: title.first).image
    }
    
}