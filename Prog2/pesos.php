<?php
$tasksFile = "tasks.txt";

$tasks = file_exists($tasksFile) ? file($tasksFile, FILE_IGNORE_NEW_LINES) : [];

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (!empty($_POST["task"])) {
        $tasks[] = $_POST["task"] . "|pending"; 
        file_put_contents($tasksFile, implode("\n", $tasks) . "\n");
    }
} elseif (isset($_GET["complete"])) {
    $id = $_GET["complete"];
    $tasks[$id] = explode("|", $tasks[$id])[0] . "|completed";
    file_put_contents($tasksFile, implode("\n", $tasks) . "\n");
} elseif (isset($_GET["delete"])) {
    unset($tasks[$_GET["delete"]]);
    file_put_contents($tasksFile, implode("\n", $tasks) . "\n");
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Manager</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

    <h1>Task Manager</h1>

    <form method="post">
        <input type="text" name="task" placeholder="Enter a task..." required>
        <button type="submit">Add Task</button>
    </form>

    <ul>
        <?php foreach ($tasks as $index => $taskData): 
            list($task, $status) = explode("|", $taskData);

        ?>
            <li class="<?= $status ?>">
                <?= htmlspecialchars($task) ?> 
                <?php if ($status == "pending"): ?>
                    <a href="?complete=<?= $index ?>">✅</a>
                <?php endif; ?>
                <a href="?delete=<?= $index ?>">❌</a>
            </li>
        <?php endforeach; ?>
    </ul>

</body>
</html>
