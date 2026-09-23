# csharp

The main body of the trading code. Written against .NET Framework with Windows
Forms, Selenium and the Interactive Brokers TWS API.

## Read this before renaming anything

These projects reference each other **by relative path**, across folders:

    IB\IBSampleApp\IBSampleApp.csproj      ->  ..\..\IB2\ContractDefinition\...
    IB\OrderDefinition\...csproj           ->  ..\..\IB2\OrderDefinition_\...
    IB2\ConsoleAppAddEc\...csproj          ->  ..\..\IB\OrderDefinition\...
    IB2\ConsoleAppManageOrders\...csproj   ->  ..\..\temp TWS API\source\CSharpClient\client\CSharpAPI.csproj

Nineteen `.sln`/`.csproj` files name `temp TWS API` alone. Renaming a folder
means editing every one of them, so the awkward names stay — including the typos
(`marktebeat`, `Sellenium`, `MarkteData`). **Executables, solutions and scripts
keep their original names**, so what runs today keeps running.

## Dependency order

    temp TWS API  (vendored IB SDK)
        └── IB2   (ContractDefinition, OrderDefinition_, SystemExtension, ...)
              └── IB    (IBSampleApp, OrderDefinition, IbClient, Testbed)
                    └── the console apps and forms

Open the `.sln` inside a project folder rather than a solution from elsewhere;
the relative references resolve from where the solution sits.

## The projects

### Order book

| Project | What it does |
|---|---|
| `bookViewer/` | WinForms viewer for order-book data. Solution: `bookViewerSol.sln`. |
| `bookViewRunner/` | Captures the book and writes `SPY_book_history` / `SPY_book_realtime` as `.txt` and `.bin`, alongside a `MarkteData` definition. Driven per symbol from `..\csharp_bookviewrunner_batch\`. |
| `bookViewer original test case/` | The earlier viewer, kept as a working reference. |

### Scraping

| Project | What it does |
|---|---|
| `SelleniumRunner/` | Selenium scraping with serialisation helpers — `convertto2`, `testSerialize`, `testDeserialize`, `SystemCoreExpansion`, and a shared `MarkteData`. |
| `SelleniumTester/` | WinForms harness for the same (`chaeer.sln`). |
| `chameleon test case/` | Market Chameleon options tables: `ChameleonOptionsTable`, `ChameleonRunner`, `chamreader`, `testRead`. |
| `marktebeat rating/` | MarketBeat analyst ratings — scraper, `MarketBeatRatingsDefinition`, and `MbbToCsv` to flatten to CSV. Solution: `marketbeat ratings.sln`. |

`chromedriver.exe` sits at this level because the Selenium projects expect it
there. Its version must match the installed Chrome.

### Interactive Brokers

| Project | What it does |
|---|---|
| `IB/` | `IBSampleApp`, `IbClient`, `OrderDefinition`, `Testbed`, and two console apps. |
| `IB2/` | The substantial IB work: `OrderManager` / `OrderManager2`, `ConsoleAppManageOrders`, `OrderFlow` and `OrderFlowLogSimulationSpy`, `ContractDefinition`, `IBAccountDefinition`, `IBBackEnd`, `IBWrapper`, `IbTrader`, `IB trader pad`, `IBLog`, `BasicLogger`, `MySmtpClient`, `TickDefinition`, `TradeExtensionExternalCondtion`. |
| `temp TWS API/` | **Third-party**: the IB TWS API SDK, vendored so the projects above have something to compile against. Not written here — do not edit it to fix a local problem. |

### Other

| Project | What it does |
|---|---|
| `UserNoti/` | User notification service. |
| `files/` | Order, fill and completed-order CSVs exported while the above ran — data, not code. |

## Building

Requires Visual Studio with .NET Framework targeting packs. Build output
(`bin/`, `obj/`, `.vs/`) is ignored by the repository's `.gitignore`, so a clone
is source only and the first build restores and compiles from scratch.
