# csharp_bookviewrunner_batch

The batch layer that drives [`../csharp/bookViewRunner`](../csharp/bookViewRunner) —
one `.bat` per symbol, plus `runall.bat` to start them together.

| File | What it does |
|---|---|
| `run AAL.bat`, `run TSLA.bat`, `run XOM.bat`, `run SAMPLE.bat` | Capture the order book for one symbol. |
| `runall.bat` | All of the above. |
| `readme.txt` | The original note, kept exactly as written. |
| `main old/`, `z_old/` | Previous versions. |
| `z_future/` | Work that was started and never finished. |

The `.bat` names are the interface — `runall.bat` calls them by name — so they
keep their names, spaces included.

## Why the output path is indirect

From `readme.txt`: the book files are written to `m:\book\` first and moved
afterwards, **to spare the flash drive**. Order-book capture writes continuously,
and pointing it straight at the archive location wore the disk out.

Both ends of that arrangement are stale now. The destination was
`Z:\My files\Project Trading\traderdata\book\`, a mapped drive that no longer
exists, and `m:\` was a RAM or scratch disk that is not set up either. Nothing
was repointed, because that capture data is not on this machine to point at —
see the dead-paths section of [`../matlab/README.md`](../matlab/README.md), which
hits the same wall from the reading side.

**To run these again:** pick a scratch directory and an archive directory, set
both here, and set the same archive path in the MATLAB readers.
