Exam run:
```bash
# Compare 1 and 8 core (my machine has 8 cores hehe)
dotnet run input.png output.png
```

Python key:
```bash
uv run error_diffusion.py world-grayscale.png world-grayscale-python-output.png
```

Verify: 
```bash
uv run bw_similarity.py world-grayscale-cs-output.png world-grayscale-python-output.png
```