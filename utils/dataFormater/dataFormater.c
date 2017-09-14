#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_LEN 512
const char _default_out_name[] = "output.txt";

void formatFiles(const char *inFile, const char *outFile);
void errorOn(const char *file);
void showUsage();

int main(int argc, char *argv[])
{
	char inFile[BUF_LEN], outFile[BUF_LEN];

	if (argc < 2) {
		showUsage();
		return 0;
	}

	strcpy(inFile, argv[1]);
	
	if (argc < 3) {
		strcpy(outFile, _default_out_name);
	} else {
		strcpy(outFile, argv[2]);
	}

	formatFiles(inFile, outFile);
	
	return 0;
}

void formatFiles(const char *inFile, const char *outFile) {
	FILE *fin, *fout;
	const char separator = ',';
	char c;
	union {
		char whole;
		struct {
			char lis : 1; // last is space
			char lin : 1; // last is newline
		};
	} flags;

	flags.whole = 0;

	fin = fopen(inFile, "r");
	if (!fin) {
		errorOn(inFile);
	}

	fout = fopen(outFile, "w");
	if (!fout) {
		fclose(fin);
		errorOn(outFile);
	}

	while ( (c = fgetc(fin)) != EOF ) {
		switch (c) {
			case ' ':
			case '\t': {
				flags.lis = 1;
			} break;

			case '\n':
			case '\r': {
				flags.lis = 0;
				flags.lin = 1;
			} break;
				
		  case ',': {
				if (flags.lin) {
					fputc('\n', fout);
				} else if (flags.lis) {
					fputc(',', fout);
				}
				fputc('.', fout);
				flags.lis = 0;
				flags.lin = 0;
			} break;

			default: {
				if (flags.lin) {
					fputc('\n', fout);
				} else if (flags.lis) {
					fputc(',', fout);
				}
				fputc(c, fout);
				flags.lis = 0;
				flags.lin = 0;
			}
		}
	}

	fputc('\n', fout);
	
	fclose(fin);
	fclose(fout);
}

void errorOn(const char *file) {
	fprintf(stderr, "Error openning/creating file %s\n", file);
	exit(1);
}

void showUsage() {
	const char usage[] = "Usage:\n"										\
		"\t ./dataFormatter inputFile [outputFile]\n";
	printf("%s", usage);
}
