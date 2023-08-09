import org.json.JSONObject

fun main() {
    val obj = JSONObject("""{"foo":"bar"}""")
    println("""The value for the key "foo" is "${obj.getString("foo")}".""")
    val res = JSONObject()
    res.put("exFoo", obj.getString("foo"))
    println("""And here's the newly constructed object: ${res.toString()}.""")
}
