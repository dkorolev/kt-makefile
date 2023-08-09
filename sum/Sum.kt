fun main() {
  print("Enter A and B, space-separated, followed by a newline: ")
  val (a, b) = readLine()!!.split(' ')
  println("A + B is ${a.toInt() + b.toInt()}.")
}
