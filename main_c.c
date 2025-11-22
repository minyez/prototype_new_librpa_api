#include "librpa.h"
#include "librpa_handler.h"

#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    LibrpaHandler *h;
    h = librpa_create_handler();
    int a = get_value(h);
    printf("%d\n", a);
    librpa_destroy_handler(h);
    return EXIT_SUCCESS;
}
