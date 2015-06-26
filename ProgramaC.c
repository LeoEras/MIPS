#include <stdio.h>

//Funciones
void wordCount(char* address, int sizeLimit);


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
}