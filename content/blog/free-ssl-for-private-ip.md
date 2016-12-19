+++
date = "2016-08-20T20:19:26-07:00"
draft = false
title = "free ssl for private ip"
tags = [ "https", "free", "ssl", "Let'sencrypt" ]

description = "Setting up Let'sencrypt is easier if server is on public network? How can we do that when it's private server but we still needs TLS for it, like a MongoDB cluster, or an internal dashboard behind VPN."
img = "l.jpg"
author = "vinh"
+++

Setting up Let'sencrypt is easier if server is on public network? How
can we do that when it's private server but we still needs TLS for it,
like a MongoDB cluster, or an internal dashboard behind VPN.

Well, DNS come to rescue. The idea is that now instead of using a web
server for Letsencrypt challenge, we will use DNS txt record. Example,
to verify `domain.com`, a TXT record for `_acme_challenge.domain.com`
with challenge response is created.

To make thing even easier, [lego](github.com/xenolf/lego) is a
let'sencrypt client written in Go lang so we only need to download the
binary and execute it withou installing on Python stuff like official
client.

## 1. Install lego

```
curl https://github.com/xenolf/lego/releases/download/v0.3.1/lego_linux_amd64.tar.xz
-o lego.tar.xz
tar xvfJ lego.tar.xz
mv lego /usr/local/bin/
chmod 0755 /usr/local/bin/lego
```

## 2. Create Route53 policy

We can use AWS API Key and Secret but this means we need to maintain and
pass they key somehow. Using IAM role is way easier. Simply createa an
IAM role with this policy:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:ListHostedZonesByName"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/<INSERT_YOUR_HOSTED_ZONE_ID_HERE>"
            ]
        }
    ]
}
```

## Create cert

On ec2 instance, run:

```
lego --email="foo@bar.com" --domains="example.com" --dns="route53" run
```

This will create a private key and cert in `.lego` directory in current working directory. 

## Renew

```
lego --email="foo@bar.com" --domains="example.com" --dns="route53" renew
```

We can put the renew command in `cron` to renew every 2 months
