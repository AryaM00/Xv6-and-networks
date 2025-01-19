import matplotlib.pyplot as plt

# Given data
x_values = [10, 20, 30, 40,]
y_values = [431488, 431616,  431788, 431960]

# Plotting the graph
plt.plot(x_values, y_values, marker='o', linestyle='-', color='b')

# Adding labels and title
plt.xlabel("number of files")
plt.ylabel("Value")
plt.title("Countsort memory")

# Display the graph
plt.show()
