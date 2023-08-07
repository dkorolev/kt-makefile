import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue

data class MyJsonType(val the_question: String, val the_answer: Int)

fun main() {
    val mapper = jacksonObjectMapper()

    val myObject = MyJsonType("6*9", 42)
    val jsonString = mapper.writeValueAsString(myObject)
    println(jsonString)

    val json = """
      {
        "the_question":"6*9",
       "the_answer":42
      }
    """
    val objectFromJson: MyJsonType = mapper.readValue(json)
    println(objectFromJson)
}
