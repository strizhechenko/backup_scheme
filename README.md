# backup_scheme

Схема бэкапов, в которой они доступны почти за любой срок давности, но их не становится очень много.

## Как правильно забирать такие бэкапы

```
rsync -aH --delete --progress user@system-where-app-is-running:/var/backups/place-where-app-stores-local-backups/ /remote/backup_system/backups/directory-dedicated-for-app-backups/
```

- Ротация бэкапов производится только локально и ей _нужно_ доверять (поэтому флаг `--delete`).
- Флаг `-H` означает учёт хардлинков, на которые завязывается механика ротации.
