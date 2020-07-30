## JSONDecoder与JSONEncoder

<p align="center">
<img src="/resources/Codable.png">
</p>

通过 Codable 协议实现Swift对象与JSON字符串之间的互转。

```swift
public typealias Codable = Decodable & Encodable
```
 Codable 是 Decodable 和 Encodable 的类型别名。当你遵守 Codable 协议时，同时遵守Decodable 和 Encodable 协议。

 > Swift 标准库类型都实现了 Codable , 比如 String , Double , Int 等, Foundation 库中也有许多类型实现了 Codable , 比如 Date , Data , URL , Array, Dictionary, Optional.


```swift
import Foundation

// MARK: - Decode

struct User { // 基本类型组合默认遵守Codable协议
    var name: String
    var age: Int
}

let jsonStr = """
{
    "name": "Ryan",
    "age": 18
}
"""

let jsonData = jsonStr.data(using: .utf8)!

let decoder = JSONDecoder()

do {
    let userObj = try decoder.decode(User.self, from: jsonData)
    print("userObj = \(userObj)")
} catch {
    print("decode error")
}

// MARK: - Encode

let user = User(name: "Lux", age: 20)

let encoder = JSONEncoder()

do {
    let data = try encoder.encode(user)
    let jsonStr = String(data: data, encoding: .utf8)!
    print("jsonStr = \(jsonStr)")
} catch {
    print("encode error")
}

```

JSON -> Object 

1. JSON -> Data
2. 创建JSONDecoder对象
3. decode（Data对象）

Object -> JSON

1. 创建JSONEncoder对象
2. encode（Object对象）
3. Data -> JSON


```swift

// 解析.json文件通用模板

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
        
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
        
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
        
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
````