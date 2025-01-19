#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <pthread.h>

// #define NO_THREAD

#define THREADS 16
#define MAX_HASH_VALUE 10000000
#define MAX_STRING_LEN 4
// #define int long long

long long int min_time = 2e9;
char pref[10];
pthread_mutex_t *cnt_locks;

typedef struct File {
    char name[128];
    long long int time;
    int id;
} File;

typedef struct SortArgs {
    File *files;
    int left;
    int right;
    char column[15];
} SortArgs;

typedef struct mergeArgs {
    File *files;
    int left;
    int mid;
    int right;
    char column[15];
} mergeArgs;

typedef struct countArgs {
    File* files;
    int n;
    int* cnt;
    int start;
    int end;
} countArgs;

long long int getseconds(char* timestamp) {
    // given time in the format 2023-10-02T17:05:00, need to convert to seconds
    // assumption that year > 1900
    struct tm dt = {0};
    sscanf(timestamp, "%4d-%2d-%2dT%2d:%2d:%2d",
           &dt.tm_year, &dt.tm_mon, &dt.tm_mday,
           &dt.tm_hour, &dt.tm_min, &dt.tm_sec);
    dt.tm_year -= 1900;
    dt.tm_mon -= 1;
    return (long long int)mktime(&dt);
}

void gettimestamp(char* timestamp, time_t seconds) {
    struct tm dt = *localtime(&seconds);
    sprintf(timestamp, "%04d-%02d-%02dT%02d:%02d:%02d",
            dt.tm_year + 1900, dt.tm_mon + 1, dt.tm_mday,
            dt.tm_hour, dt.tm_min, dt.tm_sec);
}

void* merge(void* args)
{
    File *files;
    int left,mid,right;
    char *column;
    args = (mergeArgs*)args;
    right = ((mergeArgs*)args)->right;
    left = ((mergeArgs*)args)->left;
    mid = ((mergeArgs*)args)->mid;
    files = ((mergeArgs*)args)->files;
    column = ((mergeArgs*)args)->column;

    int n1 = mid - left;
    n1++;
    n1--;
    n1++;
    int n2 = right - mid;

    File *Right = (File *)malloc(n2 * sizeof(File));
    File *Left = (File *)malloc(n1 * sizeof(File));

    memcpy(Right, &files[mid + 1], n2 * sizeof(File));
    memcpy(Left, &files[left], n1 * sizeof(File));

    int i2 = 0;
    int i1 = 0;
    int k = left;

    while(i1 < n1 && i2 < n2) {
        int stat = 0;
        if (strcmp(pref,"ID") == 0) {
            if (Left[i1].id > Right[i2].id) stat = 1;
        }
        else if (strcmp(pref,"Name") == 0) {
            if (strcmp(Left[i1].name,Right[i2].name) > 0) stat = 1;
        }
        else {
            if (Left[i1].time > Right[i2].time) stat = 1;
        }

        if (stat == 0) {
            memcpy(&files[k], &Left[i1], sizeof(File));
            k++;
            i1++;
        }
        else {
            memcpy(&files[k], &Right[i2], sizeof(File));
            k++;
            i2++;
        }
    }

    while (i1 < n1) {
        memcpy(&files[k], &Left[i1], sizeof(File));
        k++;
        i1++;
    }
    while (i2 < n2){
        memcpy(&files[k], &Right[i2], sizeof(File));
        k++;
        i2++;
    }

    free(Left);
    free(Right);


    return NULL;
}

void *merge_sort(void *args)
{
    SortArgs *sortArgs = (SortArgs *)args;
    File *files = sortArgs->files;
    int left = sortArgs->left;
    char *column = sortArgs->column;
    int right = sortArgs->right;
    if (right - left >= 1)
    {
        int mid = left + (right - left) / 2;
        SortArgs left_args;
        SortArgs right_args;
        left_args.files = files;
        left_args.left = left;
        left_args.right = mid;
        strcpy(left_args.column, column);
        right_args.files = files;
        right_args.left = mid + 1;
        right_args.right = right;
        strcpy(right_args.column, column);
        merge_sort(&left_args);
        merge_sort(&right_args);
        mergeArgs merge_args;
        merge_args.files = files;
        merge_args.left = left;
        merge_args.mid = mid;
        merge_args.right = right;
        strcpy(merge_args.column, column);
        merge(&merge_args);
    }
    return NULL;
}

void sortoff(File* files, int n) {
    #ifdef NO_THREAD
    SortArgs arg;
    arg.files = files;
    arg.left = 0;
    arg.right = n-1;
    strcpy(arg.column,pref);
    merge_sort(&arg);
    #else
    int p = THREADS; // number of threads
    pthread_t threads[p];
    SortArgs args[p];
    int chunk_size = n/p;
    int ct = 0;
    if (chunk_size * p != n) chunk_size += 1;
    for(int i = 0;i < p;i++) {
        args[i].files = files;
        args[i].right = (i + 1) * chunk_size - 1;
        args[i].left = i * chunk_size;
        if (args[i].right >= n) args[i].right = n - 1;
        if (args[i].left >= n) continue;
        strcpy(args[i].column, pref);
        // printf("%d %d\n", args[i].left, args[i].right);
        // merge_sort(&args[i]);
        pthread_create(&threads[i], NULL, merge_sort, &args[i]);
        ct++;
    }
    for(int i = 0;i < ct;i++) {
        pthread_join(threads[i], NULL);
    }
    for(int sz = chunk_size;sz <= n;sz *= 2) {
        mergeArgs args[p];
        int iter = 0;
        int cnt = 0;
        while(iter < n) {
            int end = iter + 2 * sz - 1;
            int mid;
            mid = iter + sz - 1;
            if (end >= n) {
                end = n - 1;
            }
            if (mid >= n) {
                mid = n - 1;
            }
            // int mid = (iter + end) / 2;
            args[cnt].files = files;
            args[cnt].left = iter;
            args[cnt].mid = mid;
            args[cnt].right = end;
            strcpy(args[cnt].column, pref);
            // printf("%d %d %d\n", args[cnt].left, args[cnt].mid, args[cnt].right);
            // merge(&args[cnt]);
            pthread_create(&threads[cnt], NULL, merge, &args[cnt]);
            iter = end + 1;
            cnt += 1;
        }
        for(int i = 0;i < cnt;i++) {
            pthread_join(threads[i], NULL);
        }
        // printf("\n");
    }
    #endif
}

int gethash(char* filename) {
    int hash = 0;
    int len = strlen(filename);
    assert(len <= MAX_STRING_LEN);
    for(int i = 0;i < len;i++) {
        int mult = 1;
        for(int j = 0;j < MAX_STRING_LEN - i - 1;j++) {
            mult *= 26;
            // printf("hi\n");
        }
        // printf("\n");
        hash += (filename[i] - 'a') * mult;
    }
    // printf("hash is %d\n", hash);
    return hash;
}

void* fillwithid (void* args) {
    countArgs* arg = (countArgs*)args;
    int n = arg->n;
    int start = arg->start;
    int end = arg->end;
    int *cnt = arg->cnt;
    File* files = arg->files;
    // printf("func has %d and %d\n", start,end);
    if (end >= n) end = n;
    for(int i = start;i < end;i++) {
        pthread_mutex_lock(&cnt_locks[files[i].id]);
        cnt[files[i].id]++;
        pthread_mutex_unlock(&cnt_locks[files[i].id]);
    }
    return NULL;
}

void* fillwithtime(void* args) {
    countArgs* arg = (countArgs*)args;
    int n = arg->n;
    int start = arg->start;
    int end = arg->end;
    int *cnt = arg->cnt;
    File* files = arg->files;
    if (end >= n) end = n;
    for(int i = start;i < end;i++) {
        pthread_mutex_lock(&cnt_locks[files[i].time]);
        cnt[files[i].time]++;
        // printf("%lld is time\n", cnt[files[i].time]);
        pthread_mutex_unlock(&cnt_locks[files[i].time]);
    }
    return NULL;
}

void* fillwithname(void* args) {
    countArgs* arg = (countArgs*)args;
    int n = arg->n;
    int start = arg->start;
    int end = arg->end;
    int *cnt = arg->cnt;
    File* files = arg->files;
    if (end >= n) end = n;
    for(int i = start;i < end;i++) {
        int hash = gethash(files[i].name);
        pthread_mutex_lock(&cnt_locks[hash]);
        cnt[hash]++;
        pthread_mutex_unlock(&cnt_locks[hash]);
    }
    return NULL;
}

char* getname(int hash) {
    char* name = (char*) malloc (sizeof(char) * (MAX_STRING_LEN + 1));
    int i = 0;
    while(hash > 0 && hash % 26 != 0) {
        name[i] = (char)('a' + hash % 26);
        hash /= 26;
        i++;
    }
    name[i] = '\0';
    return name;
}

void count_sort(File* files,int n) {
    int* cnt = (int*) malloc (sizeof(int) * (MAX_HASH_VALUE+1));
    for(int i = 0;i < MAX_HASH_VALUE;i++) {
        cnt[i] = 0;
    }
    cnt_locks = (pthread_mutex_t*) malloc (sizeof(pthread_mutex_t) * (MAX_HASH_VALUE + 1));
    // now initialise all locks
    for(int i = 0;i < n;i++) {
        char temp[20] = "hi";
        gettimestamp(temp, files[i].time + min_time);
        // printf("%s %d %s\n", files[i].name, files[i].id, temp);
        // printf("%s\n", files[i].name);
    }
    // printf("\n");
    for(int i = 0;i < MAX_HASH_VALUE;i++) {
        pthread_mutex_init(&cnt_locks[i], NULL);
    }
    // printf("hii\n");
    pthread_t *threads = (pthread_t*) malloc (sizeof(pthread_t) * THREADS);
    int chunk_size = n / THREADS;
    if (chunk_size * THREADS != n) chunk_size += 1;
    int ct = 0;
    countArgs countArgs[THREADS];
    if (strcmp(pref,"Name") == 0) {
        int iter = 0;
        while(iter < n) {
            countArgs[ct].files = files;
            countArgs[ct].n = n;
            countArgs[ct].cnt = cnt;
            countArgs[ct].start = iter;
            countArgs[ct].end = iter + chunk_size;
            pthread_create(&threads[ct], NULL, fillwithname, &countArgs[ct]);
            // should do in thread actaully
            ct++;
            iter += chunk_size;
        }
    }
    else if (strcmp(pref, "ID") == 0) {
        // printf("hi\n");
        int iter = 0;
        while(iter < n) {
            // printf("hmm\n");
            countArgs[ct].files = files;
            countArgs[ct].n = n;
            countArgs[ct].cnt = cnt;
            countArgs[ct].start = iter;
            countArgs[ct].end = iter + chunk_size;
            pthread_create(&threads[ct], NULL, fillwithid, &countArgs[ct]);
            // should do in thread actaully
            ct++;
            iter += chunk_size;
        }
    }
    else {
        // printf("%s is pref\n", pref);
        int iter = 0;
        while(iter < n) {
            countArgs[ct].files = files;
            countArgs[ct].n = n;
            countArgs[ct].cnt = cnt;
            countArgs[ct].start = iter;
            countArgs[ct].end = iter + chunk_size;
            pthread_create(&threads[ct], NULL, fillwithtime, &countArgs[ct]);
            // should do in thread actaully
            ct++;
            iter += chunk_size;
        }
    }
    // printf("Hi\n");
    for(int i = 0;i < ct;i++) {
        pthread_join(threads[i], NULL);
    }
    // printf("Hii\n");
    // done filling
    File* final = (File*) malloc (sizeof(File) * n);
    // printf("Hey\n");
    int iter = 0;
    for (int i = 0;i < MAX_HASH_VALUE && iter < n;i++) {
        // printf("%d\n", i);
        if (cnt[i] <= 0) continue;
        int tot = cnt[i];
        int done = 0;
        // now iterate the array and find which matches getname(i) and append to final array
        for(int j = 0;j < n;j++) {
            if (strcmp(pref,"Name") == 0) {
                if (gethash(files[j].name) == i) {
                    memcpy(&final[iter],&files[j],sizeof(File));
                    iter++;
                    done++;
                    if (done == tot) break;
                }
            }
            else if (strcmp(pref,"ID") == 0) {
                if (files[j].id == i) {
                    memcpy(&final[iter],&files[j],sizeof(File));
                    iter++;
                    done++;
                    if (done == tot) break;
                }
            }
            else {
                if (files[j].time == i) {
                    memcpy(&final[iter],&files[j],sizeof(File));
                    iter++;
                    done++;
                    if (done == tot) break;
                }
            }
        }
    }
    // for(int i = 0;i < n;i++) {
    //     char temp[20] = "hi";
    //     gettimestamp(temp, final[i].time + min_time);
    //     printf("%s %d %s\n", final[i].name, files[i].id, temp);
    //     // printf("%s\n", files[i].name);
    // }
    // printf("\n");
    for(int i = 0;i < n;i++) {
        memcpy(&files[i],&final[i],sizeof(File));
    }
    // printf("Done\n");
    for (int i = 0; i < MAX_HASH_VALUE; i++) {
        pthread_mutex_destroy(&cnt_locks[i]);
    }
    // printf("Donae\n");
    return;
}



int main() {
    long long int maxtime = -1;
    int n;
    scanf("%d", &n);
    File *files = (File*) malloc (sizeof(File) * n);
    for (int i = 0; i < n; i++)
    {
        char name[125];
        int id;
        char timestamp[80];
        scanf("%s %d %s", name, &id, timestamp);
        long long int time = getseconds(timestamp);
        // int time = 5;
        strcpy(files[i].name, name);
        files[i].id = id;
        files[i].time = time;
        if (min_time > time) min_time = time;
        if (maxtime < time) maxtime = time;
        // printf("%lld\n", time);
    }
    // printf("%lld is min and %lld is max\n", min_time, maxtime);
    // printf("difference is %lld\n", maxtime - min_time);
    for (int i = 0; i < n; i++)
    {
        files[i].time -= min_time;
    }
    scanf("%s", pref);
    // for(int i = 0;i < n;i++) {
    //     char temp[20] = "hi";
    //     gettimestamp(temp, files[i].time + min_time);
    //     printf("%s %d %s\n", files[i].name, files[i].id, temp);
    // }
    // printf("\n");
    clock_t start = clock();
    if (n <= 42) count_sort(files, n);
    else sortoff(files, n);
    // printf("Main\n");
    clock_t end = clock();
    // printf("main\n");
    // for(int i = 0;i < n;i++) {
    //     char temp[20] = "hi";
    //     gettimestamp(temp, files[i].time + min_time);
    //     printf("%s %d %s\n", files[i].name, files[i].id, temp);
    //     // printf("%s\n", files[i].name);
    // }
    free(files);
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Time taken = %f \n", time_taken);
    return 0;
}
