# platforms

Code that runs **inside** a trading platform rather than on this machine. None of
it builds here; each file is pasted into the platform that owns it.

## tos/ — thinkorswim

| Path | What it is |
|---|---|
| `study/` | Custom studies (indicators drawn on a chart). |
| `strategy/` | Backtest strategies, in dated folders — `live 2020-04-27`, `papermoney 20-05-04`, `paper g7 20-12-20` and others. The dates are the runs, kept so a result can be traced to the code that produced it. |
| `watchlists/` | Saved watchlists. |
| `other scripts/` | Everything that is neither a study nor a strategy. |
| `ST_RAF_ScanSTUDY.ts` | A scan study. |
| `condition template.txt`, `news list.txt`, `mimic trader notes.txt` | Working notes. |
| `pl history 2020-04-15.png` | A P&L snapshot. |

thinkorswim scripts are thinkScript: they run in the platform, so there is
nothing to build or test from here.

## tradingview/

Pine scripts — `candle.txt`, `script_for_server_*.txt`. Paste into the Pine
editor.

## IB/

`main watchlist instruments` is the watchlist. `readme.txt` is a single line
pointing at the IB API documentation: <http://interactivebrokers.github.io/#>

The C# side of Interactive Brokers is in [`../csharp/IB`](../csharp/IB) and
[`../csharp/IB2`](../csharp/IB2); see [`../csharp/README.md`](../csharp/README.md).
