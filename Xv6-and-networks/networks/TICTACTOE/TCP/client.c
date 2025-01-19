
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>


#define PORT 8080

int main()
{
    int clientfd=0;
    char buffer[4];
    struct sockaddr_in serveraddress;
    memset(buffer, 0, sizeof(buffer));
    clientfd = socket(AF_INET, SOCK_STREAM, 0);
    if (clientfd == -1)
    {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    serveraddress.sin_family = AF_INET;
    serveraddress.sin_port = htons(PORT);
    if(inet_pton(AF_INET, "127.0.0.1", &serveraddress.sin_addr)<=0)
    {
        perror("Invalid address/ Address not supported");
        exit(EXIT_FAILURE);
    }
    if (connect(clientfd, (struct sockaddr *)&serveraddress, sizeof(serveraddress)) < 0)
    {
        perror("Connection Failed");
        exit(EXIT_FAILURE);
    }
    recv(clientfd, buffer, sizeof(buffer), 0);
    // printf("Recieved buffer %s\n",buffer);
    int xflag=0;
    if(strstr(buffer,"X"))
    {
        printf("You are X\n");
        xflag=1;
    }
    else
    {
        printf("You are O\n");
    }
    char board[3][3];
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
    
    while(1)
    {
        recv(clientfd, buffer, sizeof(buffer), 0);
        // send(clientfd,"ACK",3,0);
        // printf("received buffer %s\n",buffer);
        if(strstr(buffer,"win"))
        {
            printf("You win\n");
            memset(buffer, 0, sizeof(buffer));
            // break;
        }
        else if(strstr(buffer,"los"))
        {
            printf("You lose\n");
            memset(buffer, 0, sizeof(buffer));
            // break;
        }
        else if(strstr(buffer,"dra"))
        {
            printf("Draw\n");
            memset(buffer, 0, sizeof(buffer));
            // break;
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
            memset(buffer, 0, sizeof(buffer));

        }
        else if(strstr(buffer,"YTY"))
        {
            printf("Your turn\n");
            int flag=1;
            int x,y;
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
            // printf("sending %s\n",arr);
            send(clientfd,arr,4,0);
            memset(buffer, 0, sizeof(buffer));
        
            // send()
        }
        else if(strstr(buffer,"NTN"))
        {
            printf("Opponent's turn\n");
            memset(buffer, 0, sizeof(buffer));
        }
        else if(strstr(buffer,"Y/N"))
        {
            printf("Do you want to play again? (Y/N)\n");
            char d[1];
            scanf("%s",d);
            send(clientfd,d,1,0);
            memset(buffer, 0, sizeof(buffer));
            
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
            memset(buffer, 0, sizeof(buffer));
        }
        else if(strstr(buffer,"EEE"))
        {
            printf("Exiting\n");
            memset(buffer, 0, sizeof(buffer));  
            break;
        }
        else if(strstr(buffer,"ODW"))
        {
            printf("Opponent does not want to play again\n");
            memset(buffer, 0, sizeof(buffer));
            break;
        }
        // else
        // {
        //    // convert string to board

        //    //00 is 1st char 01 is second 02 is third
        //    int iterator=0;
        //    for(int i=0;i<3;i++)
        //    {
        //        for(int j=0;j<3;j++)
        //        {
        //             char c=',';
        //             while(c!=',')
        //             {
        //                 c=buffer[iterator];
        //                 iterator++;
        //                 if(c=='.'|| c=='X' || c=='O')
        //                 {
        //                     break;
        //                 }
        //                 else
        //                 {
        //                     c=',';
        //                 }
        //             }
        //             board[i][j]=buffer[i*3+j];
                   
        //        }
        //    }
        //    for(int i=0;i<3;i++)
        //    {
        //        for(int j=0;j<3;j++)
        //        {
        //            printf("%c ",board[i][j]);
        //        }
        //        printf("\n");
        //    }
        // }

    }
    close(clientfd);




    
}