foreach ($set as $value) {
    // Do something to $value;
}

<!-- It is also possible to extract both keys and values using the alternate syntax: -->
foreach ($set as $key => $value) {
    echo "{$key} has a value of {$value}";
}