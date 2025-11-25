# Instrukcja Obsługi – Inteligentna Lampa LED RGBCCT

Dziękujemy za wybór naszej Lampy LED. Jest to specjalistyczne urządzenie zaprojektowane z myślą o **bezpośredniej integracji z systemem Home Assistant**. Lampa łączy w sobie nowoczesne oświetlenie z pełną prywatnością i lokalnym sterowaniem, bez konieczności instalowania zewnętrznych aplikacji chmurowych.

Prosimy o dokładne zapoznanie się z niniejszą instrukcją przed pierwszym uruchomieniem.

---

## Spis Treści
1. [Bezpieczeństwo i Użytkowanie](#1-bezpieczeństwo-i-użytkowanie)
2. [Opis i Budowa Urządzenia](#2-opis-i-budowa-urządzenia)
3. [Pierwsze Uruchomienie i Konfiguracja WiFi](#3-pierwsze-uruchomienie-i-konfiguracja-wifi)
4. [Integracja z Home Assistant](#4-integracja-z-home-assistant)
5. [Sterowanie Manualne (Przyciski)](#5-sterowanie-manualne-przyciski)
6. [Efekty Świetlne](#6-efekty-świetlne)
7. [Rozwiązywanie Problemów](#7-rozwiązywanie-problemów)
8. [Specyfikacja Techniczna](#8-specyfikacja-techniczna)
9. [Warunki Gwarancji](#9-warunki-gwarancji)

---

## 1. Bezpieczeństwo i Użytkowanie

Aby zapewnić bezpieczną i bezawaryjną pracę urządzenia, należy przestrzegać poniższych zasad:

### Ostrzeżenia mechaniczne
*   **UWAGA – PRZENOSZENIE:** Ze względu na dociążoną podstawę i smukłą konstrukcję, lampę należy przenosić **wyłącznie trzymając za dolny korpus (podstawę)**.
    *   **ZAKAZ:** Kategorycznie zabrania się podnoszenia lub przenoszenia lampy trzymając za aluminiowy profil LED. Grozi to trwałym uszkodzeniem mechanicznym urządzenia.

### Środowisko pracy
*   **Lokalizacja:** Lampa przeznaczona jest wyłącznie do użytku wewnątrz pomieszczeń (salon, sypialnia, biuro).
*   **Wilgoć:** Nie wolno używać lampy w pomieszczeniach o wysokiej kondensacji pary wodnej (np. łazienki, sauny) ani w miejscach narażonych na bezpośredni kontakt z wodą.

### Zasilanie i Ochrona
*   **System Zabezpieczeń:** Urządzenie wyposażone jest w **kompleksowy, zintegrowany system ochrony**. Lampa posiada wewnętrzne zabezpieczenia chroniące przed:
    *   Przeciążeniem sieci.
    *   Zwarciem.
    *   Przepięciami.
    *   Przegrzaniem układów elektronicznych.
*   **Termika:** Obudowa lampy posiada zaprojektowane kanały wentylacyjne. Zasilacz wewnętrzny dobrany jest z dużym zapasem mocy (obciążenie <50%), co minimalizuje wydzielanie ciepła.
*   **Zasilanie:** Urządzenie przystosowane jest do standardowej sieci energetycznej (~230V).
*   **Serwis:** Nie otwieraj obudowy urządzenia pod napięciem. Wewnątrz występuje napięcie sieciowe 230V.

---

## 2. Opis i Budowa Urządzenia

Lampa to połączenie nowoczesnego designu z zaawansowaną technologią LED **RGBCCT** (miliony kolorów + pełna regulacja bieli od ciepłej do zimnej).

### Budowa:
*   **Korpus (Podstawa):** Wykonany z wysokiej jakości tworzywa PLA. Podstawa jest specjalnie dociążona, aby zapewnić stabilność wysokiej konstrukcji.
*   **Profil Świetlny:** Wykonany z eleganckiego anodowanego aluminium, zapewniającego chłodzenie diod LED i estetyczny wygląd.

### Elementy sterujące:
Na górnej części podstawy znajdują się dwa przyciski dotykowe oznaczone symbolem **"O"**:

*   **Lewy przycisk "O":** Ściemnianie i Wyłączanie.
*   **Prawy przycisk "O":** Rozjaśnianie i Włączanie.

[TUTAJ RYSUNEK POGLĄDOWY: Strzałka wskazująca, aby chwytać za podstawę, przekreślona strzałka na profilu]

---

## 3. Pierwsze Uruchomienie i Konfiguracja WiFi

Lampa działa w oparciu o sieć WiFi w standardzie **2.4 GHz** (standard obsługiwany przez układ ESP32-C3).

### Metoda 1: Automatyczne wykrycie (Zalecana)
Dzięki obsłudze **Improv Wi-Fi**, konfiguracja jest niezwykle prosta:

1.  Podłącz lampę do zasilania.
2.  Upewnij się, że w telefonie włączony jest **Bluetooth**.
3.  **Ważne:** Sprawdź, czy aplikacja Home Assistant posiada odpowiednie uprawnienia:
    *   **Android:** W ustawieniach systemu dla aplikacji Home Assistant muszą być włączone uprawnienia **"Urządzenia w pobliżu"** (Bluetooth) oraz **"Lokalizacja"**. Bez nich aplikacja nie wykryje lampy.
    *   **iOS:** Aplikacja musi mieć zgodę na użycie Bluetooth.
4.  Uruchom aplikację **Home Assistant** na telefonie.
5.  Przejdź do **Ustawienia -> Urządzenia i usługi**.
6.  W sekcji **"Wykryte"** zobaczysz nowe urządzenie. Kliknij "Skonfiguruj" i postępuj zgodnie z instrukcjami, aby połączyć lampę ze swoim WiFi.

### Metoda 2: Tradycyjna (Access Point)
Jeśli metoda automatyczna nie zadziała (np. brak Bluetooth w urządzeniu sterującym):

1.  Po podłączeniu zasilania odczekaj minutę.
2.  Na telefonie lub komputerze wyszukaj sieć WiFi o nazwie:
    *   **Nazwa sieci (SSID):** `LED Lamp Setup`
    *   **Hasło:** `12345678`
3.  Po połączeniu, automatycznie otworzy się okno konfiguracji. Jeśli nie, wpisz w przeglądarce adres: `192.168.4.1`.
4.  Wybierz swoją domową sieć WiFi z listy i wpisz hasło.
5.  Kliknij "Save". Lampa zrestartuje się i połączy z Twoim domowym WiFi.

*   **Sygnalizacja zasilania:** Tuż po podłączeniu wtyczki lampa wykona szybki **auto-test (krótkie mignięcie światłem)**. Jest to prawidłowy objaw.


---

## 4. Integracja z Home Assistant

To urządzenie zostało stworzone jako "Home Assistant Native". Nie posiada dedykowanej aplikacji na telefon, ponieważ jego naturalnym środowiskiem jest Twój inteligentny dom.

### Jak dodać lampę do Home Assistant?
1.  Upewnij się, że lampa jest połączona z tą samą siecią WiFi co serwer Home Assistant.
2.  Home Assistant zazwyczaj automatycznie wykryje nowe urządzenie **ESPHome**.
3.  Przejdź do **Ustawienia -> Urządzenia i usługi**.
4.  Kliknij **Skonfiguruj** przy wykrytej lampie LED.
5.  Gotowe! Lampa jest teraz w pełni zintegrowana.

### Dostępne funkcje w HA:
*   **Światło:** Pełna kontrola koloru (koło kolorów), jasności i temperatury barwowej.
*   **Efekty:** Wybór jednego z 11 trybów tematycznych.
*   **Minutnik (Sleep):** Funkcja automatycznego wyłączania. Wybierz czas (np. 30 min), a po jego upływie lampa **bardzo powoli (przez 60 sekund) wygasi światło**, co jest idealne do usypiania dzieci bez nagłej ciemności.
*   **Przełączniki:** Zdalne włączanie "Blokady Przycisków" (Child Lock) oraz wyłączanie dźwięków.
*   **Konfiguracja:** Możliwość dostosowania głośności sygnałów dźwiękowych.

---

## 5. Sterowanie Manualne (Przyciski)

Mimo zaawansowanych funkcji smart, lampę można w pełni obsługiwać manualnie za pomocą paneli dotykowych.

| Akcja | Przycisk | Opis działania |
| :--- | :--- | :--- |
| **Włączenie** | Prawy "O" | Pojedyncze dotknięcie włącza lampę lub zwiększa jasność o 15%. |
| **Rozjaśnianie** | Prawy "O" | Każde kolejne dotknięcie zwiększa jasność. |
| **Ściemnianie** | Lewy "O" | Pojedyncze dotknięcie zmniejsza jasność o 15%. |
| **Wyłączenie** | Lewy "O" | **Przytrzymaj lewy przycisk przez 3 sekundy**, aby wyłączyć światło. |

### Funkcje specjalne:

#### Blokada Rodzicielska (Child Lock)
*   **Aktywacja/Dezaktywacja:** Przytrzymaj **OBA przyciski jednocześnie przez 10 sekund**.
*   Lampa potwierdzi zmianę mignięciem na kolor bursztynowy oraz sygnałem dźwiękowym.
*   Gdy blokada jest włączona, przyciski nie reagują na pojedyncze dotknięcia.

#### Reset Fabryczny WiFi
Jeśli zmienisz router lub hasło:
1.  Przytrzymaj **OBA przyciski**.
2.  Po 10s nastąpi zmiana blokady (trzymaj dalej).
3.  Po **20 sekundach** lampa wyda sygnał sukcesu i mignie na niebiesko.
4.  Ustawienia WiFi zostaną skasowane, a lampa przejdzie w tryb parowania (punkt 3 instrukcji).

---

## 6. Efekty Świetlne i Sceny

W panelu sterowania (Home Assistant) masz dostęp do **11 unikalnych trybów**, stworzonych na każdą okazję:

1.  **Zorza:** Relaksujące, powolne przejścia (Fiolet-Niebieski-Zieleń).
2.  **Tęcza:** Płynna pętla wszystkich kolorów, dodająca energii wnętrzu.
3.  **Świeczka:** Subtelna symulacja naturalnego płomienia – idealna do kolacji.
4.  **Maksymalna Jasność:** Tryb zadaniowy – 100% mocy wszystkich diod dla idealnej widoczności.
5.  **Las:** Spokojna zieleń i ciepła biel, imitująca kojące światło przebijające przez korony drzew.
6.  **Ocean:** Dynamiczne falowanie błękitu, turkusu i granatu, przypominające morskie głębiny.
7.  **Impreza:** Szybkie, stroboskopowe zmiany kolorów w rytmie disco – rozkręci każdą domówkę.
8.  **Zachód Słońca:** Romantyczna aura, powoli przechodząca od ciepłego pomarańczu, przez czerwień, aż do wieczornego fioletu.
9.  **Kominek:** Przytulne ciepło domowego ogniska. Głębokie, nasycone czerwienie i pomarańcze bez dymu i popiołu.
10. **Cyberpunk:** Nowoczesny, neonowy styl rodem z filmów sci-fi. Kontrastowe połączenie magenty i cyjanu dla fanów technologii.
11. **Medytacja:** Harmonia oddechu. Światło płynnie "oddycha" (rozjaśnia się i ściemnia) w kojącym, ciepłym rytmie, pomagając Ci się wyciszyć i zasnąć.

---

## 7. Rozwiązywanie Problemów

| Problem | Rozwiązanie |
| :--- | :--- |
| **Lampa krótko błyska przy włożeniu wtyczki** | **To normalne.** Jest to sygnał diagnostyczny potwierdzający poprawne zasilanie układów sterujących. |
| **Nie widzę sieci WiFi lampy** | Upewnij się, że router nadaje sieć w paśmie **2.4 GHz**. Lampa nie obsługuje sieci 5 GHz. |
| **Przyciski nie działają** | Prawdopodobnie włączona jest blokada rodzicielska. Przytrzymaj oba przyciski przez 10s, aby odblokować. |
| **Brak połączenia z Home Assistant** | Sprawdź, czy lampa i serwer HA są w tej samej podsieci. Zrestartuj router. |

---

## 8. Specyfikacja Techniczna

*   **Zasilanie:** 230V AC, 50Hz.
*   **Podłączenie:** Gniazdo IEC C8 ("ósemka") – odłączany przewód zasilający 1.5m (w zestawie).
*   **Pobór mocy:** Max 24W (przy pełnej jasności).
*   **Zasilacz wewnętrzny:** Klasa przemysłowa, sprawność >85% (Obciążenie znamionowe podczas pracy: ~40%).
*   **Materiały:**
    *   Korpus: Biodegradowalne tworzywo PLA (Druk 3D).
    *   Profil: Aluminium anodowane.
*   **Łączność:** WiFi 2.4 GHz (802.11 b/g/n).
*   **Układ sterujący:** ESP32-C3 Super Mini.

### Warunki pracy i przechowywania
*   **Temperatura pracy:** -10°C ~ +35°C (Ważne: Nie zasłaniać otworów wentylacyjnych w podstawie. Nie stawiać na miękkich podłożach typu dywan typu "shaggy", które mogą zablokować dopływ powietrza od dołu).
*   **Wilgotność pracy:** 20% ~ 90% RH (bez kondensacji).

---

## 9. Informacje Prawne i Ekologiczne

### Producent
Produkt wyprodukowany w Polsce przez:  
**[TWOJA NAZWA FIRMY / IMIĘ I NAZWISKO]**  
[ADRES SIEDZIBY]  
[ADRES E-MAIL / KONTAKT]

### Deklaracja Zgodności (CE)
Producent niniejszym deklaruje na wyłączną odpowiedzialność, że urządzenie **LED Lamp RGBCCT** jest zgodne z zasadniczymi wymaganiami unijnych dyrektyw:
*   **2014/35/UE (LVD)** – Dyrektywa Niskonapięciowa.
*   **2014/30/UE (EMC)** – Kompatybilność elektromagnetyczna.
*   **2011/65/UE (RoHS)** – Ograniczenie stosowania substancji niebezpiecznych.
*   **2009/125/WE (ErP)** – Ekoprojekt dla produktów związanych z energią.

Produkt jest oznaczony znakiem CE:
**CE**

### Utylizacja (WEEE)
Symbol przekreślonego kosza na śmieci umieszczony na sprzęcie, opakowaniu lub dokumentach do niego dołączonych oznacza, że produktu nie wolno wyrzucać łącznie z innymi odpadami z gospodarstwa domowego.
*   Obowiązkiem użytkownika jest przekazanie zużytego sprzętu do wyznaczonego punktu zbiórki w celu właściwego jego przetworzenia.
*   Odpowiednia utylizacja pomaga chronić środowisko naturalne.
*   Numer rejestrowy BDO producenta: **[000000000]** (Wpisz swój numer lub "W trakcie rejestracji").

---

## 10. Warunki Gwarancji

1.  Urządzenie objęte jest rękojmią/gwarancją producenta na okres 24 miesięcy.
2.  **Gwarancja obowiązuje wyłącznie pod warunkiem użytkowania urządzenia zgodnie z niniejszą instrukcją.**
3.  Gwarancja nie obejmuje:
    *   Uszkodzeń mechanicznych (w tym wyłamania profilu LED od podstawy).
    *   Odkształceń obudowy spowodowanych postawieniem lampy przy źródłach wysokiego ciepła (kominek, grzejnik) – materiał PLA.
    *   Zalania cieczą lub użytkowania w wilgotnych pomieszczeniach.
    *   Ingerencji w oprogramowanie układowe (z wyjątkiem oficjalnych aktualizacji ESPHome).

---
*Życzymy przyjemnego użytkowania!*
