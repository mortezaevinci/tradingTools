# csharp_bookviewrunner_batch

The batch layer that drives `..\csharp\bookViewRunner` — one `.bat` per symbol,
plus `runall.bat` to start them together.

| File | What it does |
|---|---|
| `run AAL.bat`, `run TSLA.bat`, `run XOM.bat`, `run SAMPLE.bat` | Capture the order book for one symbol. |
| `runall.bat` | All of the above. |
| `readme.txt` | The original note, kept as written. |
| `main old/`, `z_old/` | Previous versions. |
| `z_future/` | Work that was never finished. |

**Why the output path is indirect.** From `readme.txt`: the book files are
written to `m:\book\` first and moved afterwards, to spare the flash drive —
order-book capture writes continuously, and pointing it straight at the archive
location wore the disk. The original destination was a mapped `Z:` drive that no
longer exists on this machine; if these are run again, both paths need setting
to somewhere real.

The `.bat` file names are the interface — `runall.bat` calls them by name, so
they keep their names, spaces and all.
