<?php

 if (AJAX) {
     parse_str($protectedPost['ocs']['0'], $params);
     $protectedPost += $params;
     ob_start();
 }

 require("class/awsresourcesdetails.class.php");

// Process Get
if(isset($_GET['list'])){
  $activeMenu = $_GET['list'];
}else{
  $activeMenu = "AWS_INSTANCES";
}

printEnTete($l->g(56001));
// Generate left menu
$details = new AWSDetails();
echo "<div class='col-md-2'>";
$details->showAwsLeftMenu($activeMenu);
echo "</div>";


$tabOptions = $protectedPost;
// Generate Right Tab with data
$tableDetails = $details->processTable($activeMenu);

$tabOptions['table_name'] = $tableDetails['tabOptions']['table_name'];
$tabOptions['form_name'] = $tableDetails['tabOptions']['form_name'];

echo "<div class='col-md-10'>";
echo open_form($tabOptions['table_name'], '', '', 'form-horizontal');
ajaxtab_entete_fixe($tableDetails['listFields'], $tableDetails['defaultFields'], $tabOptions,  $tableDetails['listColCantDel']);
echo close_form();
echo "</div>";

if (AJAX) {
  ob_end_clean();
  tab_req($tableDetails['listFields'], $tableDetails['defaultFields'], $tableDetails['listColCantDel'], $details->finalQuery, $tabOptions);
  ob_start();
}
