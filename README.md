# tradingTools

Trading and market-analysis code built between roughly 2019 and 2021: order-book
capture and replay, Interactive Brokers automation, options-flow screening,
scraping of ratings and screener sites, MATLAB experiments, and the
platform-side scripts that ran on thinkorswim and TradingView.

This is a personal working repository, not a product. Several projects are
experiments that were carried as far as they needed to go and no further.

> **Naming.** Some project folders are named awkwardly (`IB2`,
> `marktebeat rating`, `temp TWS API`, `Sellenium…`). They are **left exactly as
> they are on purpose**: the C# projects reference each other by relative path —
> `IB` ⇄ `IB2` ⇄ `temp TWS API` — and executables, solutions and scripts keep
> their original names so nothing that already runs stops running. The typos are
> historical; treat the folder names as identifiers, not descriptions.

---

## Layout

| Folder | What is in it |
|---|---|
| `csharp/` | The main body of work. Order-book viewer and runner, IB automation, Selenium scrapers, MarketBeat ratings, notification service. |
| `csharp_bookviewrunner_batch/` | The batch layer that drives `bookViewRunner` per symbol — `run AAL.bat`, `run TSLA.bat`, `runall.bat`. |
| `matlab/` | Signal and machine-learning experiments against captured market data: option flow, neural nets, prediction models. |
| `python/` | Three third-party projects kept for reference, plus setup notes. Not written here. |
| `platforms/` | Scripts that live inside a trading platform rather than on this machine: thinkorswim studies and strategies, TradingView scripts, IB watchlists. |
| `base ideas/` | The thinking behind the code — strategies, observations, contract details, vendor notes. Documents, not code. |
| `javascript/` | One note on push notifications. |
| `documentation/` | The IB trader template setup document. |

Market data and results are **not** in this repository. They live in
`C:\temp\_results\investment_notes` (moved there 2026-09-23) — screener exports,
market-chameleon CSVs, macro notes and screenshots, several hundred MB of it.
The MATLAB option-flow scripts read from that path.

---

## csharp/

The largest area, and the one with real dependencies between projects.

| Project | What it does |
|---|---|
| `bookViewer/` | Windows Forms viewer for order-book data. |
| `bookViewRunner/` | Captures the order book and writes it out — `SPY_book_history`, `SPY_book_realtime`, as both `.txt` and `.bin`. Driven per symbol by `csharp_bookviewrunner_batch/`. |
| `bookViewer original test case/` | The earlier version of the viewer, kept as a reference case. |
| `SelleniumRunner/` | Selenium-driven scraping, with its own serialisation helpers (`convertto2`, `testSerialize`, `testDeserialize`, `SystemCoreExpansion`) and a `MarkteData` definition shared with the book runner. |
| `SelleniumTester/` | Scratch WinForms harness for the same. |
| `chameleon test case/` | Reading Market Chameleon options tables — `ChameleonOptionsTable`, `ChameleonRunner`, `chamreader`. |
| `marktebeat rating/` | MarketBeat analyst ratings: a scraper (`ChameleonRunner`), a definition library, and `MbbToCsv` to flatten the result. |
| `IB/` | Interactive Brokers: the sample app, `IbClient`, `OrderDefinition`, and a testbed. |
| `IB2/` | The larger IB work — order management (`OrderManager`, `ConsoleAppManageOrders`), order flow and its simulation, account and contract definitions, logging, an SMTP client, and `IbTrader`. |
| `UserNoti/` | User notification service. |
| `temp TWS API/` | The Interactive Brokers TWS API SDK, vendored. Third-party code; `IB` and `IB2` compile against it. |
| `files/` | Order and fill CSVs exported while the above ran. |

**Build order matters**, because the references cross folders:
`temp TWS API` → `IB2` (definitions) → `IB` → the apps. Open a project's own
`.sln`; the relative paths resolve from there.

## matlab/

| Folder | What is in it |
|---|---|
| `mine/` | The work written here: option-flow analysis, IB contract handling, neural-net helpers. `test_oprionflow*.m` read the Market Chameleon screener CSVs from `C:\temp\_results\investment_notes\marketchameleon\`. |
| `marktedata/` | Processed per-symbol `.mat` captures. |
| `nnet/`, `nnet_pattern/`, `nnet_quoteonly/` | Neural-network experiments, including an LSTM sequence-classification example. |
| `predictmodel/`, `naxnettest/`, `dp/` | Prediction and classifier trials. |

## python/

Third-party, kept for reference — none of it was written here:

| Folder | Source |
|---|---|
| `High-Frequency-Trading-Model-with-IB-master/` | Public HFT-with-IB model. |
| `Teino1978-Corp-High-Frequency-Trading-Model-with-IB-master/` | A fork of the same. |
| `wsb_scraper-main/` | WallStreetBets scraper. |

`jarvis setup notes.txt` is the setup note that goes with them.

## platforms/

Code that runs inside the broker or charting platform, not here:

- `tos/` — thinkorswim: `study/`, `strategy/` (dated live and papermoney runs),
  watchlists, scan studies, and notes.
- `tradingview/` — Pine scripts.
- `IB/` — watchlist instruments, and a pointer to the IB API docs.

---

## Running the book capture

`csharp_bookviewrunner_batch/` holds one `.bat` per symbol plus `runall.bat`.
Its own `readme.txt` records why output goes where it does: the book files are
written to a RAM/flash-sparing path first and moved afterwards, to avoid
hammering the flash drive with continuous writes.

## State of things

Everything here ran at some point between 2019 and 2021 against live or paper
accounts. It is archived rather than maintained: paths that once pointed at a
mapped `Z:` drive have been corrected where they were found, but nothing has
been rebuilt or re-tested recently.
