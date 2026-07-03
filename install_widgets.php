<?php
/**
 * Register custom Home dashboard widgets.
 * Run in the browser: /install_widgets.php
 * Safe to run multiple times — existing widgets are detected and skipped.
 */
$Vtiger_Utils_Log = true;

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/config.inc.php';
require_once __DIR__ . '/include/utils/utils.php';
require_once __DIR__ . '/vtlib/Vtiger/Module.php';

global $adb;

/**
 * Return true when vtiger_activity has the given column.
 */
function activityTableHasColumn(PearDatabase $adb, string $columnName): bool
{
    $result = $adb->pquery('SHOW COLUMNS FROM vtiger_activity LIKE ?', [$columnName]);
    return $adb->num_rows($result) > 0;
}

/**
 * Calendar schema repair — vtiger_field references location on Events/Calendar,
 * but some installs are missing the physical column (breaks open/delete/save).
 */
if (!activityTableHasColumn($adb, 'location')) {
    $adb->pquery(
        'ALTER TABLE vtiger_activity ADD COLUMN location VARCHAR(255) DEFAULT NULL AFTER activitytype',
        []
    );
    echo 'Added missing column: vtiger_activity.location<br>';
} else {
    echo 'Calendar schema OK — vtiger_activity.location already exists<br>';
}

$homeTabId = getTabid('Home');
if (empty($homeTabId)) {
    die('Home module tabid not found. Is vtiger bootstrapped correctly?');
}

$widgets = [
    [
        'label'    => "Today's Tasks",
        'name'     => 'TodayTasks',
        'module'   => 'Home',
        'sequence' => 100,
    ],
    [
        'label'    => 'Clients List',
        'name'     => 'ClientsList',
        'module'   => 'Home',
        'sequence' => 101,
    ],
    [
        'label'    => 'Client Transactions',
        'name'     => 'ClientTransactions',
        'module'   => 'Home',
        'sequence' => 102,
    ],
];

/**
 * Build the canonical widget URL for a widget definition.
 */
function buildWidgetUrl(array $widget): string
{
    return sprintf(
        'index.php?module=%s&view=ShowWidget&name=%s',
        $widget['module'],
        $widget['name']
    );
}

/**
 * Return true when a valid (non-broken) widget link already exists in vtiger_links.
 */
function isWidgetInstalled(PearDatabase $adb, int $homeTabId, array $widget): bool
{
    $url = buildWidgetUrl($widget);

    $result = $adb->pquery(
        'SELECT linkid, linklabel, linkurl, tabid
         FROM vtiger_links
         WHERE linktype = ?
           AND tabid = ?
           AND linkid > 0
           AND (
               linkurl = ?
               OR linkurl LIKE ?
               OR linklabel = ?
               OR linklabel = ?
           )',
        [
            'DASHBOARDWIDGET',
            $homeTabId,
            $url,
            '%name=' . $widget['name'] . '%',
            $widget['label'],
            $widget['name'],
        ]
    );

    while ($row = $adb->fetch_array($result)) {
        if (isValidWidgetLink($row, $homeTabId, $widget)) {
            return true;
        }
    }

    return false;
}

/**
 * A widget link is valid when tabid, linkid, and URL module/name are correct.
 */
function isValidWidgetLink(array $row, int $homeTabId, array $widget): bool
{
    if ((int) $row['linkid'] <= 0) {
        return false;
    }
    if ((int) $row['tabid'] !== $homeTabId) {
        return false;
    }
    if (stripos($row['linkurl'], 'module=Vtiger') !== false) {
        return false;
    }
    if (stripos($row['linkurl'], 'name=' . $widget['name']) === false) {
        return false;
    }

    return true;
}

/**
 * Repair vtiger_links_seq if a manual INSERT skipped getUniqueID().
 */
$maxResult = $adb->pquery('SELECT MAX(linkid) AS max_id FROM vtiger_links', []);
$maxLinkId = (int) $adb->query_result($maxResult, 0, 'max_id');
$seqResult = $adb->pquery('SELECT id FROM vtiger_links_seq', []);
$seqId = (int) $adb->query_result($seqResult, 0, 'id');
if ($seqId < $maxLinkId) {
    $adb->pquery('UPDATE vtiger_links_seq SET id = ?', [$maxLinkId]);
    echo "Repaired vtiger_links_seq (was {$seqId}, set to {$maxLinkId})<br>";
}

/**
 * Remove broken widget rows from earlier install attempts.
 */
foreach ($widgets as $widget) {
    $broken = $adb->pquery(
        "SELECT linkid, linklabel, linkurl, tabid
         FROM vtiger_links
         WHERE linktype = ?
           AND (linklabel IN (?, ?) OR linkurl LIKE ?)",
        ['DASHBOARDWIDGET', $widget['name'], $widget['label'], '%name=' . $widget['name'] . '%']
    );

    while ($row = $adb->fetch_array($broken)) {
        if (isValidWidgetLink($row, $homeTabId, $widget)) {
            continue;
        }

        $linkId = (int) $row['linkid'];
        $adb->pquery('DELETE FROM vtiger_module_dashboard_widgets WHERE linkid = ?', [$linkId]);
        $adb->pquery('DELETE FROM vtiger_links WHERE linkid = ?', [$linkId]);
        echo "Removed broken widget link: {$row['linklabel']} (linkid {$linkId})<br>";
    }
}

$homeModule = Vtiger_Module::getInstance('Home');
if (!$homeModule) {
    die('Home module not found.');
}

foreach ($widgets as $widget) {
    if (isWidgetInstalled($adb, $homeTabId, $widget)) {
        echo "Widget already installed — skipped: {$widget['label']}<br>";
        continue;
    }

    $url = buildWidgetUrl($widget);

    $homeModule->addLink(
        'DASHBOARDWIDGET',
        $widget['label'],
        $url,
        '',
        $widget['sequence']
    );

    echo "Installed widget: {$widget['label']}<br>";
}

echo '<br>Done.';
