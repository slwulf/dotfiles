#!/bin/sh
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
session_duration=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')

format_tokens() {
  tokens="$1"
  if [ -z "$tokens" ] || [ "$tokens" = "null" ]; then
    echo "0"
  else
    awk "BEGIN { printf \"%.1fk\", $tokens / 1000 }"
  fi
}

format_duration() {
  ms="$1"
  if [ -z "$ms" ] || [ "$ms" = "null" ]; then
    echo "0s"
  else
    total_secs=$(( ms / 1000 ))
    hours=$(( total_secs / 3600 ))
    mins=$(( (total_secs % 3600) / 60 ))
    secs=$(( total_secs % 60 ))

    if [ "$hours" -gt 0 ]; then
      printf "%dh %dm" "$hours" "$mins"
    elif [ "$mins" -gt 0 ]; then
      printf "%dm %ds" "$mins" "$secs"
    else
      printf "%ds" "$secs"
    fi
  fi
}

if [ -n "$used" ]; then
  if [ -n "$input_tokens" ] && [ -n "$output_tokens" ] && [ -n "$window_size" ]; then
    total_tokens=$(( input_tokens + output_tokens ))
    used_tokens=$(format_tokens "$total_tokens")
    window_tokens=$(format_tokens "$window_size")
    used_display=$(printf "%.0f" "$used")
    usage_str="${used_tokens}/${window_tokens} (${used_display}%)"
  else
    # Fallback to just percentage if token data unavailable
    used_display=$(printf "%.0f" "$used")
    usage_str="${used_display}%"
  fi
else
  usage_str="0%"
fi

if [ -n "$session_duration" ]; then
  duration_display=$(format_duration "$session_duration")
  if [ -n "$input_tokens" ] && [ -n "$output_tokens" ]; then
    total_session_tokens=$(( input_tokens + output_tokens ))
    session_tokens=$(format_tokens "$total_session_tokens")
    session_str="${session_tokens} in ${duration_display}"
  else
    session_str="${duration_display}"
  fi
else
  session_str=""
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  env_emoji="🦄"
else
  env_emoji="💩"
fi

if [ -n "$total_cost" ]; then
  cost_display=$(awk "BEGIN { printf \"%.2f\", $total_cost }")
  block_str="\$${cost_display}"
else
  block_str="\$0.00"
fi

if [ -n "$effort" ]; then
  if [ -n "$session_str" ]; then
    printf "%s %s | 💪 %s | 🧠 %s | 💰 %s | 📊 %s" "$env_emoji" "$model" "$effort" "$usage_str" "$block_str" "$session_str"
  else
    printf "%s %s | 💪 %s | 🧠 %s | 💰 %s" "$env_emoji" "$model" "$effort" "$usage_str" "$block_str"
  fi
else
  if [ -n "$session_str" ]; then
    printf "%s %s | 🧠 %s | 💰 %s | 📊 %s" "$env_emoji" "$model" "$usage_str" "$block_str" "$session_str"
  else
    printf "%s %s | 🧠 %s | 💰 %s" "$env_emoji" "$model" "$usage_str" "$block_str"
  fi
fi
