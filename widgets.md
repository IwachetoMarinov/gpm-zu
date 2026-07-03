# Dashboard widgets

## Install

Run `/install_widgets.php` (see Install_Modules.md §6).

## Shared files (touch when adding a widget)

| File | Purpose |
|------|---------|
| `install_widgets.php` | Register widget in `$widgets[]` |
| `layouts/v7/modules/Vtiger/resources/dashboards/Widget.js` | `Vtiger_*_Widget_Js` class |
| `languages/en_us/Vtiger.php` | Labels / empty-state messages |
| `layouts/v7/lib/chartjs/chart.umd.min.js` | Chart.js (used by chart widgets) |

## Widget: Today's Tasks

- **Name:** `TodayTasks` | **URL:** `module=Home&view=ShowWidget&name=TodayTasks`
- **Data:** `modules/Home/models/Module.php` → `getCalendarActivities('today_tasks', …)`
- **Files:** `modules/Vtiger/dashboards/TodayTasks.php`, `layouts/v7/modules/Vtiger/dashboards/TodayTasks.tpl`

## Widget: Clients List

- **Name:** `ClientsList` | **URL:** `module=Home&view=ShowWidget&name=ClientsList`
- **Data:** `modules/Contacts/models/Module.php` → `getAssignedClients()`
- **Files:** `modules/Vtiger/dashboards/ClientsList.php`, `layouts/v7/modules/Vtiger/dashboards/ClientsList.tpl`
- **Note:** `{* Test Charts *}` block at bottom of `ClientsList.tpl` keeps hardcoded Chart.js samples (bar + line) for experimentation; not removed when building the real widget.

## Widget: Client Transactions

- **Name:** `ClientTransactions` | **URL:** `module=Home&view=ShowWidget&name=ClientTransactions`
- **Data:** *Stage 1 — hardcoded sample data in template.* Stage 2 will load from ERP DB.
- **Files:**
  - `modules/Vtiger/dashboards/ClientTransactions.php`
  - `layouts/v7/modules/Vtiger/dashboards/ClientTransactions.tpl`
- **Charts (hardcoded):**
  - Bar — transactions per client
  - Line — monthly volume
  - Doughnut — transactions by type (Buy / Sell / Transfer / Other)
- **Labels:** `LBL_CLIENT_TRANSACTIONS_*` in `languages/en_us/Vtiger.php`

## Modified shared files (all widgets)

| File | Changes |
|------|---------|
| `install_widgets.php` | Widget registry + Calendar `location` schema repair |
| `modules/Home/models/Module.php` | `getCalendarActivities()` modes `today`, `today_tasks` |
| `modules/Contacts/models/Module.php` | `getAssignedClients()` |
| `layouts/v7/modules/Vtiger/resources/dashboards/Widget.js` | `TodayTasks`, `ClientsList`, `ClientTransactions` widget JS |
| `layouts/v7/modules/Vtiger/dashboards/CalendarActivitiesContents.tpl` | Empty state for `TodayTasks` |
| `languages/en_us/Vtiger.php` | Widget labels |

## Checklist for a new widget

1. `modules/Vtiger/dashboards/{Name}.php` — class `Vtiger_{Name}_Dashboard`
2. `layouts/v7/modules/Vtiger/dashboards/{Name}.tpl` — always assign `$WIDGET`
3. Register in `install_widgets.php` (`module` must be `Home`)
4. `Vtiger_{Name}_Widget_Js` line in `Widget.js`
5. Labels in `languages/en_us/Vtiger.php` (if needed)
6. Run `/install_widgets.php`, then add widget from Home dashboard
