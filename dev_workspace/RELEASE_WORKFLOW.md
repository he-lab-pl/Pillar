# HEL Pillar - Release Workflow

## Proces wydawania nowej wersji firmware

### 1. Przygotowanie kodu

1. Zaktualizuj wersję w `led-lamp.yaml`:

   ```yaml
   project:
     name: "home-element-lab.pillar"
     version: "2.0"   # musi być zgodne z manifest.json
   ```

2. Przetestuj zmiany lokalnie

### 2. Kompilacja i pobranie pliku OTA

#### ESPHome Dashboard (GUI)

1. Otwórz urządzenie w ESPHome
2. **Install** → **Manual download**
3. Wybierz **„Aktualizacja OTA”** — **NIE** „Obraz fabryczny”
4. Pobierz plik (np. `he-l-pillar-firmware.ota.bin`)

> **Obraz fabryczny** służy tylko do pierwszego flashowania przez USB / ESPHome Web.  
> Do `manifest.json` i aktualizacji przez Home Assistant **zawsze** idzie plik OTA.  
> Zobacz: https://esphome.io/components/ota/http_request/

#### ESPHome CLI

```bash
esphome compile led-lamp.yaml
```

Plik OTA:

```
.esphome/build/he-l-pillar/.pioenvs/he-l-pillar/firmware.ota.bin
```

**Nie używaj:** `firmware.factory.bin`

### 3. Oblicz MD5 (z pliku OTA)

**Windows (PowerShell):**

```powershell
(Get-FileHash -Path "he-l-pillar-firmware.ota.bin" -Algorithm MD5).Hash.ToLower()
```

**Linux/Mac:**

```bash
md5sum he-l-pillar-firmware.ota.bin
```

Hash musi być **32 znaki hex, małymi literami**.

### 4. Upload firmware do GitHub

1. Skopiuj plik OTA do `firmware/he-l-pillar.X.Y.bin` (np. `he-l-pillar.2.0.bin`)
2. Commit i push:

   ```bash
   git add firmware/he-l-pillar.2.0.bin
   git add led-lamp.yaml
   git commit -m "Wydanie firmware v2.0: opis zmian"
   git push origin main
   ```

### 5. Zaktualizuj manifest.json

```json
{
  "name": "HEL Pillar",
  "version": "2.0",
  "url": "https://raw.githubusercontent.com/he-lab-pl/Pillar/main/firmware/he-l-pillar.2.0.bin",
  "release_url": "https://github.com/he-lab-pl/Pillar",
  "summary": "Krótki opis zmian",
  "builds": [
    {
      "chipFamily": "ESP32-C3",
      "ota": {
        "md5": "1511ebf6dcf5deee4717568e15f023ee8",
        "path": "https://raw.githubusercontent.com/he-lab-pl/Pillar/main/firmware/he-l-pillar.2.0.bin",
        "release_url": "https://github.com/he-lab-pl/Pillar",
        "summary": "Krótki opis zmian"
      }
    }
  ]
}
```

Używaj URL `raw.githubusercontent.com` (bez przekierowań).

Commit i push:

```bash
git add manifest.json
git commit -m "Aktualizacja manifestu do v2.0"
git push origin main
```

### 6. Weryfikacja

1. Otwórz w przeglądarce:
   - https://raw.githubusercontent.com/he-lab-pl/Pillar/main/manifest.json
   - https://raw.githubusercontent.com/he-lab-pl/Pillar/main/firmware/he-l-pillar.2.0.bin
2. Sprawdź MD5 pobranego pliku z hashem w manifeście
3. Na urządzeniu testowym: restart lub „Update Check” → Install w HA

### 7. Troubleshooting

**Urządzenie nie wykrywa update**
- Manifest dostępny pod URL?
- `version` w manifeście > `project.version` na urządzeniu?
- Restart / przycisk Update Check

**MD5 mismatch**
- MD5 liczony z pliku **OTA**, nie factory
- Hash małymi literami w `manifest.json`

**HA Install się wywala, Web UI (ręczny upload OTA) działa**
- To różne ścieżki: HA pobiera z GitHuba, Web UI wgrywa lokalnie
- Sprawdź czy w repo jest OTA (nie factory)
- Możliwe: słabe WiFi, timeout HTTP, TLS — zobacz AUTOMATIC_UPDATES.md

**Update się ściąga ale nie instaluje**
- Plik musi być **OTA** (`firmware.ota.bin`)
- Factory w manifeście **nigdy** nie zadziała z `update.http_request`

## Wersjonowanie

Semantic Versioning (X.Y):

- **X** — duże zmiany (np. 1.x → 2.0)
- **Y** — nowe funkcje / poprawki (np. 1.8 → 1.9)

`project.version` w YAML, `version` w manifeście i nazwa pliku (`he-l-pillar.2.0.bin`) powinny być spójne.

## Checklist release

- [ ] `project.version` w `led-lamp.yaml` zaktualizowane
- [ ] Pobrano **Aktualizacja OTA** (nie Obraz fabryczny)
- [ ] MD5 z pliku OTA (małe litery)
- [ ] Plik w `firmware/he-l-pillar.X.Y.bin`
- [ ] `manifest.json` — version, md5, path, summary
- [ ] Commit + push
- [ ] URL-e działają w przeglądarce
- [ ] Test Install z HA na urządzeniu testowym
