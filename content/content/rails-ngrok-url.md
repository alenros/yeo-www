+++
date = "2017-01-07T23:25:55-08:00"
title = "rails ngrok url"
draft = true
tags = ["Rails", "DevOps"]

+++

During development of `noty.im`, we have to test out Twilio feature.
This mean Twilio server has to be able to reach our app. We love and use
`ngrok` but we cannot persist the domain.

So here is my simple setup to make this work


1. I set a environment var in our `.env` file to specifiy the address

2. I then customize how Rails boot in development mode to spawan `ngrok`
and recording the address then update the .env file
