import * as fs from 'fs'

let dataString = fs.readFileSync('./day1/input.txt', { encoding: 'utf-8' })

let data = dataString.split('\n')
let calSums = (new Array(data.length)).fill(0)
let calSumsI = 0
data.forEach(s => {
    if (s === '') calSumsI++
    else calSums[calSumsI] += parseInt(s)
})
console.log(calSums.reduce((prev, curr) => { return curr > prev ? curr : prev }));

