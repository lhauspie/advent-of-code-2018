package tries

fun sayHello(budy: String = "World") : String {
    return "Hello, $budy!"
}

fun main(args: Array<String>) {
    println(sayHello("Logan"))
}