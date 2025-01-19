#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>

#define PORT 8080

void initboard(char board[4][4]) {
    for(int i=0;i<4;i++) {
        for(int j=0;j<4;j++) {
            board[i][j]='.';
        }
    }
}

int checkwin(char board[4][4]) {
    // Implement the same logic you have for checking win/draw.
    // Returning the same values as in the TCP code
     int draw = 1;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            if (board[i][j] == '.') {
                draw = 0;
            }
        }
    }
    // if(draw==0)
    // {
    //     return 0;
    // }

    // Check rows for a win
    for (int i = 0; i < 3; i++) {
        if (board[i][0] != '.' && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
            return (board[i][0] == 'X') ? 1 : 2;  // Return 1 if 'X' wins, 2 if 'O' wins
        }
    }

    // Check columns for a win
    for (int i = 0; i < 3; i++) {
        if (board[0][i] != '.' && board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
            return (board[0][i] == 'X') ? 1 : 2;  // Return 1 if 'X' wins, 2 if 'O' wins
        }
    }

    // Check diagonals for a win
    if (board[0][0] != '.' && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
        return (board[0][0] == 'X') ? 1 : 2;  // Return 1 if 'X' wins, 2 if 'O' wins
    }
    if (board[0][2] != '.' && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
        return (board[0][2] == 'X') ? 1 : 2;  // Return 1 if 'X' wins, 2 if 'O' wins
    }
    
    // If it's a draw
    if(draw)
    {
        return 3;
    }

    return 0;
}

int main() {
    int server_socket;
    struct sockaddr_in serveraddress, client1_addr, client2_addr;
    char buffer[4];
    socklen_t addr_len = sizeof(struct sockaddr_in);

    // Create UDP socket
    server_socket = socket(AF_INET, SOCK_DGRAM, 0);
    if (server_socket == -1) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Server address configuration
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_addr.s_addr = INADDR_ANY;
    serveraddress.sin_port = htons(PORT);

    // Bind the socket to the address and port
    if (bind(server_socket, (struct sockaddr *)&serveraddress, sizeof(serveraddress)) < 0) {
        perror("Binding failed");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    printf("Server is ready for clients...\n");

    // Wait for first client message
    recvfrom(server_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&client1_addr, &addr_len);
    printf("Client 1 connected\n");

    // Wait for second client message
    recvfrom(server_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&client2_addr, &addr_len);
    printf("Client 2 connected\n");

    char board[4][4];
    initboard(board);

    // Send initial messages to clients
    sendto(server_socket, "XXX\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
    sendto(server_socket, "OOO\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);

    // Game logic loop
    while (1) {
        // Send messages and receive player moves (use sendto/recvfrom)
        // Example:
        sendto(server_socket, "YTY\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
        recvfrom(server_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&client1_addr, &addr_len);
        
        int x, y;
        sscanf(buffer, "%d %d", &x, &y);
        board[x][y] = 'X';  // Player 1 move
        printf("Player 1 move: %d %d\n", x, y);
        char clientmessage[4];
        clientmessage[0]=x+'0';
        clientmessage[1]=y+'0';
        clientmessage[2]='F';
        clientmessage[3]='U';

        
        sendto(server_socket, clientmessage, sizeof(clientmessage), 0, (struct sockaddr *)&client2_addr, addr_len);
        printf("sent clientmessage %s\n",clientmessage);

        // Check for win condition
        int win = checkwin(board);
        int endflag=0;
        if (win) {
            // Handle win/draw conditions here as in the TCP version
            if(win==1)
            {
                sendto(server_socket, "win\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                sendto(server_socket, "los\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                endflag=1;
            }
            else if(win==2)
            {
                sendto(server_socket, "win\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                sendto(server_socket, "los\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                endflag=1;
            }
            else if(win==3)
            {
                sendto(server_socket, "dra\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                sendto(server_socket, "dra\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                endflag=1;
            }
        }
        if(endflag)
        {
            int f1=0,f2=0;
            sendto(server_socket, "Y/N\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
            char arr1[1];
            recvfrom(server_socket, arr1, 1, 0, (struct sockaddr *)&client1_addr, &addr_len);
            if(strstr(arr1,"Y"))
            {
                f1=1;
            }
            sendto(server_socket, "Y/N\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
            memset(buffer, 0, sizeof(buffer));
            recvfrom(server_socket, arr1, 1, 0, (struct sockaddr *)&client2_addr, &addr_len);
            if(strstr(arr1,"Y"))
            {
                f2=1;
            }
            if(f1==1 && f2==1)
            {
                initboard(board);
                sendto(server_socket, "NGN\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                sendto(server_socket, "NGN\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                continue;   
            }
            else
            {
               if(f1==1)
               {
                    sendto(server_socket, "ODW\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                    sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
               }
               if(f2==1)
               {
                    sendto(server_socket, "ODW\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                    sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
               }
               else
               {
                    sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                    sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
               }
               break;
            }
        }
        else
        {
            sendto(server_socket, "NTN\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
            sendto(server_socket, "YTY\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
            recvfrom(server_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&client2_addr, &addr_len);
            sscanf(buffer, "%d %d", &x, &y);
            char clientmessage[4];
            clientmessage[0]=x+'0';
            clientmessage[1]=y+'0';
            clientmessage[2]='F';
            clientmessage[3]='U';
            sendto(server_socket, clientmessage, sizeof(clientmessage), 0, (struct sockaddr *)&client1_addr, addr_len);
            board[x][y] = 'O';  // Player 2 move
            printf("Player 2 move: %d %d\n", x, y);
            win = checkwin(board);
            for(int i=0;i<3;i++)
            {
                for(int j=0;j<3;j++)
                {
                    printf("%c ",board[i][j]);
                }
                printf("\n");
            }
            printf("win %d x %d y %d\n",win,x,y);
            endflag=0;
            if(win==1)
            {
                sendto(server_socket, "win\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                sendto(server_socket, "los\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                endflag=1;
            }
            else if(win==2)
            {
                sendto(server_socket, "win\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                sendto(server_socket, "los\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                endflag=1;
            }
            else if(win==3)
            {
                sendto(server_socket, "dra\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                sendto(server_socket, "dra\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                endflag=1;
            }
            if(endflag)
            {
                int f1=0,f2=0;
                sendto(server_socket, "Y/N\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                sendto(server_socket, "Y/N\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                memset(buffer, 0, sizeof(buffer));
                recvfrom(server_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&client1_addr, &addr_len);
                if(strstr(buffer,"Y"))
                {
                    f1=1;
                }
                memset(buffer, 0, sizeof(buffer));
                recvfrom(server_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&client2_addr, &addr_len);
                if(strstr(buffer,"Y"))
                {
                    f2=1;
                }
                if(f1==1 && f2==1)
                {
                    initboard(board);
                    sendto(server_socket, "NGN\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                    sendto(server_socket, "NGN\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                    continue;   
                }
                else
                {
                    if(f1==1)
                    {
                        sendto(server_socket, "ODW\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                        sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                    }
                    if(f2==1)
                    {
                        sendto(server_socket, "ODW\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                        sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                    }
                    else
                    {
                        sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client1_addr, addr_len);
                        sendto(server_socket, "EEE\n", 4, 0, (struct sockaddr *)&client2_addr, addr_len);
                    }
                    break;
                }

            }

        

      
        }
    }

    close(server_socket);
    return 0;
}
