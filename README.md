# Report
## Part 1:Distributed Sorting System Performance
## Merge Sort
### Implementation Analysis

I decided to first divide my array into p parts, then assign each part to a thread to be sorted independently using merge sort. Once all the subarrays are sorted, I perform pairwise merges in stages until only one fully sorted array remains. For example, if I have 8 subarrays [1, 2, 3, 4, 5, 6, 7, 8], in the first stage, I merge [1, 2] with [3, 4], [5, 6] with [7, 8], resulting in [1, 2, 3, 4] and [5, 6, 7, 8]. In the second stage, I merge these two subarrays to get the final sorted array [1, 2, 3, 4, 5, 6, 7, 8].

This approach ensures that each merge step progressively reduces the number of subarrays by half until the entire array is fully sorted.
### Mention why?
I found this method most intuitive and in fact even made more sense to this as compared to just implementing a normal merge sort routine for the whole array and calling thread for every recursive call until the total threads reaches max_thread_count.
This is because in my method each element has a thread assigned to it uniquely but in the other method, some elements will be assigned multiple threads. For example element[0] will be associated with thread which was made for n/2 and also the thread which was made for n/4, etc.
Also the thread made for n/2 would have to wait for its children threads to wait, which is waste of resources, but in my implementation, no thread waits for any other thread until the end.


### Pros
- The overall time complexity of this algorithm is O(n+n/plog(n/p)) which is much better than that of normal merge sort.
- Threading allows us to compute parallelly and thereby reducing time of computation significantly.
- This method is well-suited to systems with multiple cores. By increasing the number of threads (up to the available cores), you can handle larger arrays more effectively, making it scalable for varying workloads.
### Cons
- Each merge stage requires additional memory for storing intermediate results, which can lead to increased memory usage, especially for large arrays or when the number of threads is high. On systems with limited memory, this could pose constraints.
-  If the array size is not evenly divisible by p, some threads may receive larger or smaller portions of the data to process. This load imbalance can lead to certain threads completing earlier and waiting for others, reducing overall efficiency and parallelism.

## Count Sort
### Implementation Analysis
I decided to divide my array into p parts and assign each part to a single thread. Each thread processes its assigned part and updates the counts in a shared global array. Finally, we iterate over this global array to construct the sorted output based on the counts.

### Mention why?
Dividing the array into p parts and giving each part to a thread will make them run parallelly and hence make the time complexity O(n/p) rather thatn O(n) in the method without threads.

### Pros 
- Overall time complexity is O(n) which is almost same as that of normal count sort.
-  This method is well-suited for multi-core systems. Increasing the number of threads to match the number of cores allows for efficient parallelism, making the approach adaptable to varying hardware.
### Cons
- It is difficult to implement, and the return on effort is minimal.
- A global count array accessible by all threads may lead to high memory usage, especially if additional local count arrays are used before merging into the global array. For large arrays, this could be resource-intensive.


## Graphs && Time Analysis

- Graph for small dataset

![alt text](image1.png)

- Graph for medium dataset

![alt text](merge_medium.png)

- Graph for large dataset

![alt text](merge_large.png)

- Graph for count sort

![alt text](count.png)

## Memory usage
### merge sort
![alt text](image.png)
![alt text](image-1.png)
![alt text](image-3.png)
### count sort
![alt text](image-4.png)


## Summary
### Merge sort
- Used when the number of files exceeds 42.
- We will need a temporary array of size N for storing and copying back into the files array in the merge function.
- This is used to large data because of its logarithmic nature but would need more memory due to its recursive approach

### Count Sort
- Used when the number of files does not exceed 42
- We will need a maximum of 26 ^ (lenght of string) memory due to its hashing nature in the algorithm

## Part 2: Copy-On-Write (COW) Fork Performance Analysis

Number of page faults in Lazy test = 56561

### Memory consumption

- For n forks, the memory consumption would be reduced n times approximately until a write is done.
- If some processes never write to their memory, instead only read from them, then the os will be highly benifitted by COW implementation, since all the processes will share the same page rather than having a page of their own.

### Efficiency

- COW fork delays the time taken to copy a page in fork as it doesnt copy immediately.
- Whenever a write is done, the page is copied so the time taken for write (only the first time) will increase.
- But effectively, the total time taken would be better as some processes would never read and hence would never need to copy a page which is always done in normal fork implementation


### Possible optimisations:

- If multiple processes share memory which is read only (such as libraries, restricted files, etc), we can these pages are excluded from COW.
- We can maybe implement a more fine grained approach, i.e: instead of copying the whole page, we only copy the part of the page which is required.
- Improve fault handling by allowing more aggressive page sharing before triggering faults. If read operations dominate, further delaying the copy could save resources. You can track access patterns more intelligently to decide when copying is necessary.
- Implement "copy-on-demand," where the system could delay the copy further, especially when pages are frequently read but rarely written to. This strategy can be based on the likelihood of future writes or based on tracking whether a page is accessed by multiple processes.

