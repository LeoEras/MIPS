#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Funciones
void wordCount(char* address, int sizeLimit);
void NoSpace(char *text);
void Reverse(char *text);
void Menu(char *rut);


void main() {
    char *name;
    system("cmd /c cls");
    printf("\n__________------ PROYECTO ORGANIZACIÓN -------__________ \n\n");
    printf("\n \n Ingresar nombre del archivo (ej: archivo.txt): \n\n");
    scanf("%s", name);
    Menu(name);
}

void Menu(char *rut) {
    int opcion;
    int limit;
    char ret;

    system("cmd /c cls");
    printf("\n__________------          MENU        -------__________ \n\n");
    printf("\n 1. Estadistica.  \n");
    printf(" 2. Generar Archivo sin espacios entre palabras.  \n");
    printf(" 3. Generar Archivo al revés.  \n");
    printf(" 4. Cargar de nuevo Archivo.  \n");
    printf(" 5. Acerca de.\n");
    printf("\n Elegir Opción: \n\n");
    scanf("%d", &opcion);
    switch (opcion) {
        case 1:
            system("cmd /c cls");
            printf("\n__________------     ESTADISTICA     -------__________ \n\n");
            printf("\n Limite de caracteres: \n\n");
            scanf("%d", &limit);
            wordCount(rut, limit);
            break;

        case 2:
            system("cmd /c cls");
            printf("\n__________------ARCHIVO SIN ESPACIOS-------__________ \n\n");
            NoSpace(rut);
            break;

        case 3:
            system("cmd /c cls");
            printf("\n__________------  ARCHIVO AL REVES  -------__________ \n\n");
            Reverse(rut);
            break;

        case 4:
            main();
            break;

        case 5:
            system("cmd /c cls");
            printf("\n\n____---- Organización y Arquitectura de Computadores ----____\n\t\tProyecto del Primer Parcial\n\n\tDesarrolladores: \n\t\tLeonardo Eras Delgado\n\t\tJuan Garcia Cedeno\n\t\tVanessa Robles Solís\n\n");
            printf("Desea volver al Menú(s/n): \n");
            scanf("%s", &ret);
            if (ret == 's')
                Menu(rut);
            else
                exit(1);
		default:
			printf("Ha ingresado un valor no valido\n");
			break;		
    }
}

/*
wordCount: Imprime el número de palabras en el archivo, y el número de palabras con más de "sizeLimit"(arg2) caracteres; 
"Address"(arg1) indica la dirección absoluta del archivo a leer.
*/

void wordCount(char* address, int sizeLimit)  
{
	FILE *f = fopen(address,"r"); 
	int character;
	int characterCount = 0;
	int wordsOverLimit = 0;	
	int wordCount = 1;
	char ret;
	
	if (f == NULL)
	{
		printf("Error opening file!\n");
		exit(1);
	}
	
	while((character = fgetc(f)) != EOF)
	{
		characterCount++;
		if(character == 32 || character == '\n') 
		{
			character = getc(f);
			if(character!=EOF && character!= 32 && (character>=65 && character <=90 || character >=97 && character <=122 || character >=48 && character <=57))
			{
				wordCount++;
				if(characterCount > sizeLimit)
				{
					wordsOverLimit++;
				}
				characterCount=0;
			}
			ungetc(character, f);			
		}
	}
	printf("\nPalabras con mas de %i caracteres: %d \nNumero de palabras: %d \n",sizeLimit,wordsOverLimit,wordCount);
	fclose(f);
 	printf("Desea volver al Menú(s/n): \n");
 	scanf("%s", &ret);
 	if (ret == 's')
        	Menu(address);
    	else
        	exit(1);
}

void NoSpace(char *original){
	FILE *f = fopen(original, "r");
	FILE *g = fopen("sinespacios.txt", "w");
	char c = 0;
	char ret;
	if (f == NULL)
	{
		printf("Error opening file!\n");
		exit(1);
	}
	while (c != EOF){
		if ( (c = fgetc(f)) != -1){
			if (c != 32 && c != 10)
				fprintf(g, "%c", c);
		}
	}
	fclose(g);
	fclose(f);
	printf("\n \n Archivo generado con Exito! \n\n");
    	printf("Desea volver al Menú(s/n): \n");
    	scanf("%s", &ret);
    	if (ret == 's')
		Menu(original);
    	else
        	exit(1);
}

void Reverse(char *original){
	FILE *f = fopen(original, "r");
	FILE *g = fopen("alreves.txt", "w");
	char c = 0;
	char ret;
	char *temp = NULL;
	int cont = 0, i = 0;
	
	temp = (char*)malloc(sizeof(char));

	if (f == NULL)
	{
		printf("Error opening file!\n");
		exit(1);
	}

	while (c != EOF){
		if ((c = fgetc(f)) != -1){
			temp[cont] = c;
			cont++;
			temp = (char*)realloc(temp, (cont + 1) * sizeof(char));
		}
	}

	fclose(f);
	temp[cont] = 0;

	for (i = cont - 1; i > -1; i--)
		fprintf(g, "%c", temp[i]);

	free(temp);
	fclose(g);
	printf("\n \n Archivo generado con Exito! \n\n");
    	printf("Desea volver al Menú(s/n): \n");
    	scanf("%s", &ret);
    	if (ret == 's')
        	Menu(original);
    	else
        	exit(1);
}
