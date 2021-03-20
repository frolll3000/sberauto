def find_vin(texts, vin="*"):
    for v in texts:
        if vin in str(v):
            print('Вин найден')
            return v[0:4]
        else:
            print('Вин не найден')
