<?php

$noindex = false;
$host = $_SERVER['HTTP_HOST'];
$requestUri = $_SERVER['REQUEST_URI'];

if ($requestUri !== '/') {
    http_response_code(404);
    header("X-Robots-Tag: noindex, nofollow", true);
    $noindex = true;
}

$elmJsFilePath = 'elm.min.js';
$elmJsTimeSuffix = '';
if (file_exists($elmJsFilePath)) {
    $elmJsFileLastEdit = filemtime($elmJsFilePath);
    $elmJsTimeSuffix = sprintf('?time=%s', $elmJsFileLastEdit !== false ? $elmJsFileLastEdit : sprintf('error-%d', time()));
}


?><!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Sasse Hugo</title>

    <script src="/elm.min.js<?php echo $elmJsTimeSuffix; ?>"></script>

    <meta name="viewport" content="width=device-width, initial-scale=1">

<?php if ($noindex) {?>
    <meta name="robots" content="noindex, nofollow">
<?php }?>

</head>

<body>
    <div id="elm-container"></div>

    <script>
        var app = Elm.Main.init({
            node: document.getElementById('elm-container'),
            flags: {
            }
        });
    </script>

</body>

</html>
