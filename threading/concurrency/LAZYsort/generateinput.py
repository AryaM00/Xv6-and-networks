from random import randint

def timestamp_d():
    return f"2023-10-01T0{randint(1,9)}:{randint(0,59)}:{randint(0,59)}"

fun_list = []

n = 40

for i in range(n):
    id_d = randint(2,20000)
    timestamp = timestamp_d()
    # print(f"FIle{i} {id_d} {timestamp}")
    s = "zzz"
    # I want to append char(a + i) to s
    s += chr(ord('a') + (i % 26))
    fun_list.append(f"{s} {id_d} {timestamp}")
    # print(int(entry.split()[1]))

def sort_by_id(file_entry):
    # Split the string and extract the id_d (second part of the string)
    return int(file_entry.split()[1])

# Sorting fun_list based on id_d
fun_list.sort(key=sort_by_id)


with open('file.txt', 'w') as f:
    f.write(f"{n}\n")
    for i in fun_list:
        f.write(i + '\n')
    f.write("ID\n")

print("Data has been written to file.txt")