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
struct DataChunk
{
    int seq_num;               // Sequence number of the chunk
    int total_chunks;          // Total number of chunks
    char data[CHUNK_SIZE + 1]; // The chunk data
    time_t timestamp;          // The time the chunk was sent
};
struct AckPacket
{
    int seq_num; // The sequence number being acknowledged
};
int main()
{
    int client_socket;
    struct sockaddr_in server_addr;
    if ((client_socket = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    // int flags = fcntl(client_socket, F_GETFL, 0);
    // fcntl(client_socket, F_SETFL, flags | O_NONBLOCK);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr);
    sendto(client_socket, "Hi", 2, 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
    int total_chunks = 0;
    int flag = 0;
    struct DataChunk chunks[1000];
    struct DataChunk newchunk;

    while (2)
    {
        while (1)
        {
            // get data from server

            int len = 0;
            newchunk.seq_num = -1;
            newchunk.total_chunks = total_chunks;
            memset(newchunk.data, 0, sizeof(newchunk.data));

            while (len <= 0)
            {
                len = recvfrom(client_socket, &newchunk, sizeof(newchunk), 0, NULL, NULL);
            }
            //    usleep(9000);

            // printf("Received chunk %d\n", newchunk.seq_num);
            // printf("Data received %s\n", newchunk.data);
            // printf("Total chunks %d\n", newchunk.total_chunks);
            //    usleep(9000);
            // printf("cqertqehunk data %s\n", newchunk.data);
            total_chunks = newchunk.total_chunks;
            // if(flag==1)
            // {

            //     // flag=0;

            // }

            if (newchunk.seq_num == -1)
            {
                // printf("Data received\n");
                for (int i = 0; i < total_chunks; i++)
                {
                    printf("%s", chunks[i].data);
                }
                break;
            }
            chunks[newchunk.seq_num] = newchunk;
            struct AckPacket ack;

            ack.seq_num = newchunk.seq_num;
            // if(newchunk.seq_num!=3)
            // {
            sendto(client_socket, &ack, sizeof(ack), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
            // }
            // break;
        }
        // print data in correct order
        // now client must send data to server in correct order
        int flags = fcntl(client_socket, F_GETFL, 0);
        fcntl(client_socket, F_SETFL, flags | O_NONBLOCK);
        printf("Enter the message to be sent to server\n");
        char message[1024];
        fgets(message, sizeof(message), stdin);
        total_chunks = (strlen(message) + CHUNK_SIZE - 1) / CHUNK_SIZE;

        int seq_num = 0;
        int pending[total_chunks + 1];
        for (int i = 0; i <= total_chunks; i++)
        {
            pending[i] = 0;
        }
        // printf("Total chunks:%d\n", total_chunks);
        // fflush(stdout);
        // struct DataChunk chunks[total_chunks+1];
        while (seq_num < total_chunks)
        {
            struct DataChunk newchunk;
            newchunk.seq_num = seq_num;
            newchunk.total_chunks = total_chunks;
            for (int i = 0; i < CHUNK_SIZE; i++)
            {
                if (seq_num * CHUNK_SIZE + i < strlen(message))
                {
                    newchunk.data[i] = message[seq_num * CHUNK_SIZE + i];
                }
                else
                {
                    newchunk.data[i] = '\0';
                }
            }
            newchunk.data[CHUNK_SIZE] = '\0';
            chunks[seq_num] = newchunk;
            // printf("newchunkdata: %s", newchunk.data);

            sendto(client_socket, &newchunk, sizeof(newchunk), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
            // printf("Sent chunk %d\n", seq_num);
            pending[seq_num] = 1;
            struct AckPacket ack;
            int len = recvfrom(client_socket, &ack, sizeof(ack), 0, NULL, NULL);
            if (len > 0)
            {
                printf("Received ack for chunk %d\n", ack.seq_num);
                pending[ack.seq_num] = 0;
            }
            for (int i = 0; i <= total_chunks; i++)
            {
                if (pending[i] == 1)
                {
                    // printf("Retransmitting chunk with seq num :%d\n",chunks[i].seq_num);
                    time_t currenttime = time(NULL);
                    if (currenttime - chunks[i].timestamp > TIMELIMIT)
                    {
                        printf("Retransmitting chunk with seq num :%d\n", chunks[i].seq_num);
                        sendto(client_socket, &chunks[i], sizeof(chunks[i]), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
                        chunks[i].timestamp = currenttime;
                    }
                }
            }
            seq_num++;
        }

        int notsent = 0;
        for (int i = 0; i <= total_chunks; i++)
        {
            // printf("Pending:%d\n", pending[i]);
            if (pending[i])
            {
                // printf("Not sent:%d\n", i);

                notsent++;
            }
        }

        while (notsent)
        {
            // printf("Not sent:%d\n", notsent);
            for (int i = 0; i <= total_chunks; i++)
            {
                if (pending[i] == 1)
                {
                    time_t currenttime = time(NULL);
                    if (currenttime - chunks[i].timestamp > 2)
                    {
                        printf("Retransmitting chunk with seq num :%d\n", chunks[i].seq_num);
                        sendto(client_socket, &chunks[i], sizeof(chunks[i]), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));
                        chunks[i].timestamp = currenttime;
                    }
                    struct AckPacket ack;
                    int len = recvfrom(client_socket, &ack, sizeof(ack), 0, NULL, NULL);
                    if (len > 0)
                    {
                        printf("Received ack for chunk %d\n", ack.seq_num);
                        if (pending[ack.seq_num] == 1)

                        {
                            pending[ack.seq_num] = 0;

                            notsent--;
                        }
                    }
                }
            }
        }
        struct DataChunk finalchunk;
        finalchunk.seq_num = -1;
        sendto(client_socket, &finalchunk, sizeof(finalchunk), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));

        printf("All chunks sent\n");
    }
}
