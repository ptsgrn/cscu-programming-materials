# Lab06

## Open a tunnel

For iacto host.

```bash
cloudflared tunnel --config ~/.cloudflared/agent-iacto.yml run
```

## Run a bot local server

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 bot.py
```
