def hash(string):
    sum = 0
    for c in string:
        sum += ord(c)
    return sum

print(hash('Utythfnjh1'))
