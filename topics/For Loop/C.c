#include <stdio.h>

/* foreach macro viewing a string as a collection of char values */
#define foreach(ptrvar, strvar) \
char* ptrvar; \
for (ptrvar = strvar; (*ptrvar) != '\0'; *ptrvar++)

int main(int argc, char** argv) {
 char* s1 = "abcdefg";
 char* s2 = "123456789";
 foreach (p1, s1) {
  printf("loop 1: %c\n", *p1);
 }
 foreach (p2, s2) {
  printf("loop 2: %c\n", *p2);
 }
 return 0;
}