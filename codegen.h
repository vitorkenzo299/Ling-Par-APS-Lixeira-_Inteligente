#ifndef CODEGEN_H
#define CODEGEN_H

void codegen_init(const char *filename);
void codegen_close(void);
void emit(const char *fmt, ...);
char *new_label(void);

#endif
