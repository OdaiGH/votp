# V OTP 0.1

votp enables you to add TOTP or HOTP functionaltiies in your code [the V programming language](https://vlang.io).

[![Twitter URL](https://img.shields.io/twitter/url.svg?label=Follow%20odai_alghamdi&style=social&url=https%3A%2F%2Ftwitter.com%2Fodai_alghamdi)](https://twitter.com/odai_alghamdi)

## Installation

```
v up
v install OdaiGH.votp
```

## Usage
Time-based one-time password is as follows

```v ignore
>>> totp := new_totp("YOUR_SECRET", 6, "TYPE_OF_DIGEST", INTERVAL_IN_SECONDS) // DIGESTS SUPPORT are {sha1,sha256,sha512}
>>> totp := new_totp("odai alghamdi", 6, "sha512", 30)
>>> generated_otp := totp.generate_totp()
214205
>>> verify_otp := totp.verify(214205) //verify if given otp at the current time is correct
true
>>> verify_otp := totp.verify(123456)
false
```

HMAC-based one-time password is as follows

```v ignore
>>> totp := new_totp("YOUR_SECRET", 6, "TYPE_OF_DIGEST") // DIGESTS SUPPORT are {sha1,sha256,sha512}
>>> totp := new_totp("base32secret3232", 6, "sha512")
>>> generated_otp := totp.generate_totp(COUNTER) // COUNTER for your hmac otp
>>> generated_otp := totp.generate_totp(0) // COUNTER for your hmac otp
492039
>>> verify_otp := totp.verify(492039,0) //verify if given otp at the current counter is correct
true
>>> verify_otp := totp.verify(492039,1)
false
```
### License
V otp is licensed under MIT.

### Contributing
Follow the instructions in [CONTRIBUTING.md](https://github.com/OdaiGH/votp/blob/master/CONTRIBUTING.md)
