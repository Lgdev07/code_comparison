values = ["a", "b", "c"]
print(values[0]) # a

values.append("d")
print(values) # ["a", "b", "c", "d"]

values[0] = "z"
print(values) # ["z", "b", "c", "d"]

# length of it
print(len(values))  # 4
