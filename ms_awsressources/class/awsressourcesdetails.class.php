<?php

 /**
  * This class will show a detailed view of what's in the AWS infrastructure
  */
class AWSDetails {

  private $tableName = null;
  private $fieldArray = null;

  private $queryRepo = array(
    "SHOW_COLUMNS" => "SHOW COLUMNS FROM %s",
    "SELECT_FROM_TABLE" => "SELECT %s FROM %s",
  );

  public $finalQuery = null;

  public $viewList = array(
    "AWS_INSTANCES" => "AWS_INSTANCES",
    "AWS_NETWORKS" => "AWS_NETWORKS",
    "AWS_SPECS" => "AWS_SPECS",
  );


  public function setTableName($tableName){
    $this->tableName = $tableName;
  }

  public function getTableName(){
    return $this->tableName;
  }

  private function getTableFieldList(){
     $result = mysql2_query_secure($this->queryRepo['SHOW_COLUMNS'], $_SESSION['OCS']["readServer"], $this->tableName);

    if($result != false){
      while($row = $result->fetch_assoc()){
        if($row['Field'] != "ID"){
           $this->fieldArray[] = $row['Field'];
        }
      }
      return true;
    }else{
      return false;
    }

  }

  private function generateQueryFromFieldList(){
     $fieldList = implode(', ', $this->fieldArray);
     $this->finalQuery =  sprintf($this->queryRepo['SELECT_FROM_TABLE'], $fieldList, $this->tableName);
  }

  private function generateDatatable(){

    $listFields = array();
    foreach ($this->fieldArray as $field) {
      $listFields[$field] = $field;
    }
    $defaultFields = $listFields;

    $listColCantDel = array('ID' => 'ID');

    $tabOptions['form_name'] = $this->tableName;
    $tabOptions['table_name'] = $this->tableName;

    $tableDetails = array();

    $tableDetails["listFields"] = $listFields;
    $tableDetails["defaultFields"] = $defaultFields;
    $tableDetails["tabOptions"] = $tabOptions;
    $tableDetails["listColCantDel"] = $listColCantDel;

    return $tableDetails;

  }

  public function processTable($tabName){
    if(!in_array($tabName, $this->viewList)){
      return false;
    }

    $this->setTableName($tabName);
    if($this->getTableFieldList()){
      $this->generateQueryFromFieldList();
      return($this->generateDatatable());
    }

  }

  public function showAwsLeftMenu($activeMenu){
    $menuArray = $this->viewList;
    error_log(print_r($menuArray, true));

    echo '<ul class="nav nav-pills nav-stacked navbar-left">';
    foreach ($menuArray as $key=>$value){

        echo "<li ";
        if ($activeMenu == $value) {
            echo "class='active'";
        }
        echo " ><a href='?function=ms_awsressources&list=".$value."'>".$key."</a></li>";
    }
    echo '</ul>';
  }

}
