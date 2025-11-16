#include "codegen.h"
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

static FILE *out = NULL;
static int lblcount = 0;

void codegen_init(const char *filename) {
    out = fopen(filename, "w");
    if (!out) {
        perror("codegen: fopen");
        exit(1);
    }
    fprintf(out, "; Assembly gerado por LixeiraLang\n");
    fprintf(out, "; Registers: R1=organico, R2=reciclavel, R3=temp, R4=temp2\n\n");
}

void codegen_close(void) {
    if (!out) return;
    fprintf(out, "\nHALT\n");
    fclose(out);
    out = NULL;
}

void emit(const char *fmt, ...) {
    if (!out) return;
    va_list ap;
    va_start(ap, fmt);
    vfprintf(out, fmt, ap);
    fprintf(out, "\n");
    va_end(ap);
}

char *new_label(void) {
    char buf[64];
    snprintf(buf, sizeof(buf), "L%d", lblcount++);
    return strdup(buf);
}
