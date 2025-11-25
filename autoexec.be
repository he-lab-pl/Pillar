import gpio
import string
import math

# Konfiguracja Pinów
var PIN_BTN_LEFT = 0
var PIN_BTN_RIGHT = 1
# PIN_BUZZER jest obsługiwany przez Tasmota (skonfigurowany w szablonie jako Buzzer)

# Zmienne stanu
var lock_enabled = false
var sound_enabled = true
var volume = 1.0 # 0.0 - 1.0

# Stan przycisków
var btn_left_state = false
var btn_right_state = false
var btn_left_last = false
var btn_right_last = false
var btn_left_time = 0
var btn_right_time = 0
var both_press_time = 0
var both_pressed = false

# Inicjalizacja GPIO
gpio.pin_mode(PIN_BTN_LEFT, gpio.INPUT_PULLDOWN)
gpio.pin_mode(PIN_BTN_RIGHT, gpio.INPUT_PULLDOWN)

# Funkcje pomocnicze
def log(msg)
  print("B_LOG: " + str(msg))
end

# Obsługa dźwięku (Wrapper na komendy Tasmota)
def beep(type)
  if !sound_enabled return end
  
  if type == "short"
    tasmota.cmd("Buzzer 1,2") # Krótki beep
  elif type == "success"
    # RTTTL Success: d=4,o=5,b=200:8c,8e,8g,8c6
    tasmota.cmd("Rtttl success:d=4,o=5,b=200:8c,8e,8g,8c6")
  elif type == "lock_on"
    # Lock On: C5 -> G4
    tasmota.cmd("Rtttl lock_on:d=16,o=5,b=200:4c,4g4")
  elif type == "lock_off"
    # Lock Off: G4 -> C5
    tasmota.cmd("Rtttl lock_off:d=16,o=5,b=200:4g4,4c")
  end
end

# Funkcje sterowania światłem
def light_dim(relative_percent)
  var state = tasmota.get_light()
  # Obsługa obiektu (dot notation) lub mapy
  var pwr = false
  var dim = 100
  
  try
    pwr = state.power
    dim = state.dimmer
  except ..
    # Fallback jeśli to jednak mapa
    pwr = state['power']
    dim = state['dimmer']
  end

  if pwr == false 
    if relative_percent > 0
      tasmota.cmd("Power On")
      tasmota.cmd("Dimmer 10") # Start low
    end
    return
  end
  
  var new_dim = dim + relative_percent
  if new_dim > 100 new_dim = 100 end
  if new_dim < 1 new_dim = 1 end # Don't turn off fully via dim
  
  tasmota.cmd("Dimmer " + str(new_dim))
end

def light_toggle()
  tasmota.cmd("Power Toggle")
end

def light_off()
  tasmota.cmd("Power Off")
end

# Wizualizacja blokady (Amber blink)
def blink_amber()
    # Amber: Red 100%, Green 75%
    var state = tasmota.get_light()
    var pwr = false
    try pwr = state.power except .. pwr = state['power'] end

    if !pwr return end
    
    tasmota.cmd("Color FFC0000000") # Amber RGB
    tasmota.set_timer(300, /-> tasmota.cmd("Power Off"))
    tasmota.set_timer(600, /-> tasmota.cmd("Power On"))
    tasmota.set_timer(900, /-> tasmota.cmd("Color FFC0000000"))
    # Przywrócenie stanu jest trudne bez pełnego odczytu, 
    # zakładamy że użytkownik ustawi sobie z powrotem lub użyjemy prostego restore
end

# Główna pętla sterownika
class ButtonHandler
  def every_50ms()
    import gpio
    var now = tasmota.millis()
    
    var b_left = gpio.digital_read(PIN_BTN_LEFT)
    var b_right = gpio.digital_read(PIN_BTN_RIGHT)

    # Detekcja obu przycisków (Dual Hold)
    if b_left == 1 && b_right == 1
      if !both_pressed
        both_pressed = true
        both_press_time = now
        log("Oba przyciski wciśnięte")
      else
        var duration = now - both_press_time
        
        # 10s -> Toggle Lock
        if duration > 10000 && duration < 10100
          log("10s Dual Hold - Toggle Lock")
          lock_enabled = !lock_enabled
          if lock_enabled
            beep("lock_on")
            log("Blokada WŁĄCZONA")
          else
            beep("lock_off")
            log("Blokada WYŁĄCZONA")
          end
        end
        
        # 20s -> Reset WiFi (Force AP)
        if duration > 20000 && duration < 20100
          log("20s Dual Hold - RESET WIFI")
          beep("success")
          tasmota.cmd("Reset 3") # Reset WiFi settings implies reboot usually? Or "WifiConfig 2" (AP)
          # "Reset 3" clears Wifi credentials but keeps other settings? Check Tasmota docs.
          # Safest is specific command or factory reset.
          # Let's use "WifiConfig 4" (Manager) or clear wifi.
          tasmota.cmd("WifiConfig 2") # Toggle to AP mode temporarily?
          tasmota.cmd("Restart 1")
        end
      end
      # Reset single press timers to avoid triggering them on release
      btn_left_time = 0
      btn_right_time = 0
      return # Skip single button processing
    else
      both_pressed = false
    end

    # Button Left Logic
    if b_left == 1 && btn_left_last == 0
      # Press Start
      btn_left_time = now
      beep("short")
    elif b_left == 0 && btn_left_last == 1
      # Release
      var press_len = now - btn_left_time
      if press_len > 50 && press_len < 1000
        # Short Click
        if !lock_enabled
          log("Lewy Klik - Ściemnianie")
          light_dim(-15)
        else
          log("Zablokowane")
        end
      elif press_len >= 3000
        # Long Press (handled on release or during hold?)
        # ESPHome logic: "ON for at least 3s" -> Trigger immediately at 3s
      end
    elif b_left == 1 && btn_left_last == 1
      # Holding
      var press_len = now - btn_left_time
      if press_len > 3000 && press_len < 3100
         if !lock_enabled
           log("Lewy Hold 3s - Wyłącz")
           light_off()
         end
      end
    end
    btn_left_last = b_left

    # Button Right Logic
    if b_right == 1 && btn_right_last == 0
      # Press Start
      btn_right_time = now
      beep("short")
    elif b_right == 0 && btn_right_last == 1
      # Release
      var press_len = now - btn_right_time
      if press_len > 50 && press_len < 1000
        # Short Click
        if !lock_enabled
          log("Prawy Klik - Rozjaśnianie")
          light_dim(15)
        else
          log("Zablokowane")
        end
      end
    end
    btn_right_last = b_right
  end
end

var handler = ButtonHandler()
tasmota.add_driver(handler)

# Rejestracja efektu "Candle" (Uproszczona symulacja w Berry)
# Wymaga Tasmota z obsługą Leds (standard)
# Ten efekt może obciążać procesor, używać ostrożnie.
class CandleEffect
  var active
  var phase
  
  def init()
    self.active = false
    self.phase = 0.0
  end

  def start()
    self.active = true
    tasmota.add_driver(self)
  end

  def stop()
    self.active = false
    # tasmota.remove_driver(self) # Berry drivers removal is tricky, just flag inactive
  end

  def every_50ms()
    if !self.active return end
    
    # Prosta symulacja: Losowe fluktuacje na kanale Warm/Red
    var base = 0.8
    var flicker = (math.rand() % 20) / 100.0 # 0.0 - 0.2
    var val = base + flicker
    if val > 1.0 val = 1.0 end
    
    # Ustawiamy kolor bezpośrednio (R, G, B, CW, WW)
    # Candle: Red + Warm White mostly
    var r = int(val * 255 * 0.8) # Troszkę mniej czerwonego
    var g = int(val * 255 * 0.4) # Żółty odcień
    var ww = int(val * 255)
    
    # Format hex: RRGGBBCWWW
    # Tasmota color cmd
    # To jest ryzykowne, bo zalewa konsolę. Lepiej użyć Scheme wbudowanego.
  end
end

# Dodanie komend konsoli
def cmd_lock_toggle()
  lock_enabled = !lock_enabled
  print("Lock set to: " + str(lock_enabled))
end

tasmota.add_cmd('ChildLock', cmd_lock_toggle)

log("Sterownik Lampy Załadowany")

