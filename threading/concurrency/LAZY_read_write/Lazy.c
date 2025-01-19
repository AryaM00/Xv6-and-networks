
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>

#define YELLOW "\033[1;33m"
#define PINK "\033[1;35m"
#define WHITE "\033[1;37m"
#define GREEN "\033[1;32m"
#define RED "\033[1;31m"
#define RESET "\033[0m"

int readtime, writetime, deletetime, numoffiles, maxusers, patience;
int starttime;
int topofqueueforread[1000];
int topofqueueforwrite[1000];
int topofqueuefordelete[1000];
int removedread[1000][1000];
int removedreadsize[1000];
int removedwrite[1000][1000];
int removedwritesize[1000];
int removeddelete[1000][1000];
int removeddeletesize[1000];
int readtimes[1000][1000];
int writetimes[1000][1000];
int deletetimes[1000][1000];



typedef struct {
    int user_id;
    int file_id;
    int request_type;
    int time;
    int queuenumber;
} UserRequest;
typedef enum {
    READ = 1,
    WRITE = 2,
    DELETE = 3
} RequestType;
struct Input {
    int time;
    char type[10];  // Can store "write", "read", "delete", or "process"
};

typedef struct file {
    int file_id;
    int read_count;
    int write_count;
    pthread_mutex_t lock;

} file;

UserRequest requests[1000];
file files[1000];
int valid[1000];
int compare(const void *a, const void *b) {
    UserRequest *req1 = (UserRequest *)a;
    UserRequest *req2 = (UserRequest *)b;

    if (req1->time != req2->time) {
        // Sort by time in increasing order
        return req1->time - req2->time;
    } else {
        // If time is the same, sort by request_type in decreasing order
        return req2->request_type - req1->request_type;
    }
}
void sleep_milliseconds(long milliseconds) {
    struct timespec req;
    req.tv_sec = 0;                    // 0 seconds
    req.tv_nsec = milliseconds * 1000000L;  // Convert milliseconds to nanoseconds

    nanosleep(&req, NULL);
}
int gettopofqueue(int op,int file_i)
{
   int topofqueue;
    if(op==READ)
    {

        int j=topofqueueforread[file_i];
        int flag=0;
        for(int i=0;i<removedreadsize[file_i];i++)
        {
            if(removedread[file_i][i]==j)
            {
                flag=1;
                break;
            }
        }
        while(flag==1)
        {
            j++;
            flag=0;
            for(int i=0;i<removedreadsize[file_i];i++)
            {
                if(removedread[file_i][i]==j)
                {
                    flag=1;
                    break;
                }
            }

        }
        topofqueue=j;
    }
    if(op==WRITE)
    {
        int j=topofqueueforwrite[file_i];
        int flag=0;
        for(int i=0;i<removedwritesize[file_i];i++)
        {
            if(removedwrite[file_i][i]==j)
            {
                flag=1;
                break;
            }
        }
        while(flag==1)
        {
            j++;
            flag=0;
            for(int i=0;i<removedwritesize[file_i];i++)
            {
                if(removedwrite[file_i][i]==j)
                {
                    flag=1;
                    break;
                }
            }

        }
        topofqueue=j;
    }
    if(op==DELETE)
    {
        int j=topofqueuefordelete[file_i];
        int flag=0;
        for(int i=0;i<removeddeletesize[file_i];i++)
        {
            if(removeddelete[file_i][i]==j)
            {
                flag=1;
                break;
            }
        }
        while(flag==1)
        {
            j++;
            flag=0;
            for(int i=0;i<removeddeletesize[file_i];i++)
            {
                if(removeddelete[file_i][i]==j)
                {
                    flag=1;
                    break;
                }
            }

        }
        topofqueue=j;
    } 
    return topofqueue;
}
void *process_request(void *arg) {
    UserRequest *req = (UserRequest *)arg;
    int file_i = req->file_id;
    int user_id = req->user_id;
    int op = req->request_type;
    int time_i = req->time;
    int queuenumber=req->queuenumber;
    pthread_mutex_lock(&files[file_i].lock);
    int topofqueue;
    topofqueue=gettopofqueue(op,file_i);
    if(op==READ)
    {
        topofqueueforread[file_i]=topofqueue;
    }
    if(op==WRITE)
    {
        topofqueueforwrite[file_i]=topofqueue;
    }
    if(op==DELETE)
    {
        topofqueuefordelete[file_i]=topofqueue;
    }

   

    if (valid[file_i]==0) {
        
        printf(WHITE "LAZY has declined the request of User %d at %d seconds because an invalid/deleted file was requested.\n" RESET, user_id, (int)time(NULL) - starttime);
        if(op==READ)
        {
            int k=removedreadsize[file_i];
            removedread[file_i][k]=queuenumber;
            removedreadsize[file_i]++;
        }
        if(op==WRITE)
        {
            int k=removedwritesize[file_i];
            removedwrite[file_i][k]=queuenumber;
            removedwritesize[file_i]++;
        }
        if(op==DELETE)
        {
            int k=removeddeletesize[file_i];
            removeddelete[file_i][k]=queuenumber;
            removeddeletesize[file_i]++;
        }
        pthread_mutex_unlock(&files[file_i].lock);
        return NULL;
    }
    pthread_mutex_unlock(&files[file_i].lock);
    sleep(1);

    
    while (1) {
        pthread_mutex_lock(&files[file_i].lock);
        int topofqueueofread=gettopofqueue(READ,file_i);
        topofqueueforread[file_i]=topofqueueofread;
        int topofqueueofwrite=gettopofqueue(WRITE,file_i);
        topofqueueforwrite[file_i]=topofqueueofwrite;
        int topofqueueofdelete=gettopofqueue(DELETE,file_i);
        topofqueuefordelete[file_i]=topofqueueofdelete;


        if(op==READ)
        {
        
            if(queuenumber!=topofqueueforread[file_i])
            {
                int k=time(NULL)-starttime-time_i;
                if(k>=patience)
                {
                    printf(RED "User %d canceled the request due to no response at %d seconds\n" RESET, user_id, k + time_i);
                    int k=removedreadsize[file_i];
                    removedread[file_i][k]=queuenumber;
                    removedreadsize[file_i]++;
                    pthread_mutex_unlock(&files[file_i].lock);
                    return NULL;
                }
                pthread_mutex_unlock(&files[file_i].lock);
                continue;
            }
        }
        if(op==WRITE)
        {
            if(queuenumber!=topofqueueforwrite[file_i])
            {
                int k=time(NULL)-starttime-time_i;
                if(k>=patience)
                {
                    printf(RED "User %d canceled the request due to no response at %d seconds\n" RESET, user_id, k + time_i);
                    int k=removedwritesize[file_i];
                    removedwrite[file_i][k]=queuenumber;
                    removedwritesize[file_i]++;
                    pthread_mutex_unlock(&files[file_i].lock);
                    return NULL;
                }
                pthread_mutex_unlock(&files[file_i].lock);
                continue;
            }
        }
        if(op==DELETE)
        {
            if(queuenumber!=topofqueuefordelete[file_i])
            {
                int k=time(NULL)-starttime-time_i;
                if(k>=patience)
                {
                    printf(RED "User %d canceled the request due to no response at %d seconds\n" RESET, user_id, k + time_i);
                    int k=removeddeletesize[file_i];
                    removeddelete[file_i][k]=queuenumber;
                    removeddeletesize[file_i]++;
                    pthread_mutex_unlock(&files[file_i].lock);
                    return NULL;
                }
                pthread_mutex_unlock(&files[file_i].lock);
                continue;
            }
        }
        int k = time(NULL) - starttime - time_i;
        if (op == READ) {
            if (valid[file_i]==0) {
                printf(WHITE "LAZY has declined the request of User %d at %d seconds because an invalid/deleted file was requested.\n" RESET, user_id, k+time_i);
                topofqueueforread[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueueforread[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            }
            int topofqueueofread=gettopofqueue(READ,file_i);
            int k1=readtimes[file_i][topofqueueofread];
            int topofqueueofwrite=gettopofqueue(WRITE,file_i);
            int k2=writetimes[file_i][topofqueueofwrite];
            int topofqueueofdelete=gettopofqueue(DELETE,file_i);
            int k3=deletetimes[file_i][topofqueueofdelete];
            if(k2!=-1)
            {
                if(k2 < k1)
                {
                    pthread_mutex_unlock(&files[file_i].lock);
                    continue;
                }
            }
            if(k3!=-1)
            {
                if(k3 <k1 && files[file_i].write_count==0 && files[file_i].read_count==0)
                {
                    pthread_mutex_unlock(&files[file_i].lock);
                    continue;
                }
            }



            if (files[file_i].read_count + files[file_i].write_count < maxusers && k < patience) {
                files[file_i].read_count++;
                printf(PINK "LAZY has taken up the request of User %d at %d seconds\n" RESET, user_id, k + time_i);
                topofqueueforread[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueueforread[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);

                sleep(readtime);
                int time2 = time(NULL) - starttime;
                pthread_mutex_lock(&files[file_i].lock);
                files[file_i].read_count--;
                printf(GREEN "The request for User %d was completed at %d seconds\n" RESET, user_id, time2);
      
                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            } else if (k >= patience) {
                printf(RED "User %d canceled the request due to no response at %d seconds\n" RESET, user_id, k + time_i);
                topofqueueforread[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueueforread[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            }
        } else if (op == WRITE) {
            if (valid[file_i]==0) {
                printf(WHITE "LAZY has declined the request of User %d at %d seconds because an invalid/deleted file was requested.\n" RESET, user_id, (int)time(NULL) - starttime);
                topofqueueforwrite[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueueforwrite[file_i]=topofqueue;
                //unlock;
                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            }
            
            int topofqueueofread=gettopofqueue(READ,file_i);
            int k1=readtimes[file_i][topofqueueofread];
            int topofqueueofwrite=gettopofqueue(WRITE,file_i);
            int k2=writetimes[file_i][topofqueueofwrite];
            int topofqueueofdelete=gettopofqueue(DELETE,file_i);
            int k3=deletetimes[file_i][topofqueueofdelete];
            if(k1!=-1)
            {
                if(k1 <= k2)
                {
                    pthread_mutex_unlock(&files[file_i].lock);
                    continue;
                }
            }
            if(k3!=-1)
            {
                if(k3 <k2 && files[file_i].write_count==0 && files[file_i].read_count==0)
                {
                    pthread_mutex_unlock(&files[file_i].lock);
                    continue;
                }
            }
            if (files[file_i].read_count < maxusers && files[file_i].write_count == 0 && k < patience && valid[file_i]==1)  {
                files[file_i].write_count++;
                printf(PINK "LAZY has taken up the request of User %d at %d seconds\n" RESET, user_id, k + time_i);
                topofqueueforwrite[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueueforwrite[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);

                sleep(writetime);
                int time2 = time(NULL) - starttime;
                pthread_mutex_lock(&files[file_i].lock);
                files[file_i].write_count--;
                printf(GREEN "The request for User %d was completed at %d seconds\n" RESET, user_id, time2);


                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            }

            else if (k >= patience) {
                printf(RED "User %d canceled the request due to no response at %d seconds\n" RESET, user_id, k + time_i);
                topofqueueforwrite[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueueforwrite[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            }

        } else if (op == DELETE) {
            if(valid[file_i]==0)
            {
                printf(WHITE "LAZY has declined the request of User %d at %d seconds because an invalid/deleted file was requested.\n" RESET, user_id, (int)time(NULL) - starttime);
                topofqueuefordelete[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueuefordelete[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            }
            int topofqueueofread=gettopofqueue(READ,file_i);
            int k1=readtimes[file_i][topofqueueofread];
            int topofqueueofwrite=gettopofqueue(WRITE,file_i);
            int k2=writetimes[file_i][topofqueueofwrite];
            int topofqueueofdelete=gettopofqueue(DELETE,file_i);
            int k3=deletetimes[file_i][topofqueueofdelete];
            if(k1!=-1)
            {
                if(k1<=k3)
                {
                    pthread_mutex_unlock(&files[file_i].lock);
                    continue;
                }
            }
            if(k2!=-1)
            {
                if(k2<=k3)
                {
                    pthread_mutex_unlock(&files[file_i].lock);
                    continue;
                }
            }

            if (files[file_i].read_count == 0 && files[file_i].write_count == 0 && k < patience) {
                printf(PINK "LAZY has taken up the request of User %d at %d seconds\n" RESET, user_id, k + time_i);
                valid[file_i] = 0;
                topofqueuefordelete[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueuefordelete[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);


                sleep(deletetime);
                int time2 = time(NULL) - starttime;
                pthread_mutex_lock(&files[file_i].lock);
                printf(GREEN "The request for User %d was completed at %d seconds\n" RESET, user_id, time2);

                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            } else if (k >= patience) {
                printf(RED "User %d canceled the request due to no response at %d seconds\n" RESET, user_id, k + time_i);
                topofqueuefordelete[file_i]++;
                topofqueue=gettopofqueue(op,file_i);
                topofqueuefordelete[file_i]=topofqueue;
                pthread_mutex_unlock(&files[file_i].lock);
                return NULL;
            }
        }
        pthread_mutex_unlock(&files[file_i].lock);
    }
    return NULL;
}

int main() 
{
    scanf("%d %d %d", &readtime, &writetime, &deletetime);
    scanf("%d %d", &numoffiles, &maxusers);
    scanf("%d", &patience);
    char request[10];
    int userid, fileid, requesttype, times;
    int request_count = 0;
    for(int i=0;i<1000;i++)
    {
        valid[i]=0;
    }
    for(int i=1;i<=numoffiles;i++)
    {
        valid[i]=1;
    }
    for(int i=0;i<1000;i++)
    {
        topofqueuefordelete[i]=0;
        topofqueueforread[i]=0;
        topofqueueforwrite[i]=0;
        removedreadsize[i]=0;
        removeddeletesize[i]=0;
        removedwritesize[i]=0;
    }
    while (1) {
        char first_token[10];
        scanf("%s", first_token);
        if (strcmp(first_token, "STOP") == 0) {
            break;
        }
        userid = atoi(first_token);
        scanf("%d %s %d", &fileid, request, &times);

        if (strcmp(request, "READ") == 0) {
            requesttype = READ;
        } else if (strcmp(request, "WRITE") == 0) {
            requesttype = WRITE;
        } else if (strcmp(request, "DELETE") == 0) {
            requesttype = DELETE;
        } else {
            printf("Invalid request\n");
            continue;
        }

        UserRequest user_request = {userid, fileid, requesttype, times,0};
        requests[request_count++] = user_request;
    }
    qsort(requests, request_count, sizeof(UserRequest), compare);
    for(int i=0;i<1000;i++)
    {
        for(int j=0;j<1000;j++)
        {
            readtimes[i][j]=-1;
            writetimes[i][j]=-1;
            deletetimes[i][j]=-1;
        }
    }
    for(int i=0;i<request_count;i++)
    {
        if(requests[i].request_type==READ)
        {   
            readtimes[requests[i].file_id][topofqueueforread[requests[i].file_id]]=requests[i].time;
            requests[i].queuenumber=topofqueueforread[requests[i].file_id];
            topofqueueforread[requests[i].file_id]++;
        }
        else if(requests[i].request_type==WRITE)
        {
            writetimes[requests[i].file_id][topofqueueforwrite[requests[i].file_id]]=requests[i].time;
            requests[i].queuenumber=topofqueueforwrite[requests[i].file_id];
            topofqueueforwrite[requests[i].file_id]++;
        }
        else if(requests[i].request_type==DELETE)
        {
            deletetimes[requests[i].file_id][topofqueuefordelete[requests[i].file_id]]=requests[i].time;
            requests[i].queuenumber=topofqueuefordelete[requests[i].file_id];
            topofqueuefordelete[requests[i].file_id]++;
        }
    }
    for(int i=0;i<1000;i++)
    {
        topofqueuefordelete[i]=0;
        topofqueueforread[i]=0;
        topofqueueforwrite[i]=0;
    }
    // for(int i=0;i<request_count;i++)
    // {
    //     printf("%d %d %d %d %d\n",requests[i].user_id,requests[i].file_id,requests[i].request_type,requests[i].time,requests[i].queuenumber);
    // }

    //sort requests
    printf("Lazy has woken up!\n");
    for (int i = 0; i < numoffiles; i++) {
        files[i].file_id = requests[i].file_id;
        files[i].read_count = 0;
        files[i].write_count = 0;
        pthread_mutex_init(&files[i].lock, NULL);
    }

    pthread_t threads[request_count];
    starttime = time(NULL);
    sleep(requests[0].time);

    for (int i = 0; i < request_count; i++) {
        if (requests[i].request_type == READ) {
            printf(YELLOW "User %d has made request for performing READ on file %d at %d seconds\n" RESET, requests[i].user_id, requests[i].file_id, requests[i].time);
        } else if (requests[i].request_type == WRITE) {
            printf(YELLOW "User %d has made request for performing WRITE on file %d at %d seconds\n" RESET, requests[i].user_id, requests[i].file_id, requests[i].time);
        } else if (requests[i].request_type == DELETE) {
            printf(YELLOW "User %d has made request for performing DELETE on file %d at %d seconds\n" RESET, requests[i].user_id, requests[i].file_id, requests[i].time);
        }

        UserRequest req = requests[i];
        pthread_create(&threads[i], NULL, process_request, (void *)&req);
        if (i + 1 < request_count) {
            sleep(requests[i + 1].time - requests[i].time);
        }
        sleep_milliseconds(10);
    }

    for (int i = 0; i < request_count; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Lazy has no more pending requests and is going back to sleep!\n");
    return 0;
}
