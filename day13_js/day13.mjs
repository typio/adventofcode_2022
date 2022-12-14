import { readFileSync } from 'fs'

const parsePacket = (str) => { // lmao somehow forgot about JSON.parse 
    return JSON.parse(str)
    let arr = []
    let i = 0
    while (i < str.length) {
        let c = str[i]
        if (c === '[') {
            let sub_i = i + 1
            let nested_n = 1
            for (let j = i + 1; j < str.length; j++) {
                if (str[j] === '[') {
                    nested_n++
                } else if (str[j] === ']') {
                    nested_n--
                    if (nested_n === 0) {
                        let sub_f = j + 1
                        let sub_str = str.slice(sub_i, sub_f)
                        arr.push(parsePacket(sub_str))
                        i = sub_f
                        break
                    }
                }
            }
        } else if (c === ']') {
            return arr
        } else if (!isNaN(Number(c))) {
            arr.push(Number(c))
        }
        i++
    }
    return arr
}

const compareLists = (list1, list2) => {
    if (list1.length !== list2.length) throw new Error("lists different sizes")
    for (let i = 0; i < list1.length; i++) {
        if (list2[i] > list1[i]) return false
        else if ((list2[i] < list1[i])) return true
    }
    return true
}


const comparePackets = (p1, p2) => {
    // console.log(p1, p2);
    if (p1 === undefined && p2 === undefined) return undefined;
    else if (p1 === undefined) return 1;
    else if (p2 === undefined) return -1;

    if (!Array.isArray(p1) && !Array.isArray(p2) && p1 !== p2) {
        return (p1 < p2) ? 1 : -1;
    } else if (Array.isArray(p1) && Array.isArray(p2)) {
        if (p1.length === 0) {
            return 1
        }
        if (p2.length === 0) {
            return -1
        }
        for (let i = 0; i < Math.max(p1.length, p2.length); i++) {
            const res = comparePackets(
                Array.isArray(p2[i]) && !Array.isArray(p1[i]) ? [p1[i]] : p1[i],
                Array.isArray(p1[i]) && !Array.isArray(p2[i]) ? [p2[i]] : p2[i],
            )
            if (res !== undefined) return res
        }
    }
};

let dataString = readFileSync(process.argv[2],
    { encoding: 'utf-8' })

let data = dataString.split('\n')
data = data.filter(e => e !== '').map(line => parsePacket(line))

let results = []
for (let i = 0; i < data.length; i += 2) {
    results.push(comparePackets(data[i], data[i + 1]))
}

let sum = 0
results = results.map((e, i) => { if (e === 1) return i + 1 })
results.forEach(e => {
    if (e !== undefined)
        sum += e
});

console.log(sum);
data.push([[2]], [[6]])
let sorted_data = data.sort((a, b) => comparePackets(b, a))

let [i1, i2] = [0, 0]
for (let i = 0; i < sorted_data.length; i++) {
    if (sorted_data[i].length == 1)
        if (sorted_data[i][0].length == 1) {
            if (sorted_data[i][0][0] == 2) {
                i1 = i + 1
            }
            if (sorted_data[i][0][0] == 6) {
                i2 = i + 1
            }
        }
}

console.log(i1 * i2);

