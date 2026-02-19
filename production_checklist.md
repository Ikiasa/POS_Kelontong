# Production Readiness Checklist

## 1. Environment Configuration (.env)
- [ ] **APP_ENV**: Set to `production`
- [ ] **APP_DEBUG**: Set to `false`
- [ ] **APP_KEY**: Ensure it is generated (`php artisan key:generate`)
- [ ] **CACHE_STORE**: Set to `redis`
- [ ] **SESSION_DRIVER**: Set to `redis`
- [ ] **QUEUE_CONNECTION**: Set to `redis`

## 2. Server & Infrastructure
- [ ] **SSL Certificate**: Ensure HTTPS is forced.
- [ ] **Firewall**: Restrict ports (allow only 80, 443, 22). Block DB port (5432) from outside.
- [ ] **Timezone**: Ensure server and app timezone match `Asia/Jakarta`.

## 3. Database & Caching
- [ ] **Redis**: Ensure Redis is running and protected with a password.
- [ ] **PostgreSQL**: Optimize `shared_buffers` and `maintenance_work_mem` for the server size.
- [ ] **Backup**: Configure daily backups (e.g., using Spatie Backup).

## 4. Background Workers
- [ ] **Supervisor**: Install Supervisor to keep queue workers running.
  ```ini
  [program:laravel-worker]
  process_name=%(program_name)s_%(process_num)02d
  command=php /path/to/app/artisan queue:work redis --sleep=3 --tries=3
  autostart=true
  autorestart=true
  user=www-data
  numprocs=4
  ```

## 5. Security
- [ ] **File Permissions**:
  - `storage/` and `bootstrap/cache/` should be writable (775).
  - All other files should be read-only (644) and owned by root/deployment user.
- [ ] **Rate Limiting**: Ensure `ThrottleRequests` middleware is enabled on API routes.

## 6. Maintenance
- [ ] **Cron Jobs**: Add single cron entry:
  ```bash
  * * * * * cd /path/to/app && php artisan schedule:run >> /dev/null 2>&1
  ```
- [ ] **Log Rotation**: Configure Logrotate for Laravel logs in `storage/logs`.

## 7. Monitoring
- [ ] **Error Tracking**: Integration with Sentry or similar.
- [ ] **Uptime Monitoring**: Use UptimeRobot or similar.
