# matlab

Signal and machine-learning experiments against captured market data. Research
code: written to answer a question, kept in whatever state it was in when the
question was answered.

## Folders

| Folder | What is in it |
|---|---|
| `mine/` | The work written here. Option-flow analysis, IB contract handling (`IbContractDetails2Mat.m`), helpers such as `MaxHigh.m`, and an `NN` subfolder. |
| `marktedata/` | Processed per-symbol captures as `.mat` — "processed sample AAL2020-06-13.mat" and similar. The folder name is a typo for *marketdata*, left as it is. |
| `nnet/` | Neural-network work, including the LSTM sequence-classification example it was based on. |
| `nnet_pattern/`, `nnet_quoteonly/` | Variants: pattern inputs, and quote-only inputs. |
| `predictmodel/` | Classifier trials, e.g. `TrainAKNNClassifierExample.m`. |
| `naxnettest/` | NARX-style tests with their own data (`CHO.csv`, `CHO_results.xlsx`) and an error-performance helper (`errperf.m`). |
| `dp/` | Dynamic-programming scratch work. |

## Data path

`mine/test_oprionflow.m`, `test_oprionflow_daily.m` and
`test_oprionflow_daily_total.m` read the Market Chameleon screener exports:

    C:\temp\_results\investment_notes\marketchameleon\OptionTradeScreenerResults_<yymmdd>.csv

Those three used to point at `Z:\My files\Project Trading\investment notes\...`,
a mapped drive that no longer exists on this machine. They were repointed on
2026-09-23 when the data moved to `C:\temp\_results\investment_notes`. **The data
is not in this repository** — it is several hundred MB of exports and belongs
beside the results, not in source control.

If you run these somewhere else, that path at the top of each script is the only
thing to change.
