let mut numbers = vec![1, 2, 3];

// Immutable reference:
for number in &numbers { // calls IntoIterator::into_iter(&numbers)
    println!("{}", number);
}

for square in numbers.iter().map(|x| x * x) { // numbers.iter().map(|x| x * x) implements Iterator
    println!("{}", square);
}

// Mutable reference:
for number in &mut numbers { // calls IntoIterator::into_iter(&mut numbers)
    *number *= 2;
}

// prints "[2, 4, 6]":
println!("{:?}", numbers);

// Consumes the Vec and creates an Iterator:
for number in numbers { // calls IntoIterator::into_iter(numbers)
    // ...
}

// Errors with "borrow of moved value":
// println!("{:?}", numbers);