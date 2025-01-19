
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>
#define PORT 8080







void initboard(char board[4][4])
{
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<4;j++)
        {
            board[i][j]='.';
        }
    }
}
int checkwin(char board[4][4]) {
    // draw condition
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

int main()
{
    int server_socket;
    int client1, client2;
    struct sockaddr_in serveraddress;
    char buffer[4];
    server_socket = socket(AF_INET, SOCK_STREAM, 0);
    char board[4][4];
    if (server_socket == -1)
    {
       printf ("Socket creation failed...\n");
        exit(0);
    }
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_addr.s_addr = INADDR_ANY;
    serveraddress.sin_port = htons(PORT);
    // bind
   
    // i want to make my port reuseable
    int opt = 1;
    if (setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) < 0) {
        perror("setsockopt failed");
        exit(EXIT_FAILURE);
    }

    if (bind(server_socket, (struct sockaddr *)&serveraddress, sizeof(serveraddress)) < 0) {
    perror("Binding failed");  // This will print the specific error
    close(server_socket);
    exit(EXIT_FAILURE);
    }
    // listen
    if (listen(server_socket, 100) == 0)
        printf("Listening....\n");
    else
    {
        perror("Error in listening.\n");
        exit(0);
    }
    // accept
    socklen_t len = sizeof(serveraddress);
    client1 = accept(server_socket, (struct sockaddr *)&serveraddress, &len);
    if (client1 < 0)
    {
        printf("Server accceptance failed...\n");
        close(server_socket);
        exit(0);
    }
    printf("Server acccepted the client1...\n");
    client2=accept(server_socket,(struct sockaddr *)&serveraddress,&len);
    if(client2<0)
    {
        printf("Server accceptance failed...\n");
        close(server_socket);
        exit(0);
    }
    printf("Server acccepted the client2...\n");
    initboard(board);
    memset(buffer, 0, sizeof(buffer));
    send(client1,"XXX\n",4,0);
    send(client2,"OOO\n",4,0);

    // convert board to string
    // char converted_board[9];
    // for(int i=1;i<=3;i++)
    // {
    //     for(int j=1;j<=3;j++)
    //     {
    //         converted_board[(i-1)*3+j-1]=board[i][j];
    //     }
    // }

    while(1)
    {

        // send(client1,converted_board,9,0);
        // recv(client1,buffer,sizeof(buffer),0);
        // printf("converted board %s\n",converted_board);
        // printf("sent board to client1\n");

        // send(client2,converted_board,9,0);
        // recv(client2,buffer,sizeof(buffer),0);

        //  printf("converted board %s\n",converted_board);
        // printf("sent board to client2\n");
        send(client1,"YTY\n",4,0);
        // recv(client1,buffer,sizeof(buffer),0);
        printf("sent YT to client1\n");
        send(client2,"NTN\n",4,0);
        // recv(client2,buffer,sizeof(buffer),0);
        printf("sent NT to client2\n");
        if(recv(client1,buffer,sizeof(buffer),0)<0)
        {
            perror("recv failed");
            break;
        }
        int x,y;
        sscanf(buffer, "%d %d", &x, &y);
        printf("received buffer %s\n",buffer);
        board[x][y]='X';
        char clientmessage[4];
        clientmessage[0]=x+'0';
        clientmessage[1]=y+'0';
        clientmessage[2]='F';
        clientmessage[3]='U';

        send(client2,clientmessage,4,0);
        printf("sent clientmessage %s\n",clientmessage);

        int win=checkwin(board);
        for(int i=0;i<3;i++)
        {
            for(int j=0;j<3;j++)
            {
                printf("%c ",board[i][j]);
            }
            printf("\n");
        }
        printf("win %d x %d y %d\n",win,x,y);

        int endflag=0;
        if(win==1)
        {
            send(client1,"win\n",4,0);
            // recv(client1,buffer,sizeof(buffer),0);
            send(client2,"los\n",4,0);
            // recv(client2,buffer,sizeof(buffer),0);
            endflag=1;

            
        }
        else if(win==2)
        {
            send(client2,"win\n",4,0);
            // recv(client2,buffer,sizeof(buffer),0);
            send(client1,"los\n",4,0);
            // recv(client1,buffer,sizeof(buffer),0);
            endflag=1;
        }
        else if(win==3)
        {
            send(client1,"dra\n",4,0);
            // recv(client1,buffer,sizeof(buffer),0);
            send(client2,"dra\n",4,0);
            // recv(client2,buffer,sizeof(buffer),0);
            endflag=1;
        }
        if(endflag)
        {
            int f1=0,f2=0;
            send(client1,"Y/N\n",4,0);
            char arr1[1];
            
            recv(client1,arr1,1,0);
            if(strstr(arr1,"Y"))
            {
                f1=1;
            }
            send(client2,"Y/N\n",4,0);
            recv(client2,arr1,1,0);
            if(strstr(arr1,"Y"))
            {
                f2=1;
            }
            // memset(buffer, 0, sizeof(buffer));
  
            // recv(client1,buffer,sizeof(buffer),0);
            // if(strstr(buffer,"Y"))
            // {
            //     f1=1;
            // }
            // memset(buffer, 0, sizeof(buffer));
            // recv(client2,buffer,sizeof(buffer),0);
            // if(strstr(buffer,"Y"))
            // {
            //     f2=1;
            // }
            if(f1==1 && f2==1)
            {
                initboard(board);
                send(client1,"NGN\n",4,0);
                send(client2,"NGN\n",4,0);
                continue;
            }
            else
            {
                if(f1==1)
                {
                    send(client1,"ODW\n",4,0);
                    send(client2,"EEE\n",4,0);


                }
                else if(f2==1)
                {
                    send(client2,"ODW\n",4,0);
                    send(client1,"EEE\n",4,0);
                }
                else 
                {
                    send(client1,"EEE\n",4,0);
                    send(client2,"EEE\n",4,0);
                }
                break;

            }
        }
        else
        {
            memset(buffer, 0, sizeof(buffer));
            // convert board to string
            // for(int i=1;i<=3;i++)
            // {
            //     for(int j=1;j<=3;j++)
            //     {
            //         converted_board[(i-1)*3+j-1]=board[i][j];
            //     }
            // }
            // send(client1,converted_board,16,0);
            // recv(client1,buffer,sizeof(buffer),0);
            // send(client2,converted_board,16,0);
            // recv(client2,buffer,sizeof(buffer),0);

            send(client2,"YTY\n",4,0);
            // recv(client2,buffer,sizeof(buffer),0);
          

            send(client1,"NTN\n",4,0);
            // recv(client1,buffer,sizeof(buffer),0);
            if(recv(client2,buffer,sizeof(buffer),0)<0)
            {
                perror("recv failed");
                break;
            }
            // sscanf(buffer, "%d %d", &x, &y);
              char clientmessage[4];
            sscanf(buffer, "%d %d", &x, &y);
            // board[x][y]='O';
            clientmessage[0]=x+'0';
            clientmessage[1]=y+'0';
            clientmessage[2]='F';
            clientmessage[3]='U';
            send(client1,clientmessage,4,0);
            board[x][y]='O';
            win=checkwin(board);
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
                send(client1,"win\n",4,0);
                send(client2,"los\n",4,0);
                endflag=1;
            }
            else if(win==2)
            {
                send(client2,"win\n",4,0);
                send(client1,"los\n",4,0);
                endflag=1;
            }
            else if(win==3)
            {
                send(client1,"dra\n",4,0);
                send(client2,"dra\n",4,0);
                endflag=1;
            }
            if(endflag)
            {
                send(client1,"Y/N\n",4,0);
                send(client2,"Y/N\n",4,0);
                memset(buffer, 0, sizeof(buffer));
                int f1=0,f2=0;
                recv(client1,buffer,sizeof(buffer),0);
                if(strstr(buffer,"Y"))
                {
                    f1=1;
                }
                memset(buffer, 0, sizeof(buffer));
                recv(client2,buffer,sizeof(buffer),0);
                if(strstr(buffer,"Y"))
                {
                    f2=1;
                }
                if(f1==1 && f2==1)
                {
                    initboard(board);
                    send(client1,"NGN\n",4,0);
                    send(client2,"NGN\n",4,0);
                    continue;
                }
                else
                {
                    if(f1==1)
                    {
                        send(client1,"ODW\n",4,0);
                        send(client2,"EEE\n",4,0);
                    }
                    else if(f2==1)
                    {
                        send(client2,"ODW\n",4,0);
                        send(client1,"EEE\n",4,0);
                    }
                    else 
                    {
                        send(client1,"EEE\n",4,0);
                        send(client2,"EEE\n",4,0);
                    }
                    break;
                }
            }

        }
    }
    close(server_socket);
    close(client1);
    close(client2);




  
    return 0;
   

    
}