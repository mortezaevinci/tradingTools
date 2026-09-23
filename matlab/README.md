# matlab

Signal and machine-learning experiments against captured market data. Research
code: written to answer a question, and left in whatever state it was in when the
question was answered.

## Folders

| Folder | What is in it |
|---|---|
| `mine/` | The work written here — option-flow analysis, IB contract handling (`IbContractDetails2Mat.m`), order pre-staging (`trader_preorder.m`, `trader/`), helpers such as `MaxHigh.m`, and an `NN` subfolder. |
| `marktedata/` | Order-book readers and processed per-symbol captures as `.mat`. The folder name is a typo for *marketdata*, left as it is. |
| `nnet/` | Neural-network work, including the LSTM sequence-classification example it started from. |
| `nnet_pattern/`, `nnet_quoteonly/` | Variants — pattern inputs, and quote-only inputs. |
| `predictmodel/` | Classifier trials, e.g. `TrainAKNNClassifierExample.m`. |
| `naxnettest/` | NARX-style tests with their own data (`CHO.csv`, `CHO_results.xlsx`) and an error-performance helper (`errperf.m`). |
| `dp/` | Dynamic-programming scratch work. |

## Data paths

These scripts read and write **outside the repository**. All of the following
were corrected on 2026-09-23 and resolve on this machine:

| Script | Path it uses |
|---|---|
| `mine/test_oprionflow.m`, `test_oprionflow_daily.m`, `test_oprionflow_daily_total.m` | `C:\temp\_results\tradingtools\investment_notes\marketchameleon\OptionTradeScreenerResults_<yymmdd>.csv` |
| `mine/trader_preorder.m` | `C:\temp\_results\tradingtools\files\` — the order XML template, and `log\` |
| `mine/trader/traderPreorder_portfolio.m` | `C:\temp\_results\tradingtools\files\log\` |

Each is a single line near the top of its script. On another machine, those are
the only lines to change.

## Paths on the Z: drive — leave them alone

`marktedata/` reads the raw order-book capture — the `.bin` and `.txt` files
`bookViewRunner` wrote continuously:

    Z:\My files\Project trading\traderdata\book\<symbol>_book_realtime.txt
    Z:\My files\Project trading\traderdata\book\<symbol>_book_history <date>.bin

**These are correct.** `Z:` is a real drive that is simply not attached to this
machine at the moment, and the capture data lives on it. Roughly 410 references,
nearly all in `marktedata/`. Attach the drive and they resolve; do not rewrite
them to point somewhere else. A handful of other lines reference a `Q:` drive —
they are commented out, history rather than code.

## Running

MATLAB with the Statistics and Machine Learning and Deep Learning toolboxes for
the `nnet*` and `predictmodel` work. The option-flow scripts need nothing beyond
base MATLAB — they read CSV and plot.
