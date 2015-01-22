<?php
$runtime= new runtime;
$runtime->start();
class runtime
{ 
    var $StartTime = 0; 
    var $StopTime = 0; 
    function get_microtime() 
    { 
        list($usec, $sec) = explode(' ', microtime()); 
        return ((float)$usec + (float)$sec); 
    } 
    function start() 
    { 
        $this->StartTime = $this->get_microtime(); 
    } 
    function stop() 
    { 
        $this->StopTime = $this->get_microtime(); 
    } 
    function spent() 
    { 
        return round(($this->StopTime - $this->StartTime) * 1000, 1); 
    } 
}

header("content-Type: text/html; charset=utf-8");
header("Cache-Control: no-cache, must-revalidate");
header("Pragma: no-cache");

$sysReShow = (false !== ($sysInfo = sysInfo()))?"show":"none";
function sysInfo()
{
// UPTIME
        if (false === ($str = @file("/proc/uptime"))) return false;
        $str = explode(" ", implode("", $str));
        $str = trim($str[0]);
        $min = $str / 60;
        $hours = $min / 60;
        $days = floor($hours / 24);
        $hours = floor($hours - ($days * 24));
        $min = floor($min - ($days * 60 * 24) - ($hours * 60));
        if ($days !== 0) $res['uptime'] = $days."天";
        if ($hours !== 0) $res['uptime'] .= $hours."小時";
        $res['uptime'] .= $min."分鐘";
// FREETIME
        if (false === ($str = @file("/proc/uptime"))) return false;
        $str = explode(" ", implode("", $str));
        $str = trim($str[1]);
        $min = $str / 60;
        $hours = $min / 60;
        $days = floor($hours / 24);
        $hours = floor($hours - ($days * 24));
        $min = floor($min - ($days * 60 * 24) - ($hours * 60));
        if ($days !== 0) $res['freetime'] = $days."天";
        if ($hours !== 0) $res['freetime'] .= $hours."小時";
        $res['freetime'] .= $min."分鐘";
        return $res;
}

$net="eth0:";  //網卡編號
$disk="/dev/sda1";  //硬盤編號
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SysInfo</title>
</head>
<body>
<?php
echo '<pre>';
echo "Hello ! <br/>\n";
if("show"==$sysReShow){
	echo "運行時間:".$sysInfo['uptime']."\n";
	echo "空閒時間:".$sysInfo['freetime']."\n";
}
system("/bin/cat /proc/loadavg | awk '{print \"Load Average: \"$1\" \"$2\" \"$3\" \"$4}'");
echo "<br/>\n";
system("/bin/df -h | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"硬盤共有: \"$2}'");
system("/bin/df -h | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"硬盤已用: \"$3}'");
system("/bin/df -h | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"硬盤可用: \"$4}'");
system("/bin/df -h | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"硬盤已用比例: \"$5}'");
echo "<br/>\n";
system("/bin/df -i | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"Inode共有: \"$2}'");
system("/bin/df -i | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"Inode已用: \"$3}'");
system("/bin/df -i | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"Inode可用: \"$4}'");
system("/bin/df -i | grep \"".$disk."\" | awk -F'/dev/' '{print $2}' | awk '{print \"Inode已用比例: \"$5}'");
echo "<br/>\n";
system("/usr/bin/free -m | grep Mem | awk '{print \"Mem共有: \"$2\"MB\"}'");
system("/usr/bin/free -m | grep Mem | awk '{print \"Mem已使用: \"$3\"MB\"}'");
system("/usr/bin/free -m | grep Mem | awk '{print \"Buffers化內存: \"$6\"MB\"}'");
system("/usr/bin/free -m | grep Mem | awk '{print \"Cached化內存: \"$7\"MB\"}'");
system("/usr/bin/free -m | grep Mem | awk '{print \"Mem空閒: \"$4\"MB\"}'");
system("/usr/bin/free -m | grep buffers/cache: | awk '{print \"Men實際已用: \"$3\"MB\"}'");
system("/usr/bin/free -m | grep buffers/cache: | awk '{print \"Mem實際空閒: \"$4\"MB\"}'");
echo "<br/>\n";
system("/usr/bin/free | grep Swap | awk '{print \"Swap共有: \"$2/1024\"MB\"}'");
system("/usr/bin/free | grep Swap | awk '{print \"Swap已用: \"$3/1024\"MB\"}'");
system("/usr/bin/free | grep Swap | awk '{print \"Swap空閒: \"$4/1024\"MB\"}'");
echo "<br/>\n";
system("/bin/cat /proc/net/dev | grep \"".$net."\" | awk -F'".$net."' '{print $2}' | awk '{print \"已接收: \"$1/1024/1024\"MB\"}'");
system("/bin/cat /proc/net/dev | grep \"".$net."\" | awk -F'".$net."' '{print $2}' | awk '{print \"已發送: \"$9/1024/1024\"MB\"}'");
echo "<br/>\n";
system('netstat -n | awk \'/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}\'');
echo "<br/>\n";
system('netstat -ntu | awk \'{print $5}\' | egrep -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c | sort -nr');
echo "<br/>\n";
system("/bin/date");
echo "<br/>\n";
$runtime->stop();
echo "頁面執行時間: ".$runtime->spent()." 毫秒";
echo '</pre>';
?>
</body>
</html>