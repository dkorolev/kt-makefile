import org.json.JSONObject

fun main() {
    val obj = JSONObject("""{"foo":"bar"}""")
    println("""The value for the key "foo" is "${obj.getString("foo")}".""")
}
