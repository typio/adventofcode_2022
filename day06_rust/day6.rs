use std::collections::{HashSet, VecDeque};
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();

    let datastream = fs::read_to_string(&args[1]).expect("Could not read file");

    let mut queue: VecDeque<char> = VecDeque::new();

    let mut i = 1;
    for c in datastream.chars() {
        if c.is_alphabetic() {
            queue.push_back(c);
            if queue.len() >= 14 {
                let set: HashSet<&char> = queue.iter().collect();
                if queue.len() == set.len() {
                    println!("solution: {}", i);
                    return;
                }
                queue.pop_front();
            }
            i += 1;
        }
    }
}
