<?php
header('Access-Control-Allow-Origin: http://127.0.0.1');
session_start();

if(isset($_SESSION['user']) and $_SESSION['user'] =="admin" )
    $path = "<li><a href='Admin.php' accesskey='5' title=''>Admin Panel</a></li>";
else
    $path = "<li><a href='login.php' accesskey='5' title=''>logIn</a></li>";

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>LotoHackfest</title>
<meta name="keywords" content="" />
<meta name="description" content="" />
<link href='http://fonts.googleapis.com/css?family=Archivo+Narrow:400,700|Open+Sans:400,600,700' rel='stylesheet' type='text/css' />
<link href="default.css" rel="stylesheet" type="text/css" media="all" />
<!--[if IE 6]>
<link href="default_ie6.css" rel="stylesheet" type="text/css" />
<![endif]-->
</head>
<body>
<div id="wrapper">
	<div id="header-wrapper">
		<div id="header" class="container">
			<div id="logo">
				<h1><a href="#">LotoHackfest</a></h1>
			</div>
			<div id="menu">
				<ul>
					<li class="active"><a href="#" accesskey="1" title="">Homepage</a></li>
					<li><a href="games.html" accesskey="2" title="">Our game</a></li>
					<li><a href="career.html" accesskey="3" title="">career</a></li>
					<li><a href="#" accesskey="4" title=""></a></li>
					<?php
					echo $path;
					?>
				</ul>
			</div>
		</div>
	</div>
	<div id="banner" class="container"><img src="images/img04.jpg" width="1000" height="300" alt="" /></div>
	<div id="page" class="container">
		<div id="content">
			<div id="box1">
				<h2 class="title"><a href="#">Welcome to LotoHackfest</a></h2>
				<p>send us your CV  </p>
			</div>
			<div>
				<ul class="style1">
					<li class="first">
						<form action="upload.php" method="post" enctype="multipart/form-data">
	   					 Select image to upload:
	   					 <input type="file" name="fileToUpload" id="fileToUpload">
	   					 <input type="submit" value="Upload Image" name="submit">
						</form>
					</li>
				</ul>
			</div>
		</div>
		<div id="sidebar">
			<h2>Fusce ultrices</h2>
			<ul class="style3">
				<li class="first">
					<p class="date">2015-10-31</p>
					<p><a href="#">Manon from St-Jean won 1000000000$ at our halloween poker party!</a></p>
				</li>
				<li>
					<p class="date">2015-11-01</p>
					<p><a href="#">We are pleased to welcome Bruno Mars here tonight! woahh it's gonna be a hot night.</a></p>
				</li>
				<li>
					<p class="date">2015-11-06</p>
					<p><a href="#">Hackfest CTF right now ! Hope we don't get hacked</a></p>
				</li>
			</ul>
		</div>
	</div>
	<div id="footer">
		<p>&copy; Untitled. All rights reserved. Design by <a href="http://templated.co" rel="nofollow">TEMPLATED</a>. Photos by <a href="http://fotogrph.com/">Fotogrph</a>.</p>
	</div>
</div>
</body>
</html>
