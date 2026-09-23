# tradingTools

Trading and market-analysis code written between roughly 2019 and 2021:
order-book capture and replay, Interactive Brokers automation, options-flow
screening, scraping of ratings and screener sites, MATLAB experiments, and the
platform-side scripts that ran inside thinkorswim and TradingView.

A personal working repository, not a product. Several projects are experiments
that were carried as far as they needed to go and no further. Everything here
ran at some point against live or paper accounts; it is archived rather than
maintained.

---

## Layout

| Folder | What is in it |
|---|---|
| [`csharp/`](csharp/) | The main body of work — order-book viewer and runner, IB automation, Selenium scrapers, MarketBeat ratings, notifications. |
| [`csharp_bookviewrunner_batch/`](csharp_bookviewrunner_batch/) | The batch layer that drives `bookViewRunner`, one `.bat` per symbol. |
| [`matlab/`](matlab/) | Signal and machine-learning experiments against captured market data. |
| [`python/`](python/) | Three third-party projects kept for reference. Not written here. |
| [`platforms/`](platforms/) | Scripts that run inside a platform rather than on this machine: thinkorswim, TradingView, IB watchlists. |
| [`documentation/`](documentation/) | The IB trader template setup document. |
| [`javascript/`](javascript/) | One note on browser push notifications. |

Each folder has its own `README.md` with the detail.

## Where the data is

**No market data, order data or research notes are in this repository.** They
live outside it, on the machine that runs these tools:

| Data | Location | Read by |
|---|---|---|
| Option screener exports, market and macro notes | `C:\temp\_results\tradingtools\investment_notes` | `matlab/mine/test_oprionflow*.m` |
| Order and fill exports, order XML templates | `C:\temp\_results\tradingtools\files` | `csharp/IB2/ConsoleAppAddEc`, `csharp/IB2/TradeExtensionExternalCondtion`, `matlab/mine/trader_preorder.m`, `matlab/mine/trader/traderPreorder_portfolio.m` |
| Strategy and research notes | `C:\temp\_results\tradingtools\base ideas` | — read by people, not code |

`C:\temp\_results\tradingtools\README.md` describes all three. A clone of this
repository on another machine has no data: point the paths above at wherever it
actually lives, then run.

## Two things that will confuse you

**The names are wrong and stay wrong.** `IB2`, `marktebeat rating`,
`temp TWS API`, `Sellenium…`, `MarkteData` — the typos are historical. The C#
projects reference each other by relative path, so a folder rename means editing
19 `.sln`/`.csproj` files, and every executable, solution and script keeps its
original name so that what runs today keeps running. **Treat the folder names as
identifiers, not descriptions.**

**Many paths point at the `Z:` drive. They are correct — `Z:` is simply not
attached right now.** Do not "fix" them and do not repoint them at something that
looks close; attach the drive instead. The only paths changed on 2026-09-23 were
the ones whose data had genuinely moved, listed in the table above.
About 410 `Z:` references remain, nearly all pointing at
`Z:\My files\Project trading\traderdata`,
the live capture output: the raw order-book `.bin` and `.txt` files the tools
wrote continuously. They are mostly in `matlab/marktedata/`, and they resolve as
soon as the drive is attached.

## Build order

The C# projects have to be built in dependency order, because they reference each
other across folders:

    csharp/temp TWS API      the vendored IB SDK
        └── csharp/IB2       definitions, order management, logging
              └── csharp/IB  sample app, client, order definition, testbed
                    └── the console apps and forms

Open the `.sln` inside a project's own folder — the relative references resolve
from where the solution sits. See [`csharp/README.md`](csharp/README.md).

Requires Visual Studio with .NET Framework targeting packs. Build output
(`bin/`, `obj/`, `.vs/`) is ignored, so a clone is source only.

## Licence note

`csharp/temp TWS API/` is the Interactive Brokers TWS API SDK and `python/` is
three public projects, all vendored unchanged. They carry their own licences —
check them before reusing anything from either.
