import mmap
import struct
import time
import os

class Sha256AxiXDMA:
    # Direcciones de los registros (ajusta si tu mapeo es diferente)
    REG_H = [0x00, 0x04, 0x08, 0x0C, 0x10, 0x14, 0x18, 0x1C]
    REG_CONTROL = 0x20
    REG_RESULT = 0x24
    REG_WINNER = 0x28
    REG_R = [0x2C, 0x30, 0x34, 0x38]
    
    AXI_PERIPH_OFFSET = 0x10000

    def __init__(self, uio_path="/dev/xdma0_user", map_size=0x20000):
        self.fd = os.open(uio_path, os.O_RDWR | os.O_SYNC)
        self.map_size = map_size
        self.m = mmap.mmap(self.fd, self.map_size, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=0)

    def close(self):
        self.m.close()
        os.close(self.fd)

    def write(self, addr, value):
        self.m.seek(addr+self.AXI_PERIPH_OFFSET)
        self.m.write(struct.pack("<I", value))  # Little endian

    def read(self, addr):
        self.m.seek(addr+self.AXI_PERIPH_OFFSET)
        return struct.unpack("<I", self.m.read(4))[0]

    def set_hash(self, hash_bytes):
        assert len(hash_bytes) == 32
        for i in range(8):
            word = int.from_bytes(hash_bytes[i*4:(i+1)*4], 'big')
            self.write(self.REG_H[i], word)

    def start(self):
        self.write(self.REG_CONTROL, 1)
        time.sleep(0.01)
        self.write(self.REG_CONTROL, 0)

    def wait_finish(self, timeout=5.0):
        t0 = time.time()
        while time.time() - t0 < timeout:
            result = self.read(self.REG_RESULT)
            finish = result & 0x1
            if finish:
                return True
            time.sleep(0.01)
        return False

    def get_password(self, winner):
        pw = b''
        for addr in self.REG_R:
            word = self.read(addr)
            pw += word.to_bytes(4, 'big')
        # Suma el valor de winner (como entero) al resultado interpretado como entero
        pw_int = int.from_bytes(pw, 'big') + winner
        # Convierte de nuevo a bytes (ajusta el tamaño si es necesario)
        pw_bytes = pw_int.to_bytes(len(pw), 'big')
        # Invierte el orden de los bytes
        pw_bytes = pw_bytes[::-1]
        # Decodifica a ASCII, ignorando bytes no válidos
        return pw_bytes.rstrip(b'\x00').decode('ascii', errors='ignore')
    
    def get_winner(self):
        reg = self.read(self.REG_WINNER)
        if reg == 0:
            return None  # Ningún ganador
        return int((reg.bit_length() - 1))
