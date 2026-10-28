# PHP Update

<img src="/assets/images/tech/Dfront.jpg" width="1000" align="center">
  
<hr class="section-break strong" />





**Seabrae — PHP Security Updates and Recovery Procedure**

**Date:** 28 October 2026    
**Purpose:** Record the successful PHP security updates across Seabrae's WordPress and Nextcloud installations, and establish a repeatable procedure for future urgent patches.

## 1. Operating principles

We follow **one change, one test**.

- Identify which machine and installation actually run PHP.
- Establish the currently installed versions.
- Check the required patched versions and application compatibility.
- Back up the application, persistent files, database, configuration and original image identifier.
- Verify backups before changing anything.
- Update only the intended service.
- Verify the running PHP and application versions.
- Test the application through its normal interface.
- Keep a rollback path until satisfied.

Never assume that updating PHP on the Linux host updates PHP inside Docker or Snap.

<hr class="section-break strong" />






## 2. Server inventory

| Machine | Application | Installation | PHP after update |
|---|---|---|---|
| `i5Seabrae` | Tightbytes WordPress | Docker | 8.2.35 |
| `i5Seabrae` | Nextcloud 33.0.10 | Docker, now stopped | 8.4.27 |
| `seabrae` (Raspberry Pi) | Nextcloud 34.0.5 | Snap | 8.4.27 |

The Docker Nextcloud was discovered to be an apparently abandoned installation from May 2026. The Raspberry Pi serves the established Nextcloud installation.

<hr class="section-break strong" />










## 3. WordPress — i5Seabrae

**Compose directory:**

`/home/celestesh/docker/tightbytes/`

**Containers:**

- `tightbytes-web` — WordPress with Apache and PHP
- `tightbytes-db` — MariaDB 11

**Persistent directories:**

- `./html` — WordPress application and content
- `./db` — MariaDB data

**Port:** `8091:80`

**Cloudflare Tunnel:** `tightbytes.seabrae.org` forwards to `http://127.0.0.1:8091`.

### Versions

| Before | After |
|---|---|
| PHP 8.2.31 | PHP 8.2.35 |
| WordPress 7.0 | WordPress 7.0 |

### Backups created

Directory:

`~/docker/backups/tightbytes-2026-10-28/`

Contents include:

- `wordpress-html.tar.gz` — approximately 455 MB
- `tightbytes.sql` — approximately 1.9 MB
- Original Docker image identifier

The backups were checked for readability and SQL dump completion. They were not subjected to a full restore test.

### Update procedure used

From the WordPress Compose directory:

```bash
cd ~/docker/tightbytes
```

Pull the current image for the selected tag:

```bash
docker pull wordpress:php8.2-apache
```

Check the PHP version in the downloaded image:

```bash
docker run --rm --entrypoint php \
  wordpress:php8.2-apache -v
```

Recreate **only the WordPress web container**:

```bash
docker compose up -d \
  --no-deps \
  --force-recreate tightbytes-web
```

Verify the running version:

```bash
docker exec tightbytes-web php -v
```

Check the container:

```bash
docker ps --filter name=tightbytes
```

### Verification performed

WordPress public pages, administration and editing were tested successfully.

**Future consideration:** PHP 8.2 reaches end of security support in December 2026. A planned move to a supported PHP branch, likely PHP 8.4 if compatible, is preferable to another last-minute emergency.

<hr class="section-break strong" />







## 4. Nextcloud Docker — i5Seabrae

**Compose directory:**

`/home/celestesh/docker/nextcloud/`

**Containers:**

- `nextcloud-app`
- `nextcloud-cron`
- `nextcloud-db`
- `nextcloud-redis`

**Persistent directories:**

- `./nextcloud` — Nextcloud application and configuration
- `./data` — user data
- `./db` — MariaDB data

**Port:** `8080:80`

### Versions

| Before | After |
|---|---|
| Nextcloud 33.0.3 | Nextcloud 33.0.10 |
| PHP 8.4.20 | PHP 8.4.27 |

### Backups created

Directory:

`~/docker/backups/nextcloud-2026-10-28/`

Contents:

- `nextcloud-files.tar.gz` — approximately 379 MB
- `nextcloud.sql` — approximately 1 MB
- `docker-compose.yml`
- `.env` — contains secrets; protect carefully
- `original-image-id.txt`
- `original-status.txt`
- Replacement image identifier recorded during the update procedure

Backups were checked for archive readability and SQL dump completion, but not fully restore-tested.

### Update procedure used

Stop scheduled jobs:

```bash
cd ~/docker/nextcloud
docker compose stop cron
```

Enable maintenance mode:

```bash
docker exec -u www-data nextcloud-app \
  php /var/www/html/occ maintenance:mode --on
```

Check status:

```bash
docker exec -u www-data nextcloud-app \
  php /var/www/html/occ status
```

**Important:** Backups were completed and verified at this point, before recreating the application.

Download the version-pinned image:

```bash
docker pull nextcloud:33-apache
```

Verify its PHP version:

```bash
docker run --rm --entrypoint php \
  nextcloud:33-apache -v
```

The image was also checked to confirm that it contained Nextcloud 33.0.10.1.

The Compose file was edited so **both** `app` and `cron` used:

```yaml
image: nextcloud:33-apache
```

Validate the Compose configuration:

```bash
docker compose config --quiet
```

Recreate the application only:

```bash
docker compose up -d \
  --no-deps \
  --pull never \
  --force-recreate app
```

Verify PHP:

```bash
docker exec nextcloud-app php -v
```

Verify Nextcloud:

```bash
docker exec -u www-data nextcloud-app \
  php /var/www/html/occ status
```

The result was:

```text
version: 33.0.10.1
maintenance: true
needsDbUpgrade: false
```

No manual `occ upgrade` was needed. For future updates, check the status rather than assuming this will always be true.

Recreate cron:

```bash
docker compose up -d \
  --no-deps \
  --pull never \
  --force-recreate cron
```

Verify its PHP version:

```bash
docker exec nextcloud-cron php -v
```

Disable maintenance mode:

```bash
docker exec -u www-data nextcloud-app \
  php /var/www/html/occ maintenance:mode --off
```

The application was tested for reading and writing files.

### Subsequent discovery

Investigation showed:

- Only one account: `celestesh`.
- First accessed 3 May 2026.
- Last accessed 23 May 2026.
- Approximately 60 MB of user storage.
- Files appeared to be standard Nextcloud starter documents, photographs and templates.
- No dependencies were identified in the configurations searched.
- No route to this installation was found in the inspected Cloudflare Tunnel configuration.

The installation was therefore judged likely to be an abandoned experiment.

It was **stopped, not deleted**, using:

```bash
cd ~/docker/nextcloud
docker compose stop
```

Verification:

```bash
docker compose ps -a
```

All four containers were stopped. Application, database, configuration and backups remain intact.

### To restart the dormant installation if needed

```bash
cd ~/docker/nextcloud
docker compose up -d
```

Then verify container status and Nextcloud functionality.

Do not remove the installation until its lack of dependencies has been established with sufficient confidence.

<hr class="section-break strong" />








## 5. Raspberry Pi Nextcloud — Seabrae

**Host:** `seabrae`  
**Operating system:** Debian 13, ARM64  
**Installation:** Nextcloud Snap  
**Nextcloud:** 34.0.5  
**PHP:** 8.4.27

This is the established Nextcloud installation associated with `cloud.seabrae.org`.

### Important Snap commands

The normal `nextcloud.occ` command was not available on the shell's PATH.

The working command was:

```bash
sudo /snap/bin/nextcloud.occ status
```

To check PHP, open the Snap environment:

```bash
sudo snap run --shell nextcloud.occ
```

Then:

```bash
php -v
```

Leave the Snap shell:

```bash
exit
```

The bundled PHP was already version 8.4.27, so no update was necessary.

### Configuration findings

Trusted domains included:

- `cloud.seabrae.org`
- `192.168.0.36`
- `seabrae`
- A TailScale IPv4 address and hostname

The CLI URL was:

`http://192.168.0.36`

The Pi's Apache service listens on ports 80 and 443.

A local HTTPS test returned a `302` redirect to:

`https://cloud.seabrae.org/index.php/login`

The public hostname resolved to `101.167.173.177` at the time of testing.

The precise public router-forwarding path was not independently confirmed.

After the Docker Nextcloud installation on `i5Seabrae` was stopped, login to `cloud.seabrae.org` continued working successfully.

### Future Snap update checks

Inspect the installed version:

```bash
sudo snap list nextcloud
```

Inspect available refreshes:

```bash
sudo snap refresh --list
```

Do not manually refresh a production installation without first checking backup, compatibility and maintenance implications.

Snap updates follow a different procedure from Docker image updates.

<hr class="section-break strong" />










## 6. Cloudflare and network findings

On `i5Seabrae`, `cloudflared` runs as a systemd service.

Its configuration is:

`/etc/cloudflared/config.yml`

It includes local routes for:

- `media.seabrae.org` → port 8090
- `emily.seabrae.org` → port 8088
- `tightbytes.seabrae.org` → port 8091
- `catalogue.seabrae.org` → port 5051

The Docker Nextcloud installation was not listed.

WordPress currently publishes port 8091 on all host interfaces. This is a candidate for restriction to localhost, after checking whether any LAN clients require direct access.

A future configuration might use:

```yaml
ports:
  - "127.0.0.1:8091:80"
```

**This change has not yet been made.**

The dormant Docker Nextcloud previously published port 8080 on all host interfaces. Stopping it should have removed that listener, although a final socket check remains advisable:

```bash
sudo ss -ltnp | grep ':8080'
```

Router port-forwarding and firewall rules were not comprehensively audited.

<hr class="section-break strong" />









## 7. Standard checklist for future PHP security advisories

### Before updating

1. Identify affected PHP branches and fixed versions from authoritative advisories.
2. Identify every affected installation and its host.
3. Determine whether PHP is managed by the host OS, Docker, Snap or another packaging system.
4. Check application compatibility with the intended PHP release.
5. Record current versions and image identifiers.
6. Create database, file and configuration backups.
7. Verify that the backups are readable.
8. Plan downtime and rollback before deployment.

### During updating

1. Stop background jobs where appropriate.
2. Enable application maintenance mode where appropriate.
3. Download the intended patched image or package.
4. Verify its actual PHP version.
5. Update only the intended service.
6. Inspect logs and application status.
7. Perform required database migrations only when indicated.
8. Restore background jobs and normal access.

### After updating

1. Confirm the running PHP version.
2. Confirm the application version and database status.
3. Test login, file access, editing and uploads as appropriate.
4. Confirm scheduled jobs and synchronisation.
5. Inspect network listeners and unexpected exposures.
6. Retain backups and record the outcome.

<hr class="section-break strong" />







## 8. Important lessons

**Docker tags are not fixed version guarantees.** Pulling the same tag later may retrieve a newer image. Always inspect the actual version and record the image identifier.

**A working application is not proof that every component is patched.** Check PHP separately in the application and cron containers.

**A published Docker port is not automatically a publicly reachable internet port.** Its exposure depends on firewall, router and network configuration.

**Two Nextcloud installations are not necessarily synchronised.** The Pi and Docker installations had separate databases and storage.

**Different Finder folder lists do not necessarily mean different servers.** The MacBook Air's missing folders were explained by selective Nextcloud synchronisation.

**Never delete an apparently redundant service immediately.** Stop it reversibly, test dependencies, and retain its data and backups.

<hr class="section-break strong" />









## 9. Outstanding tasks

- Verify that no service is still listening on `i5Seabrae` port 8080.
- Review router port-forwarding and host firewall rules.
- Consider binding WordPress port 8091 to localhost only.
- Plan WordPress migration away from PHP 8.2 before end of security support.
- Retain the stopped Docker Nextcloud and its backup until confident it can be removed.
- Periodically verify the PHP versions included in Docker and Snap updates.

---

**Outcome — 28 October 2026:** The three identified PHP installations were verified on the targeted patched versions. WordPress and the Raspberry Pi Nextcloud remain operational. The apparently unused Docker Nextcloud installation was safely stopped with its data preserved.

<hr class="section-break strong" />

<!--  Image references  -->

--8<-- "includes/image-references.md"

🌷
