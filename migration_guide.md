# Migracja Lampy LED z ESPHome na Tasmota (Matter)

Poniżej znajduje się kompletny plan migracji dla Twojej płytki ESP32-C3 Super Mini.

## 1. Wgrywanie Tasmota
Musisz wgrać wersję Tasmota obsługującą **Matter** oraz **ESP32-C3**.
- Pobierz: `tasmota32c3-matter.bin` (lub po prostu `tasmota32c3.bin` jeśli nowsza wersja ma już Matter w standardzie, ale dedykowana wersja `matter` jest pewniejsza).
- Narzędzie: [Tasmota Web Installer](https://tasmota.github.io/install/) (wybierz ESP32-C3).

## 2. Konfiguracja Szablonu (Template)
Po wgraniu i podłączeniu do WiFi, wejdź w **Configuration -> Configure Other** i wklej poniższy Template. Jeśli wolisz ręcznie: **Configuration -> Configure Template**.

**Template JSON:**
```json
{"NAME":"LED Lamp RGBCCT","GPIO":[0,0,0,420,419,417,416,576,0,0,418,0,0,0,0,0,0,0,0,0,0,0],"FLAG":0,"BASE":1}
```
*Uwaga: Powyższy JSON jest generowany orientacyjnie. Pewniejsza jest konfiguracja ręczna według poniższej tabeli, ponieważ mapowanie pinów w JSON zależy od wersji bazy ESP32-C3.*

**Konfiguracja Ręczna (Zalecana):**
Wejdź w **Configuration -> Configure Template**:
- **Name:** LED Lamp
- **GPIO0:** `User` (lub `None`) - *Obsługa w skrypcie Berry*
- **GPIO1:** `User` (lub `None`) - *Obsługa w skrypcie Berry*
- **GPIO3:** `PWM 5` (Warm White)
- **GPIO4:** `PWM 4` (Cold White)
- **GPIO5:** `PWM 2` (Green)
- **GPIO6:** `PWM 1` (Red)
- **GPIO7:** `Buzzer`
- **GPIO8:** `None`
- **GPIO9:** `None`
- **GPIO10:** `PWM 3` (Blue)
- **GPIO20/21:** `None` (RX/TX)

Zaznacz **"Activate"** i zapisz.

## 3. Komendy Wstępne (Console)
Wejdź w **Console** i wklej poniższe komendy (linia po linii):

```bash
# Ustawienie PWM na 4000Hz (jak w ESPHome)
PwmFrequency 4000

# Włączenie obsługi Matter (jeśli dostępne w buildzie)
SetOption138 1

# Ustawienie strefy czasowej (opcjonalne)
Timezone 99

# Zapisanie
SaveData 1
```

## 4. Logika Przycisków i Funkcje (Berry)
Logika przycisków (krótkie, długie, podwójne kliknięcia) oraz "Child Lock" zostały przeniesione do skryptu Berry (`autoexec.be`). Tasmota natywnie nie obsługuje tak złożonych "Dual Hold" logicznie w prostych Regułach.

1. W menu Tasmota wejdź w **Consoles -> Manage File system**.
2. Utwórz nowy plik o nazwie `autoexec.be`.
3. Wklej zawartość pliku `autoexec.be` (wygenerowanego w tym projekcie).
4. Zapisz i zrestartuj urządzenie.

## 5. Obsługa Matter
Po wpisaniu `SetOption138 1` i restarcie:
- W konsoli powinieneś widzieć logi startu Matter.
- Kod parowania (QR Code) można wygenerować komendą `MatterConfig`.
- Wpisz w konsoli: `MatterConfig` aby zobaczyć kod tekstowy lub URL do QR kodu.
- Sparuj z Apple Home / Google Home / HA.

## 6. Efekty Świetlne
Skrypt ESPHome miał customowe efekty (Zorza, Świeczka). W Tasmota:
- Użyj komendy `Scheme` w konsoli do zmiany efektów.
- `Scheme 2`: Cycle Colors (Tęcza)
- `Scheme 12`: Fire / Candle (jeśli dostępny)
- Możesz też sterować efektami bezpośrednio z Home Assistant po dodaniu przez Matter lub MQTT.

## Uwagi do Skryptu Berry
- Skrypt czyta piny GPIO0 i GPIO1 bezpośrednio.
- Realizuje logikę:
  - Krótki klik L: Ściemnianie
  - Krótki klik P: Rozjaśnianie
  - Długi L (3s): Wyłącz
  - Oba 10s: Child Lock (Sygnał dźwiękowy + blokada guzików)
  - Oba 20s: Reset WiFi (Tryb AP)
- Dźwięki są realizowane przez komendę `Buzzer` i `Rtttl` (melodyjki).




