<?php
$db = new PDO('sqlite:database/database.sqlite');
$tables = $db->query("SELECT name FROM sqlite_master WHERE type='table'")->fetchAll(PDO::FETCH_COLUMN);

foreach ($tables as $table) {
    if (str_starts_with($table, 'sqlite_')) continue;
    $schema = $db->query("SELECT sql FROM sqlite_master WHERE type='table' AND name='$table'")->fetchColumn();
    echo "--- TABLE: $table ---\n$schema\n\n";
}
?>
