import matplotlib.pyplot as plt

# Sample data, 2 lists one for time and one for file_count

file_counts = [5,10,15,20,30,40]
time = [0.184,0.182,0.196,0.199,0.21,0.23]

plt.figure(figsize=(12, 6))
plt.plot(file_counts, time, label = "Merge Sort",marker = 'o', linestyle = '--', color = 'r')
plt.xlabel('File Count')
plt.ylabel('Time')
plt.title('Count sort')

plt.grid(True,which = 'both', linestyle = '--', linewidth = 0.5)

plt.tight_layout()
plt.show()