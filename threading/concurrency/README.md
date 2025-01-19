# concurrency


## Basic Assumptions
### For count sort:
- I have take the max lenght of file names to be 4, as for any higher lenght, we will need a lot more memory to hash the strings
- Also the date of creation, I am assuming that the timestamps will be from one day with differing times
- Assuming ID <= MAX_HASH_VALUE

### For merge sort:
- I have only considered range of timestamps differing by about a few hundred years.