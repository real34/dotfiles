#!/usr/bin/env bash
# stt-dictate.sh - Push-to-talk speech-to-text using whisper.cpp
#
# Usage:
#   stt-dictate start   # demarre l'enregistrement
#   stt-dictate stop    # arrete et transcrit
#   stt-dictate toggle  # bascule entre start/stop
#
# Keybinding i3 (mode toggle):
#   bindsym Mod4+space exec stt-dictate toggle
#
# Modeles disponibles (STT_MODEL):
#   tiny    - 39 MB   - rapide, qualite basique
#   base    - 74 MB   - rapide, bonne qualite
#   small   - 244 MB  - equilibre (defaut)
#   medium  - 769 MB  - lent, excellente qualite
#   large   - 1.5 GB  - tres lent, meilleure qualite
#
# Exemple: STT_MODEL=tiny stt-dictate start

set -euo pipefail

RECORDING_PID="/tmp/stt-recording.pid"
AUDIO_FILE="/tmp/stt-audio.wav"
MODEL_DIR="${HOME}/.cache/whisper"
MODEL="${STT_MODEL:-small}"

# Notification helper (silently fails if no daemon)
notify() {
  notify-send "STT" "$1" -t "${2:-2000}" 2>/dev/null || echo "[STT] $1"
}

# Telecharge le modele si absent
download_model() {
  local model_file="${MODEL_DIR}/ggml-${MODEL}.bin"
  if [[ ! -f "$model_file" ]]; then
    mkdir -p "$MODEL_DIR"
    notify "Telechargement du modele ${MODEL}..." 5000
    local url="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-${MODEL}.bin"
    curl -L "$url" -o "$model_file"
    notify "Modele ${MODEL} pret"
  fi
}

start_recording() {
  # Ne pas démarrer si déjà en cours
  if [[ -f "$RECORDING_PID" ]] && kill -0 "$(cat "$RECORDING_PID")" 2>/dev/null; then
    return 0
  fi
  download_model
  # Enregistre avec arecord (format compatible whisper.cpp)
  arecord -f S16_LE -r 16000 -c 1 -t wav "$AUDIO_FILE" &
  echo $! >"$RECORDING_PID"
  notify "Enregistrement..." 1000
}

stop_and_transcribe() {
  if [[ -f "$RECORDING_PID" ]]; then
    kill "$(cat "$RECORDING_PID")" 2>/dev/null || true
    rm -f "$RECORDING_PID"
    sleep 0.3 # laisse arecord finaliser le fichier

    if [[ ! -f "$AUDIO_FILE" ]] || [[ ! -s "$AUDIO_FILE" ]]; then
      notify "Pas d'audio enregistre"
      rm -f "$AUDIO_FILE"
      return 1
    fi

    notify "Transcription..." 1000

    local model_file="${MODEL_DIR}/ggml-${MODEL}.bin"

    # Transcription avec whisper.cpp
    TEXT=$(whisper-cli \
      -m "$model_file" \
      -l fr \
      -nt \
      -np \
      "$AUDIO_FILE" 2>&1 |
      grep -v "^load_backend:" |
      tr -d '\n' |
      sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    rm -f "$AUDIO_FILE"

    # Tape le texte au curseur
    if [[ -n "$TEXT" ]]; then
      sleep 0.1 # petit delai pour focus
      xdotool type --delay 10 -- "$TEXT"
      notify "$TEXT"
    else
      notify "Aucun texte detecte"
    fi
  fi
}

case "${1:-toggle}" in
start) start_recording ;;
stop) stop_and_transcribe ;;
toggle)
  if [[ -f "$RECORDING_PID" ]]; then
    stop_and_transcribe
  else
    start_recording
  fi
  ;;
*)
  echo "Usage: $0 {start|stop|toggle}"
  exit 1
  ;;
esac
