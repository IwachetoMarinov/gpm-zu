<?php
/* dbo_db/ProformaInvoice.php */

namespace dbo_db;

include_once 'data/CRMEntity.php';
include_once 'modules/Users/Users.php';
include_once 'helpers/DBConnection.php';
include_once 'dbo_db/GetDBRows.php';

use helpers\DBConnection;

class ProformaInvoice
{
    private $connection;
    private $database_prefix;

    public function __construct()
    {
        $this->connection = DBConnection::getConnection();
        $this->database_prefix = DBConnection::getDatabasePrefix();
    }

    public function getProformaInvoice(string $client_id, string $table_name)
    {
        if (!$client_id || !$table_name || !$this->connection) return [];

        try {
            $params = [];
            $where  = '';

            if ($client_id) {
                $where = "WHERE [Party_Code] = ?";
                $params[] = $client_id;
            }

            $sql = "SELECT * FROM $this->database_prefix.[$table_name] $where";

            $summary = GetDBRows::getRows($this->connection, $sql, $params);

            return $summary;
        } catch (\Exception $e) {
            return [];
        }
    }
}
