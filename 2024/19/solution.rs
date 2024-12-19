use std::fs;
use std::collections::HashMap;

fn how_many_makes_rec(
    req: &str,
    towels: &[String],
    memo: &mut HashMap<String, usize>,
) -> usize {
    if req.is_empty() {
        return 1;
    }
    if let Some(&result) = memo.get(req) {
        return result;
    }

    let mut total = 0;

    for towel in towels {
        if req.starts_with(towel) {
            total += how_many_makes_rec(&req[towel.len()..], towels, memo);
        }
    }

    memo.insert(req.to_string(), total);
    total
}

fn main() {
    // Read input from a file or default to "input"
    let input_file = std::env::args().nth(1).unwrap_or_else(|| "input".to_string());
    let content = fs::read_to_string(input_file).expect("Failed to read the input file");

    // Parse input lines
    let lines: Vec<&str> = content.lines().collect();
    let towels: Vec<String> = lines[0].split(", ").map(|s| s.to_string()).collect();
    let reqs: Vec<&str> = lines[2..].iter().map(|&s| s).collect();

    let mut count = 0;
    let mut total = 0;

    for req in reqs.iter().rev() {
        let mut memo = HashMap::new();
        let total_makes = how_many_makes_rec(req, &towels, &mut memo);

        println!("req: {}", req);
        println!("total_makes: {}", total_makes);

        total += total_makes;
        if total_makes > 0 {
            count += 1;
        }
    }

    println!("{}", count);
    println!("{}", total);
}
