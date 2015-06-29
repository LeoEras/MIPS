#include <stdio.h>

//Funciones
void wordCount(char* address, int sizeLimit);
void NoSpace(char *text);
void Reverse(char *text);


void main()
{
	//Menu
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
}

void NoSpace(char *original){
	FILE *f = fopen(original, "r");
	FILE *g = fopen("sinespacios.txt", "w");
	char c = 0;
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
}

void Reverse(char *original){
	FILE *f = fopen(original, "r");
	FILE *g = fopen("alreves.txt", "w");
	char c = 0;
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
}