
total = 0
machines = {}

for line in open("test.out"):

    # skip the header
    if line.startswith("s"):
        continue
    
    fields = line.split()

    srcip = fields[0]
    bytes = int(fields[5])

    if srcip not in machines:
        machines[srcip] = bytes
    else:
        machines[srcip] += bytes

    total += bytes

for key, value in sorted(machines.iteritems(), key=lambda (k, v) : (v, k)):
    print key, value
    

print "Total", total
