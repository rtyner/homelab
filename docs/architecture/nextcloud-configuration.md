## Nextcloud Configuration

## File Locations

- nextcloud.log - /var/www/html/nextcloud/data/nextcloud.log
- config.php - /var/www/html/nextcloud/config/config.php
- index.php - /var/www/html/nextcloud/index.php
- php.ini - /etc/php/7.4/apache2/php.ini

## Tuning Nextcloud

- PHP config
```php
#/etc/php/7.4/apache2/php.ini
php_value upload_max_filesize 128G
php_value post_max_size 128G
output_buffering = 0
memory_limit = 2G
```
- Nextcloud config
```php
#/var/www/html/nextcloud/config/config.php
filelocking_enabled => true
```
- [Add missing db indicies](https://help.nextcloud.com/t/some-indices-are-missing-in-the-database-how-to-add-them-manually/37852) - `sudo -u www-data php occ db:add-missing-indices`
- [Setup proper redirects for caldav, cardav, nodeinfo, and webfinger](https://docs.nextcloud.com/server/24/admin_manual/issues/general_troubleshooting.html#service-discovery)
	- edit .htaccess in nextcloud root and add the below lines

```shell
<IfModule mod_rewrite.c>
  RewriteEngine on
  RewriteRule ^/\.well-known/carddav /nextcloud/remote.php/dav [R=301,L]
  RewriteRule ^/\.well-known/caldav /nextcloud/remote.php/dav [R=301,L]
  RewriteRule ^/\.well-known/webfinger /nextcloud/index.php/.well-known/webfinger [R=301,L]
  RewriteRule ^/\.well-known/nodeinfo /nextcloud/index.php/.well-known/nodeinfo [R=301,L]
</IfModule>
```
- [Convert database to BigInt](https://docs.nextcloud.com/server/24/admin_manual/configuration_database/bigint_identifiers.html)
- Enable maintenance mode, stop apache, and enter `sudo -u www-data php occ db:convert-filecache-bigint`

## Troubleshooting

- scanning files - `sudo -u www-data php occ files:scan --all`
- delete locked files from db
	- Enable maintenance mode
	- `sudo mysql -u nextcloud-user -p nextcloud`
	- `DELETE FROM oc_file_locks WHERE 1`
- Cannot move file
	- check permissions on the data directory, everything has to be owned by www-data:www-data