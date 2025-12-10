<?php
error_reporting(0);

require_once __DIR__ . "/vendor/autoload.php";
use Box\Spout\Writer\Common\Creator\WriterEntityFactory;

function extractTablesFromPDF($pdfPath) {
    $command = "pdftotext -layout " . escapeshellarg($pdfPath) . " -";
    $text = shell_exec($command);

    $lines = explode("\n", $text);
    $rows = [];

    foreach ($lines as $line) {
        $clean = trim($line);
        if ($clean === "") continue;

        $cells = preg_split('/\s{2,}/', $clean);
        if (count($cells) > 1) $rows[] = $cells;
    }
    return $rows;
}

if(isset($_POST['convert'])) {
    if($_FILES['pdf']['error'] === 0) {
        $tmp = $_FILES['pdf']['tmp_name'];
        $excelFile = "converted_" . time() . ".xlsx";

        $rows = extractTablesFromPDF($tmp);

        $writer = WriterEntityFactory::createXLSXWriter();
        $writer->openToFile($excelFile);

        foreach ($rows as $rowData) {
            $writer->addRow(
                WriterEntityFactory::createRowFromArray($rowData)
            );
        }
        $writer->close();

        header("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        header("Content-Disposition: attachment; filename=$excelFile");
        readfile($excelFile);
        unlink($excelFile);
        exit;
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>PDF → Excel Converter</title>
    <style>
        body { font-family: Arial; background:#f5f5f5; padding:40px; }
        .box { max-width:450px; margin:auto; background:white; padding:25px; border-radius:12px; box-shadow:0 0 10px #ddd; }
        button { background:#2563eb; color:white; padding:12px; width:100%; border:none; border-radius:8px; font-size:18px; cursor:pointer; }
        button:hover { background:#1e40af; }
        input { width:100%; padding:12px; margin-top:10px; }
    </style>
</head>

<body>
<div class="box">
    <h2 style="text-align:center;color:#2563eb">PDF → Excel Converter</h2>
    <form method="POST" enctype="multipart/form-data">
        <label>Select PDF File:</label>
        <input type="file" name="pdf" accept="application/pdf" required>
        <br><br>
        <button type="submit" name="convert">Convert to Excel</button>
    </form>
</div>
</body>
</html>