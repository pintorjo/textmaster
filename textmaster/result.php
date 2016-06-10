<style>
html{
background: url(back.jpg) no-repeat center center fixed;
background-size: 100% 100%;
}

div{
position: relative;
top: 80px;
left: 800px;
}
</style>

<?php
header("Content-Type: text/html; charset=UTF-8");
?>

<?php

$key = $_POST["keyword"];
$gender = $_POST["gender"];
$age = $_POST["age"];
$region = $_POST["region"];

$host = 'localhost';
$user = 'root';
$pass = '0427';
$db = 'textmaster';
$connect = mysql_connect($host, $user, $pass);

mysql_select_db($db, $connect);

$sql = "INSERT into personal (keyword, gender, age, region) values ('$key', '$gender', '$age', '$region')";
mysql_query($sql) or die (mysql_error());

if(!$connect)
{
	echo "[DB연결실패]<br/>";
}
  
  $key= urlencode($key);
 
  $url = "https://openapi.naver.com/v1/search/news.xml?query=%5B%EC%82%AC%EC%84%A4%5D".$key."&display=10&start=1&sort=sim";
  
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
  
  $headers = array(
	"Content-Type: application/xml",
	"X-Naver-Client-Id: 8h2TIvEwj35ibQSWLn04",
	"X-Naver-Client-Secret: o56LD6UUGJ"
	);
  
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  
  $data = curl_exec($ch);
  
  if($data == false)
    {
        echo "Error Number:".curl_errno($ch)."<br>";
        echo "Error String:".curl_error($ch);
    }

  curl_close($ch);

  $data = iconv("UTF-8", "EUC-KR", $data);
  
  $body_str = explode('<originallink>', $data); 
 
  $arr = array();
  
  $i = 1;
  
  while ($i < count($body_str)) {
  
  $menu_str = explode('</originallink>', $body_str[$i]);
  $j = $i-1;
  $arr[$j] = $menu_str[0];
  $query = "INSERT INTO editorial VALUES ('$arr[$j]')";
  mysql_query($query, $connect);
  $i++;
  
  }
  
  exec('crawler.py');
?>
<html>
<div>
<image src="TMLOGO.png" height="270" width="270">
</div>
<div>
<h3>기사가 모두 수집되었습니다.</h3>
<h3>분석을 시작하려면 아래 버튼을 클릭해주세요.</h3>
<a href="http://127.0.0.1:6420/"><button style="width: 400px;height: 100px; font-size:30px;">눌러주세요!</button></a>
</div>
</html>
