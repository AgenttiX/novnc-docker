FROM python:3.11

ARG NOVNC_VERSION="1.3.0"
ARG WEBSOCKIFY_VERSION="0.10.0"

RUN \
    pip install --no-cache-dir numpy \
    && wget "https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.tar.gz" -O "novnc.tar.gz" \
    && wget "https://github.com/novnc/websockify/archive/refs/tags/v${WEBSOCKIFY_VERSION}.tar.gz" -O "websockify.tar.gz" \
    && mkdir "/novnc" \
    && tar -xzvf "novnc.tar.gz" -C "/novnc" --strip-components=1 \
    && mkdir "/novnc/utils/websockify" \
    && tar -xzvf "websockify.tar.gz" -C "/novnc/utils/websockify" --strip-components=1 \
    && rm "novnc.tar.gz" \
    && rm "websockify.tar.gz" \
    && ln -s "/novnc/vnc.html" "/novnc/index.html"

RUN \
    sed -i "/wait ${proxy_pid}/i if [ -n \"\$AUTOCONNECT\" ]; then sed -i \"s/'autoconnect', false/'autoconnect', '\$AUTOCONNECT'/\" /novnc/app/ui.js; fi" /novnc/utils/novnc_proxy \
    && sed -i "/wait ${proxy_pid}/i if [ -n \"\$VIEW_ONLY\" ]; then sed -i \"s/UI.rfb.viewOnly = UI.getSetting('view_only');/UI.rfb.viewOnly = \$VIEW_ONLY;/\" /novnc/app/ui.js; fi" /novnc/utils/novnc_proxy \
    && sed -i "/wait ${proxy_pid}/i if [ -n \"\$VNC_PASSWORD\" ]; then sed -i \"s/WebUtil.getConfigVar('password')/'\$VNC_PASSWORD'/\" /novnc/app/ui.js; fi" /novnc/utils/novnc_proxy

CMD ["/novnc/utils/novnc_proxy", "--vnc", "host.docker.internal:5900", "--listen", "0.0.0.0:80"]
