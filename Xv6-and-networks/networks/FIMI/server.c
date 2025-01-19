#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <fcntl.h>
#include <time.h>
#define PORT 8080
#define CHUNK_SIZE 8
#define TIMELIMIT 0.1
struct DataChunk {
    int seq_num;      // Sequence number of the chunk
    int total_chunks; // Total number of chunks
    char data[CHUNK_SIZE+1];  // The chunk data
    time_t timestamp; // The time the chunk was sent
   
};
struct AckPacket {
    int seq_num;  // The sequence number being acknowledged
};

int main()
{

    int server_socket;

    struct sockaddr_in server_addr,client_addr;
    int addr_len = sizeof(client_addr);
    if ((server_socket = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0)
    {
        perror("bind failed");
        close(server_socket);
        exit(EXIT_FAILURE);
    }
    int buffer[1024];
    printf("Server is ready for clients...\n");
    memset(buffer,0,sizeof(buffer));
    recvfrom(server_socket,buffer,sizeof(buffer),0,(struct sockaddr *)&client_addr,&addr_len);
    printf("Client connected\n");
    struct DataChunk chunks[1000];
    while(1)
    {
        // first server should be able to send data to client
        printf("Enter the message to be sent to client\n");
        char message[1024];
        fgets(message,sizeof(message),stdin);

        printf("Message entered %s\n",message);
        printf("Message length %ld\n",strlen(message));
        // break the messages into fixed size chunks
        int total_chunks = (strlen(message)+CHUNK_SIZE-1)/CHUNK_SIZE;
        int sentchunks=0;
        int pending[total_chunks+1];
        for(int i=0;i<=total_chunks;i++)
        {
            pending[i]=0;
        }
        int seq_num=0;
        // Array of chunks
            int flags = fcntl(server_socket, F_GETFL, 0);
    fcntl(server_socket, F_SETFL, flags | O_NONBLOCK);
        // allocate memory for each chunk
        while(seq_num<total_chunks)
        {
            // create a new chunk
            struct DataChunk newchunk;
            newchunk.seq_num=seq_num;
            newchunk.total_chunks=total_chunks;
            newchunk.timestamp=time(NULL);
            // copy the data into the chunk
            for(int i=0;i<CHUNK_SIZE;i++)
            {
                if(seq_num*CHUNK_SIZE+i<strlen(message))
                {
                    newchunk.data[i]=message[seq_num*CHUNK_SIZE+i];
                }
                else
                {
                    newchunk.data[i]='\0';
                    // break;
                }
            }
            newchunk.data[CHUNK_SIZE]='\0';
            chunks[seq_num]=newchunk;

            // printf("newchunk data %s\n",newchunk.data);
            // send the chunk
            sendto(server_socket,&newchunk,sizeof(newchunk),0,(struct sockaddr *)&client_addr,addr_len);
            // printf("Sent chunk %d\n",seq_num);
            // wait for ack
            pending[seq_num]=1;
            struct AckPacket ack;
            int len=recvfrom(server_socket,&ack,sizeof(ack),0,(struct sockaddr *)&client_addr,&addr_len);
            if(len>0)
            {
                printf("Received ack for chunk %d\n",ack.seq_num);
                pending[ack.seq_num]=0;
                // sentchunks++;
            }
            for(int i=0;i<=total_chunks;i++)
            {
                if(pending[i]==1)
                {
                    time_t currenttime=time(NULL);
                    if(currenttime-chunks[i].timestamp>TIMELIMIT )
                    {
                        // resend the chunk


                        printf("Retransmitting chunk %d\n",chunks[i].seq_num);
                        sendto(server_socket,&chunks[i],sizeof(chunks[i]),0,(struct sockaddr *)&client_addr,addr_len);
                        chunks[i].timestamp=currenttime;
                    }
                }
            }
            seq_num++;
        }
        int notsent=0;
        for(int i=0;i<=total_chunks;i++)
        {
            if(pending[i])
            {
                notsent++;

            }
        }
        while(notsent)
        {
            for(int i=0;i<=total_chunks;i++)
            {
                if(pending[i]==1)
                {
                    time_t currenttime=time(NULL);
                    if(currenttime-chunks[i].timestamp>TIMELIMIT )
                    {
                        // resend the chunk

                        printf("Retransmitting chunk %d\n",chunks[i].seq_num);

                        sendto(server_socket,&chunks[i],sizeof(chunks[i]),0,(struct sockaddr *)&client_addr,addr_len);
                        chunks[i].timestamp=currenttime;
                    }
                    struct AckPacket ack;
                    int len=recvfrom(server_socket,&ack,sizeof(ack),0,(struct sockaddr *)&client_addr,&addr_len);
                    if(len>0)
                    {
                        printf("Received ack for chunk %d\n",ack.seq_num);
                        pending[ack.seq_num]=0;
                        notsent--;
                    }
                }
            }
        }
        struct DataChunk finalchunk;
        finalchunk.seq_num=-1;
        finalchunk.total_chunks=total_chunks;
        sendto(server_socket,&finalchunk,sizeof(finalchunk),0,(struct sockaddr *)&client_addr,addr_len);



    
        printf("All chunks sent\n");
        // now server has to receive data 
        for(int i=0;i<total_chunks;i++)
        {

        }
        struct DataChunk newchunk;
        while(1)
        {
     
            // int len=recvfrom(server_socket,&newchunk,sizeof(newchunk),0,(struct sockaddr *)&client_addr,&addr_len);
            int len=0;
            newchunk.seq_num=1;
            newchunk.total_chunks=total_chunks;
            memset(newchunk.data,0,sizeof(newchunk.data));
            while(len<=0)
            {
            len=recvfrom(server_socket,&newchunk,sizeof(newchunk),0,NULL,NULL);


            }
            // printf("Received chunk %d\n", newchunk.seq_num);
            // printf("Receiveddata:%s\n",newchunk.data);
            total_chunks=newchunk.total_chunks;

          
                if(newchunk.seq_num==-1)
                {
                    // printf("Data received\n");
                    for(int i=0;i<total_chunks;i++)
                    {
                        printf("%s",chunks[i].data);
                    }
                    break;
                }
                // printf("Received chunk %d\n",newchunk.seq_num);
                chunks[newchunk.seq_num]=newchunk;

                struct AckPacket ack;
                ack.seq_num=newchunk.seq_num;
                // if(ack.seq_num!=3)
                // {
                    sendto(server_socket,&ack,sizeof(ack),0,(struct sockaddr *)&client_addr,addr_len);
                // }
            
            // printf("Enteredhere\n");

        }
        // break;
        
        

        



    }




   


   


    

}