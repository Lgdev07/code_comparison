population = {
    "China": 1411778724,
    "India": 1381230134,
    "USA":   332271672,
}
print(population["USA"])  # 332271672

# add new key
population["Brazil"] = 22

# delete by key
population.pop("Brazil")

# Checking if a key exists in a map
if "India" in population : print(population["India"]) # 1381230134
if "Italy" in population : print(population["Italy"])

# Iterating over a map
for index, value in population.items():
    print(index, value)
# Output:
# China 1411778724
# India 1381230134
# USA 332271672
