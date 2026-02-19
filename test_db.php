<?php
try {
    $dsn = "pgsql:host=127.0.0.1;port=5432;dbname=pos_kelontong";
    $user = "bihadmin";
    $pass = "bihan_passwo";
    $pdo = new PDO($dsn, $user, $pass);
    echo "SUCCESS";
} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage();
}
