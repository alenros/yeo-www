k := kubectl
tls:
	$(k) -n yeo delete secret yeo-tls || true
	$(k) -n yeo create secret tls yeo-tls --key ~/.acme.sh/yeo.space/yeo.space.key --cert ~/.acme.sh/yeo.space/fullchain.cer
