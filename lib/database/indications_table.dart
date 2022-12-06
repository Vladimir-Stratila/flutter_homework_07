const String tableName = 'indications';
const String columnId = 'id';
const String columnDateTime = 'date_time';
const String columnCharge = 'charge';
const String columnIsCharging = 'is_charging';
const String columnWiFi = 'wifi';
const String columnInternet = 'internet';

const String createTableQuery = '''
CREATE TABLE IF NOT EXISTS $tableName (
$columnId integer PRIMARY KEY AUTOINCREMENT,
$columnDateTime text,
$columnCharge integer,
$columnIsCharging integer,
$columnWiFi integer,
$columnInternet integer
);
''';