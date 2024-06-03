import os

def to_bin(value, bits):
    return format(value, f'0{bits}b') if value is not None else '0' * bits

class Instruction:
    def __init__(self, opcode, rs=None, rd=None, rt=None, func=None, immediate=None):
        self.opcode = opcode
        self.rs = rs
        self.rd = rd
        self.rt = rt
        self.func = func
        self.immediate = immediate

    def __str__(self):
        if self.func is not None:
            return to_bin(self.opcode, 6) + to_bin(self.rs, 5) + to_bin(self.rd, 5) + to_bin(self.rt, 5) + '00000' + to_bin(self.func, 6)
        else:
            return to_bin(self.opcode, 6) + to_bin(self.rs, 5) + to_bin(self.rd, 5) + to_bin(self.immediate, 16)

class InstructionSet:
    def __init__(self):
        self.instructions = []
        self.instruction_map = {
            'add': (0b100000, 0b110000),
            'sub': (0b100000, 0b110001),
            'and': (0b100000, 0b110010),
            'not': (0b100000, 0b110100),
            'or':  (0b100000, 0b110011),
            'sra': (0b100000, 0b111000),
            'sll': (0b100000, 0b111010),
            'srl': (0b100000, 0b111001),
            'rol': (0b100000, 0b111100),
            'ror': (0b100000, 0b111101),
            'li':  (0b111000, None),
            'lui': (0b111001, None),
            'addi':(0b110000, None),
            'andi':(0b110010, None),
            'ori': (0b110011, None),
            'b':   (0b111111, None),
            'beq': (0b010000, None),
            'bne': (0b010001, None),
            'lb':  (0b000011, None),
            'sb':  (0b000111, None),
            'lw':  (0b001111, None),
            'sw':  (0b011111, None),
        }

    def add_instruction(self, name, rd, rs, rt_or_imm=None):
        if name in self.instruction_map:
            opcode, func = self.instruction_map[name]
            if func is not None:
                instruction = Instruction(opcode, rs, rd, rt_or_imm, func)
            else:
                instruction = Instruction(opcode, rs, rd, immediate=rt_or_imm)
            self.instructions.append(instruction)
        else:
            raise ValueError(f"Instruction {name} not recognized")

    def to_coe_format(self):
        coe_lines = ["memory_initialization_radix=2;", "memory_initialization_vector="]
        coe_lines += [str(inst) + ";" for inst in self.instructions]
        return "\n".join(coe_lines)

    def li(self, rd, immediate):
        self.add_instruction('li', rd, 0, immediate)

    def add(self, rd, rs, rt):
        self.add_instruction('add', rd, rs, rt)

    def sub(self, rd, rs, rt):
        self.add_instruction('sub', rd, rs, rt)

    def and_(self, rd, rs, rt):
        self.add_instruction('and', rd, rs, rt)

    def not_(self, rd, rs):
        self.add_instruction('not', rd, rs)

    def or_(self, rd, rs, rt):
        self.add_instruction('or', rd, rs, rt)

    def sra(self, rd, rs, rt):
        self.add_instruction('sra', rd, rs, rt)

    def sll(self, rd, rs, rt):
        self.add_instruction('sll', rd, rs, rt)

    def srl(self, rd, rs, rt):
        self.add_instruction('srl', rd, rs, rt) 

    def rol(self, rd, rs, rt):
        self.add_instruction('rol', rd, rs, rt)

    def ror(self, rd, rs, rt):
        self.add_instruction('ror', rd, rs, rt)

    def lui(self, rd, immediate):
        self.add_instruction('lui', rd, 0, immediate)

    def addi(self, rd, rs, immediate):
        self.add_instruction('addi', rd, rs, immediate)

    def andi(self, rd, rs, immediate):
        self.add_instruction('andi', rd, rs, immediate)

    def ori(self, rd, rs, immediate):
        self.add_instruction('ori', rd, rs, immediate)

    def b(self, immediate):
        self.add_instruction('b', 0, 0, immediate)

    def beq(self, rs, rt, immediate):
        self.add_instruction('beq', 0, rs, rt, immediate)

    def bne(self, rs, rt, immediate):
        self.add_instruction('bne', 0, rs, rt, immediate)

    def lb(self, rd, rs, immediate):
        self.add_instruction('lb', rd, rs, immediate)

    def sb(self, rd, rs, immediate):
        self.add_instruction('sb', rd, rs, immediate)

    def lw(self, rd, rs, immediate):
        self.add_instruction('lw', rd, rs, immediate)

    def sw(self, rd, rs, immediate):
        self.add_instruction('sw', rd, rs, immediate)

def main():
    iset = InstructionSet()
    iset.lui(1, 11)
    iset.lui(2, 12)
    iset.lui(3, 13)
    iset.add(4, 1, 2)
    iset.sub(5, 1, 2)
    iset.and_(6, 1, 2)
    iset.not_(7, 1)
    iset.or_(8, 1, 2)
    
    coe_content = iset.to_coe_format()

    # Determine the directory of the current script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    coe_path = os.path.join(script_dir, 'instructions.coe')

    with open(coe_path, 'w') as coe_file:
        coe_file.write(coe_content)

if __name__ == "__main__":
    main()
