import Foundation

struct Post: Decodable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
