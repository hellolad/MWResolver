
#### MWResolver
MWResolver是我在libxml2上进行的一层Swift版本的封装，可以通过纯Swift的方式来解析HTML/XML，先看一下需求：

![](https://upload-images.jianshu.io/upload_images/1786359-4ec66ddb8f58335a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

还是以[SwiftDoc](http://swiftdoc.org/)为例，我们从源码中，想获取到所有的标签`li`里面的第一行的内容(AnyBidirectionalCollection)，用`MWResolver`这么写就可以了：
```swift
let resolver = MWResolver(data: data)
guard let element = resolver.peekParse(query: "//div[@class='col-sm-6']//li//a") else { return }
print(element.content)
// 打印：AnyBidirectionalCollection
```
有了这个神器，可以说什么网站网页都不怕了，下面我来一个比较完整的实例，解析`SwiftDoc`:
- 首先我们先拿到所有的标题：
```swift
let resovler = MWResolver(data: data)
let elementH2s = resovler.parse(query: "//article[@class='content']//h2")
for ele in elementH2s {
    print(ele.content)
}
// 打印：
Types
Protocols
Operators
Globals
```
- 为了便于查看我们拿最少的Globals下的所有函数：
```swift
let elementLis = resovler.parse(query: "//li/a")
var contents = [String]()
for ele in elementLis {
    guard let content = ele.attributes["href"] else { return }
    if content.hasPrefix("/v3.1/func/") {
        contents.append(content)
        print(content)
    }
}
// 打印：
/v3.1/func/abs
/v3.1/func/assert
/v3.1/func/assertionFailure
/v3.1/func/debugPrint
/v3.1/func/dump
/v3.1/func/fatalError
/v3.1/func/getVaList
/v3.1/func/isKnownUniquelyReferenced
/v3.1/func/max
/v3.1/func/min
/v3.1/func/numericCast
/v3.1/func/precondition
/v3.1/func/preconditionFailure
/v3.1/func/print
/v3.1/func/readLine
/v3.1/func/repeatElement
/v3.1/func/sequence
/v3.1/func/stride
/v3.1/func/swap
/v3.1/func/transcode
/v3.1/func/type
/v3.1/func/unsafeBitCast
/v3.1/func/unsafeDowncast
/v3.1/func/withExtendedLifetime
/v3.1/func/withUnsafeBytes
/v3.1/func/withUnsafeMutableBytes
/v3.1/func/withUnsafeMutablePointer
/v3.1/func/withUnsafePointer
/v3.1/func/withVaList
/v3.1/func/withoutActuallyEscaping
/v3.1/func/zip
```
也就是对应的SwiftDoc中这些数据：

![](https://upload-images.jianshu.io/upload_images/1786359-d2e9d7090906ae5c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 如何使用
1.把上面三个文件导入到项目中。

2.导入libxml2

3.在header search path 中 + ${SDK_ROOT}/usr/include/libxml2

4.引入桥文件支持OC+Swift混编
