# HIP_VISIBLE_DEVICES=0 llama-server -m /home/dwaris/Projects/models/hub/models--empero-ai--Qwen3.8-27B-Ridge-GGUF/snapshots/486faa5f2032ff99bdc8993ade1b8fff13d1464c/Qwen3.8-27B-Ridge-3.7bpw.gguf \
#   -ngl 99 \
#   -c 131072 \
#   -fa on \
#   --split-mode none \
#   -np 1 \
#   --host 127.0.0.1 --port 8080 -ctk q4_0 -ctv q4_0
HIP_VISIBLE_DEVICES=0 llama-server \
      -m /home/dwaris/Projects/models/hub/models--empero-ai--Qwen3.8-27B-Ridge-GGUF/snapshots/486faa5f2032ff99bdc8993ade1b8fff13d1464c/Qwen3.8-27B-Ridge-3.7bpw.gguf \
      -ngl 99 \
      --split-mode none \
      -c 65536 \
      -fa on \
      --spec-type draft-mtp \
      --spec-default \
      --spec-draft-n-max 2 \
      -ctk q8_0 \
      -ctv q8_0 \
      -b 4096 \
      -ub 1024 \
      --jinja \
      -np 1 \
      --host 127.0.0.1 --port 8080
