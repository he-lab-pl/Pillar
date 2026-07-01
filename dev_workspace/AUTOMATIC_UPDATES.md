# HEL Pillar - Automatic Updates

## Jak to działa

Urządzenie HEL Pillar sprawdza co 6 godzin, czy na GitHubie jest nowsza wersja firmware (`manifest.json`). Gdy jest — w Home Assistant pojawia się encja **Update** z przyciskiem **Install**.

### Dla użytkowników końcowych

1. **Automatyczna detekcja** — sprawdzanie co 6 h (lub po restarcie / przycisku „Update Check”)
2. **Powiadomienie w HA** — „Update available”
3. **Instalacja jednym klikiem** — Install w encji update

### Dla zespołu (release)

1. Zwiększ `project.version` w `led-lamp.yaml`
2. Skompiluj firmware
3. Pobierz plik **OTA** (nie factory!) — patrz niżej
4. Wrzuć do `firmware/he-l-pillar.X.Y.bin`
5. Zaktualizuj `manifest.json` (version, md5, summary)
6. Commit + push na `main`

## OTA vs Factory — bardzo ważne

ESPHome generuje **dwa różne pliki**. Do `manifest.json` i aktualizacji przez HA **zawsze** używaj OTA.

| Opcja w dashboardzie | Plik | Do czego |
|----------------------|------|----------|
| **Aktualizacja OTA** | `firmware.ota.bin` | Aktualizacja przez sieć (manifest, HA, `update.http_request`) |
| **Obraz fabryczny** | `firmware.factory.bin` | Pierwsze wgranie kablem / ESPHome Web (USB) |

Dawniej nazywano to „Legacy” (OTA) i „Modern” (Factory) — **Modern/Factory to NIE to samo co OTA**.

Dokumentacja ESPHome: [OTA Update via HTTP Request](https://esphome.io/components/ota/http_request/) — *„You cannot use firmware.factory.bin … with this component.”*

### Pobieranie w ESPHome Dashboard

1. Urządzenie → **Install** → **Manual download**
2. Wybierz **„Aktualizacja OTA”** (nie „Obraz fabryczny”)
3. Zapisz np. jako `he-l-pillar-2.0.ota.bin`

### Pobieranie przez CLI

Po `esphome compile led-lamp.yaml`:

```
.esphome/build/he-l-pillar/.pioenvs/he-l-pillar/firmware.ota.bin
```

**MD5 licz z pliku OTA** (małymi literami):

```powershell
(Get-FileHash -Path "firmware.ota.bin" -Algorithm MD5).Hash.ToLower()
```

## Struktura plików

```
/
├── led-lamp.yaml
├── manifest.json
├── firmware/
│   └── he-l-pillar.2.0.bin    # plik OTA (nie factory!)
└── dev_workspace/
    ├── AUTOMATIC_UPDATES.md
    └── RELEASE_WORKFLOW.md
```

## Konfiguracja w led-lamp.yaml

Wymagane komponenty (oba w `ota:`):

```yaml
http_request:

ota:
  - platform: esphome
  - platform: http_request    # wymagane dla update.http_request

update:
  - platform: http_request
    name: "${friendly_name} Firmware"
    source: https://raw.githubusercontent.com/he-lab-pl/Pillar/main/manifest.json
    update_interval: 6h
```

## Weryfikacja po release

- Manifest: https://raw.githubusercontent.com/he-lab-pl/Pillar/main/manifest.json
- Firmware: https://raw.githubusercontent.com/he-lab-pl/Pillar/main/firmware/he-l-pillar.2.0.bin
- MD5 w manifeście musi odpowiadać **dokładnie** plikowi OTA w repo

## Troubleshooting

**Urządzenie nie wykrywa update**
- Sprawdź URL manifestu w przeglądarce
- Restart lampy lub przycisk „Update Check”
- `project.version` w firmware na urządzeniu musi być **niższa** niż `version` w manifeście

**MD5 mismatch**
- Przelicz MD5 z pliku OTA (nie factory)
- Upewnij się, że plik na GitHubie nie został zmieniony po obliczeniu hasha

**Update w HA się wywala, ale ręczne wgranie OTA przez Web UI działa**

To są **dwie różne ścieżki**:
- **HA / manifest** — urządzenie samo pobiera plik z GitHuba (`http_request` + `ota.http_request`)
- **Web UI** — wgrywasz plik z telefonu/komputera bezpośrednio na lampę (lokalny upload)

Możliwe przyczyny problemu z manifestem (bez logów):
1. W manifeście był plik **factory** zamiast OTA (instalacja musi się wywalić)
2. **Słabe WiFi** podczas pobierania ~1,5 MB z internetu (lokalny upload z LAN bywa stabilniejszy)
3. **Timeout `http_request`** (domyślnie 4,5 s) przy wolnej sieci
4. Brak `verify_ssl: false` w starszych buildach / problemy TLS przy HTTPS do GitHub
5. Za mało wolnej pamięci RAM podczas TLS + OTA
6. Update nie był jeszcze wykryty (interwał 6 h) — próba na starym manifeście

**Web UI działa, HA nie — co sprawdzić w kolejnej wersji firmware**
- Dodać `http_request: verify_ssl: false` jeśli problem z certyfikatami (kompromis bezpieczeństwa)
- Zwiększyć `timeout` w `http_request`
- Podnieść `project.version` w YAML do wersji z manifestu (np. `2.0`)

Szczegóły release: [RELEASE_WORKFLOW.md](./RELEASE_WORKFLOW.md)
