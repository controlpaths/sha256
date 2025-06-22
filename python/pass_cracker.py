import os
import struct
import time
import sys
from SHA256AxiXDMA import Sha256AxiXDMA

if len(sys.argv) < 2:
    print(f"Uso: {sys.argv[0]} <hash_hex>")
    sys.exit(1)

hash_hex = sys.argv[1]
if len(hash_hex) != 64:
    print("El hash debe tener 64 caracteres hexadecimales (256 bits).")
    sys.exit(1)

driver = Sha256AxiXDMA("/dev/xdma0_user", 0x20000)
try:
    driver.set_hash(bytes.fromhex(hash_hex))
    driver.start()
    if driver.wait_finish(300):
        print("Password:", driver.get_password(driver.get_winner()))
    else:
        print("Timeout esperando finish")
finally:
    driver.close()