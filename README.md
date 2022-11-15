# novnc-docker
[noVNC](https://novnc.com/info) in Docker

Based on [bonigarcia/novnc](https://github.com/bonigarcia/novnc)

## Setup
First install a VNC server such as
[TightVNC](https://www.tightvnc.com/).
Set its settings as:
- Server
  - Incoming Viewer Connections
    - Accept incoming connections: same port as configured in
      [`docker-compose.yml`](docker-compose.yml) (default 5900)
    - Require VNC authentication
    - Set the primary and view-only passwords
  - Miscellaneous
    - Enable file transfers: disable (if using for view only)
    - Connect to RDP session: enable
  - Web Access
    - Serve Java Viewer to Web clients: disable (noVNC is the JavaScript replacement for this)
  - Input Handling: Block remote input events (if using for view only)
- Access Control -> Loopback Connections
  - Allow loopback connections
  - Allow only loopback connections
- Administration -> Session Sharing
  - "Always treat connections as shared, add new clients and keep old connections"

Enable TLS and Syslog in
[`docker-compose.yml`](docker-compose.yml) if you can.
Then start the noVNC server with:
``` bash
docker compose up -d
```
