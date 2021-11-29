// return list of modified elements
items map { x => doSomething(x) }
items map multiplyByTwo

for {x <- items} yield doSomething(x)
for {x <- items} yield multiplyByTwo(x)

// return nothing, just perform action
items foreach { x => doSomething(x) }
items foreach println

for {x <- items} doSomething(x)
for {x <- items} println(x)

// pattern matching example in for-comprehension
for ((key, value) <- someMap) println(s"$key -> $value")