import sys
import argparse

def parse_args():
    p = argparse.ArgumentParser(description="VM para LixeiraLang - interpreta program.asm")
    p.add_argument("file", help="arquivo assembly (program.asm)")
    p.add_argument("--caprec", type=int, default=10, help="capacidade reciclavel (default 10)")
    p.add_argument("--caporg", type=int, default=10, help="capacidade organico (default 10)")
    p.add_argument("--tipolixo", type=int, default=1, help="valor do sensor tipoLixo (0 org / 1 rec) (default 1)")
    return p.parse_args()

def load_program(path):
    with open(path, "r", encoding="utf-8") as f:
        lines = [ln.strip() for ln in f.readlines()]
    insts = []
    for ln in lines:
        if not ln or ln.startswith(";"):
            continue
        parts = ln.split()
        insts.append(parts)
    return insts

def build_label_map(insts):
    labels = {}
    for i, ins in enumerate(insts):
        if ins[0] == "LABEL" and len(ins) >= 2:
            name = ins[1]
            labels[name] = i 
    return labels

def reg_name(r):
    if r.upper() in ("R1","R2","R3","R4"):
        return r.upper()
    raise ValueError(f"registro invalido: {r}")

def get_int(token, regs, vars_):
    if token.upper().startswith("R") and token[1:].isdigit():
        return regs[ token.upper() ]
    try:
        return int(token)
    except:
        return vars_.get(token, 0)

def run(insts, labels, sensors):
    regs = {"R1":0, "R2":0, "R3":0, "R4":0}
    vars_ = {} 
    pc = 0
    steps = 0
    max_steps = 1000000
    while pc < len(insts):
        if steps > max_steps:
            print("VM: limite de passos atingido, abortando.")
            break
        steps += 1
        ins = insts[pc]
        pc += 1
        op = ins[0].upper()

        try:
            if op == "LOADSENSOR":
                r = reg_name(ins[1])
                name = ins[2]
                if name == "CAP_RECICLAVEL" or name == "CAP_REC":
                    regs[r] = sensors["CAP_RECICLAVEL"]
                elif name == "CAP_ORGANICO" or name == "CAP_ORG":
                    regs[r] = sensors["CAP_ORGANICO"]
                elif name == "TIPO_LIXO" or name == "TIPO":
                    regs[r] = sensors["TIPO_LIXO"]
                else:
                    regs[r] = sensors.get(name, 0)
            elif op == "LOADVAR":
                r = reg_name(ins[1])
                name = ins[2]
                regs[r] = vars_.get(name, 0)
            elif op == "STOREVAR":
                name = ins[1]
                r = reg_name(ins[2])
                vars_[name] = regs[r]
            elif op == "MOV":
                rd = reg_name(ins[1])
                rs = reg_name(ins[2])
                regs[rd] = regs[rs]
            elif op == "SET":
                rd = reg_name(ins[1])
                val = int(ins[2])
                regs[rd] = val
            elif op == "INC":
                rd = reg_name(ins[1])
                regs[rd] += 1
            elif op == "PRINT":
                tok = ins[1]
                if tok.upper().startswith("R"):
                    print(regs[tok.upper()])
                else:
                    print(get_int(tok, regs, vars_))
            elif op == "JZ":
                r = reg_name(ins[1])
                label = ins[2]
                if regs[r] == 0:
                    if label not in labels:
                        print(f"VM: label {label} não encontrado")
                        return
                    pc = labels[label] + 1
            elif op == "JMP":
                label = ins[1]
                if label not in labels:
                    print(f"VM: label {label} não encontrado")
                    return
                pc = labels[label] + 1
            elif op == "LABEL":
                pass
            elif op in ("EQ","NE","LT","GT","LE","GE"):
                rd = reg_name(ins[1])
                rl = reg_name(ins[2])
                rr = reg_name(ins[3])
                lv = regs[rl]; rv = regs[rr]
                if op == "EQ": regs[rd] = 1 if (lv == rv) else 0
                if op == "NE": regs[rd] = 1 if (lv != rv) else 0
                if op == "LT": regs[rd] = 1 if (lv < rv) else 0
                if op == "GT": regs[rd] = 1 if (lv > rv) else 0
                if op == "LE": regs[rd] = 1 if (lv <= rv) else 0
                if op == "GE": regs[rd] = 1 if (lv >= rv) else 0
            elif op in ("ADD","SUB","MUL","DIV"):
                rd = reg_name(ins[1]); rl = reg_name(ins[2]); rr = reg_name(ins[3])
                lv = regs[rl]; rv = regs[rr]
                if op == "ADD": regs[rd] = lv + rv
                if op == "SUB": regs[rd] = lv - rv
                if op == "MUL": regs[rd] = lv * rv
                if op == "DIV":
                    if rv == 0:
                        print("VM: divisão por zero -> resultado 0")
                        regs[rd] = 0
                    else:
                        regs[rd] = lv // rv
            elif op == "HALT":
                break
            else:
                print(f"VM: instrução desconhecida: {op}")
        except Exception as e:
            print("VM: erro ao executar instrução:", ins, "->", e)
            return

    print("\n-- VM final state --")
    print("Registers:")
    for r in ("R1","R2","R3","R4"):
        print(f"  {r} = {regs[r]}")
    if vars_:
        print("Variables:")
        for k,v in vars_.items():
            print(f"  {k} = {v}")
    print("-- end --")

def main():
    args = parse_args()
    insts = load_program(args.file)
    labels = build_label_map(insts)
    sensors = {
        "CAP_RECICLAVEL": args.caprec,
        "CAP_ORGANICO": args.caporg,
        "TIPO_LIXO": args.tipolixo
    }
    run(insts, labels, sensors)

if __name__ == "__main__":
    main()
