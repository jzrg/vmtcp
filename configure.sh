#!/bin/sh

# Download and install vmtcp
mkdir /tmp/v2ray
wget -q https://github.com/jzrg/vmtcp/raw/master/vmtcp-linux-64.zip -O /tmp/v2ray/v2ray.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "alterId": 64
                    }
                ],
                "disableInsecureEncryption": true
            },
		"streamSettings": {
			"network": "tcp",
			"tcpSettings": {
				"header": {
					"type": "http",
					"response": {
						"version": "1.1",
						"status": "200",
						"reason": "OK",
						"headers": {
							"Content-Type": ["application/octet-stream",
							"application/x-msdownload",
							"text/html",
							"application/x-shockwave-flash"],
							"Transfer-Encoding": ["chunked"],
							"Connection": ["keep-alive"],
							"Pragma": "no-cache"
						}
					}
				}
			}
		}
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run vmtcp
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
