#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>

#define PORT 8080

int main() {
    int client_socket;
    char buffer[4];
    struct sockaddr_in serveraddress;
    socklen_t addr_len = sizeof(struct sockaddr_in);

    // Create UDP socket
    client_socket = socket(AF_INET, SOCK_DGRAM, 0);
    if (client_socket == -1) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Server address configuration
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_port = htons(PORT);
    inet_pton(AF_INET, "127.0.0.1", &serveraddress.sin_addr);

    // Send initial message to server to register
    sendto(client_socket, "Hi", 2, 0, (struct sockaddr *)&serveraddress, addr_len);

    // Receive first message from server
    recvfrom(client_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&serveraddress, &addr_len);

    printf("Server message: %s\n", buffer);
    int xflag = (strstr(buffer, "X") != NULL);

    char board[3][3];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            board[i][j] = '.';
        }
    }
    for(int i=0;i<3;i++)
    {
        for(int j=0;j<3;j++)
        {
            printf("%c ",board[i][j]);
        }
        printf("\n");
    }

    // Game loop
    while (1) {
        recvfrom(client_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&serveraddress, &addr_len);
        
        if (strstr(buffer, "win")) {
            printf("You win!\n");
            // break;
        } else if (strstr(buffer, "los")) {
            printf("You lose!\n");
            // break;
        } else if (strstr(buffer, "dra")) {
            printf("It's a draw!\n");
            // break;
        } else if (strstr(buffer, "YTY")) {
            // Player's turn to make a move
            printf("Your turn\n");
            int x, y;
            int flag=1;
             while(flag)
            {

                printf("Enter x and y\n");
                scanf("%d %d",&x,&y);
                // printf("enetered x %d y %d\n",x,y);
                // for(int i=0;i<3;i++)
                // {
                //     for(int j=0;j<3;j++)
                //     {
                //         printf("%c ",board[i][j]);
                //     }
                //     printf("\n");
                // }
                // printf("Board[x][y] %c\n",board[x][y]);
                if(x>=0 && x<3 && y>=0 && y<3 && board[x][y]=='.')
                {
                    if(xflag==1)
                    {
                        board[x][y]='X';
                    }
                    else
                    {
                        board[x][y]='O';
                    }
                    flag=0;
                }
                else
                {
                    printf("Invalid move\n");
                }
            }
            for(int i=0;i<3;i++)
            {
                for(int j=0;j<3;j++)
                {
                    printf("%c ",board[i][j]);
                }
                printf("\n");
            }
            char arr[4];
            arr[0]=x+'0';
            arr[1]=' ';
            arr[2]=y+'0';
            arr[3]='\0';
            sendto(client_socket, arr, sizeof(arr), 0, (struct sockaddr *)&serveraddress, addr_len);
            // sprintf(buffer, "%d %d\n", x, y);
            // sendto(client_socket, buffer, sizeof(buffer), 0, (struct sockaddr *)&serveraddress, addr_len);
        }
        else if(strstr(buffer,"NTN"))
        {
            printf("Opponent's turn\n");
        }
        else if(strstr(buffer,"Y/N"))
        {
            printf("Do you want to play again? (Y/N)\n");
            char d[1];
            scanf("%s",d);
            sendto(client_socket, d, 1, 0, (struct sockaddr *)&serveraddress, addr_len);
        }
        else if(strstr(buffer,"NGN"))
        {
            printf("New game\n");
            for(int i=0;i<3;i++)
            {
                for(int j=0;j<3;j++)
                {
                    board[i][j]='.';
                }
            }
            for(int i=0;i<3;i++)
            {
                for(int j=0;j<3;j++)
                {
                    printf("%c ",board[i][j]);
                }
                printf("\n");
            }
        }
        else if(strstr(buffer,"FU"))
        {
            if(xflag==1)
            {
                board[buffer[0]-'0'][buffer[1]-'0']='O';
            }
            else
            {
                board[buffer[0]-'0'][buffer[1]-'0']='X';
            }
            for(int i=0;i<3;i++)
            {
                for(int j=0;j<3;j++)
                {
                    printf("%c ",board[i][j]);
                }
                printf("\n");
            }
        }
        else if(strstr(buffer,"ODW"))
        {
            printf("Opponent does not want to play again\n");
            break;
        }
        else if(strstr(buffer,"EEE"))
        {
            printf("Exiting\n");
            break;
        }
    }

    close(client_socket);
    return 0;
}
