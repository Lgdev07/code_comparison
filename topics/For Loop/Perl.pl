# List literal example:
foreach (1, 2, 3, 4) {
    print $_;
}

# Array examples:
foreach (@arr) {
    print $_;
}
foreach $x (@arr) { #$x is the element in @arr
    print $x;
}