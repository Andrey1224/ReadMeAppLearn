
import UIKit

// MARK:- Reusable SFSymbol Images
enum LibrarySymbol {
    case bookmark
    case bookmarkFill
    case book
    case letterSquare(letter: Character?)
    
    var image: UIImage {
        let imageName: String
        switch self {
        case .bookmark, .book:
            imageName = "\(self)"
        case .bookmarkFill:
            imageName = "bookmark.fill"
        case .letterSquare(let letter):
            guard let letter = letter?.lowercased(),
                  let image = UIImage(systemName: "\(letter).square")
            else {
                imageName = "square"
                break
            }
            return image
        }
        return UIImage(systemName: imageName)!
    }
}

// MARK:- Library
enum Library {
    private static let starterData = [
        Book(title: "Ein Neues Land", author: "Shaun Tan", readMe: true),
        Book(title: "Bosch", author: "Laurinda Dixon", readMe: true),
        Book(title: "Dare to Lead", author: "Brené Brown", readMe: false),
        Book(title: "Blasting for Optimum Health Recipe Book", author: "NutriBullet", readMe:  false),
        Book(title: "Drinking with the Saints", author: "Michael P. Foley", readMe: true),
        Book(title: "A Guide to Tea", author: "Adagio Teas", readMe: false),
        Book(title: "The Life and Complete Work of Francisco Goya", author: "P. Gassier & J Wilson", readMe: true),
        Book(title: "Lady Cottington's Pressed Fairy Book", author: "Lady Cottington", readMe: false),
        Book(title: "How to Draw Cats", author: "Janet Rancan", readMe: true),
        Book(title: "Drawing People", author: "Barbara Bradley", readMe: false),
        Book(title: "What to Say When You Talk to Yourself", author: "Shad Helmstetter", readMe: true)
    ]
    
    static var books: [Book] = loadBooks()
    
    private static let booksJSONURL = URL(fileURLWithPath: "Books",
                                          relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("json")
    
    
    
    private static func loadBooks() -> [Book] {
        let decoder = JSONDecoder()
        
        guard let booksData = try? Data(contentsOf: booksJSONURL) else {
            return starterData
        }
        
        do {
            let books = try decoder.decode([Book].self, from: booksData)
            return books.map { libraryBook in
                Book(
                    title: libraryBook.title,
                    author: libraryBook.author,
                    review: libraryBook.review,
                    readMe: libraryBook.readMe,
                    image: loadImage(forBook: libraryBook)
                )
            }
            
        } catch let error {
            print(error)
            return starterData
        }
    }
    
    private static func saveAllBooks() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let booksData = try encoder.encode(books)
            try booksData.write(to: booksJSONURL, options: .atomicWrite)
        } catch let error {
            print(error)
        }
    }
    
    
    static func addNew(book: Book) {
        if let image = book.image { saveImage(image, forBook: book) }
        books.insert(book, at: 0)
        saveAllBooks()
    }
    
    
    
    static func update(book: Book) {
        if let newImage = book.image {
            saveImage(newImage, forBook: book)
        }
        
        guard let bookIndex = books.firstIndex(where: { storedBook in
                                                book.title == storedBook.title } )
        else {
            print("No book to update")
            return
        }
        
        books[bookIndex] = book
        saveAllBooks()
    }
    
    
    static func delete(book: Book) {
        guard let bookIndex = books.firstIndex(where: { storedBook in
                                                book == storedBook } )
        else { return }
        
        books.remove(at: bookIndex)
        
        let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
        do {
            try FileManager().removeItem(at: imageURL)
        } catch let error { print(error) }
        
        saveAllBooks()
    }
    
    static func reorderBooks(bookToMove: Book, bookAtDestination: Book) {
        let destinationIndex = Library.books.firstIndex(of: bookAtDestination) ?? 0
        books.removeAll(where: { $0.title == bookToMove.title })
        books.insert(bookToMove, at: destinationIndex)
        saveAllBooks()
    }
    
    
    static func saveImage(_ image: UIImage, forBook book: Book) {
        let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
        if let jpgData = image.jpegData(compressionQuality: 0.7) {
            try? jpgData.write(to: imageURL, options: .atomicWrite)
        }
    }
    
    
    static func loadImage(forBook book: Book) -> UIImage? {
        let imageURL = FileManager.documentDirectoryURL.appendingPathComponent(book.title)
        return UIImage(contentsOfFile: imageURL.path)
    }
}

extension FileManager {
    static var documentDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
