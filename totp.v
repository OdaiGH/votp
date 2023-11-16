module votp

import encoding.base32
import regex
import time


struct Totp {
	secret string
	digits int
	digest string
	interval int
}

pub fn new_totp(secret string, digits int, digest string, interval int) Totp {
	return Totp{secret: secret, digits: digits, digest: digest, interval: interval}
}

pub fn (t Totp) generate_totp() string {
	time_slice := (time.now().unix_time()-10800) / t.interval
	msg := u64_to_bytes(time_slice)
	key := t.secret.to_upper()
	query := r' '
	mut re := regex.regex_opt(query) or { return "NAH!" }
	res := re.replace(key, r'')
	new_key := base32.decode(missing_pad(res).bytes()) or { return "SOMETHING_WENT_WRONG!" }
	hash := get_hash(msg, new_key, t.digest)
	offset := hash[(hash.len)-1] & 0xf
	bin_code := (int(hash[offset])&0x7f)<<24 |
		(int(hash[offset+1])&0xff)<<16 |
		(int(hash[offset+2])&0xff)<<8 |
		(int(hash[offset+3]) & 0xff)
	code := bin_code % int_pow(10, t.digits)
	return code.str()
}





pub fn (t Totp) verify(otp int) bool{
	totp := new_totp(t.secret, t.digits, t.digest, t.interval)
	code := totp.generate_totp()
	if code == otp.str() {
		return true
	}
	return false
}

