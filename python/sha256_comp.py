import hashlib
import sys

def main():
    if len(sys.argv) != 2:
        print("Uso: python sha256.py <texto>")
        sys.exit(1)

    text = sys.argv[1]
    text_bytes = text.encode('utf-8')
    hash_object = hashlib.sha256(text_bytes)
    hash_hex = hash_object.hexdigest()

    print(f"SHA-256 de '{text}': {hash_hex}")

if __name__ == "__main__":
    main()