$databases['default']['default'] = [
  'driver' => 'mysql',
  'host' => 'mysql',
  'database' => getenv('MYSQL_DATABASE'),
  'username' => getenv('MYSQL_USER'),
  'password' => getenv('MYSQL_PASSWORD'),
];