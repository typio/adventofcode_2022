import java.io.File

fun String.set(index: Int, newChar: Char): String {
    val builder = StringBuilder(this)
    builder[index] = newChar
    return builder.toString()
}

fun main(args: Array<String>) {
    val file = File(args[0])

    if (!file.exists()) {
        println("The file doesn't exist.")
        return
    }

    var cycle = 1
    var x_reg = 1
    var solutionSum = 0
    var display = ".".repeat(240)

    file.forEachLine { line ->
        val tokens = line.split(" ")
        when (tokens[0]) {
            "noop" -> cycle++
            "addx" -> {
                cycle++
                if ((cycle + 20) % 40 == 0) {
                    solutionSum += x_reg * cycle
                }
                if (((cycle - 1) % 40) <= x_reg + 1 && ((cycle - 1) % 40) >= x_reg - 1) {
                    display = display.set(cycle, '#')
                }
                cycle++
                x_reg += tokens[1].toInt()
            }
        }
        if ((cycle + 20) % 40 == 0) {
            solutionSum += x_reg * cycle
        }
        if (((cycle - 1) % 40) <= x_reg + 1 && ((cycle - 1) % 40) >= x_reg - 1) {
            display = display.set(cycle, '#')
        }
    }

    println(solutionSum)
    for (i in 0 until display.length step 40) {
        println(display.substring(i, i + 40))
    }
}
