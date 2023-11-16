module votp

import encoding.base32
import regex


struct Hotp {
	secret string
	digits int
	digest string
}

pub fn new_hotp(secret string, digits int, digest string) Hotp {
	return Hotp{secret: secret, digits: digits, digest: digest}
}

pub fn (h Hotp) generate_hotp(counter int) string {
	msg := u64_to_bytes(counter)
	key := h.secret.to_upper()
	query := r' '
	mut re := regex.regex_opt(query) or { return "NAH!" }
	res := re.replace(key, r'')
	new_key := base32.decode(missing_pad(res).bytes()) or { return "SOMETHING_WENT_WRONG!" }
	hash := get_hash(msg, new_key, h.digest)
	offset := hash[(hash.len)-1] & 0xf
	bin_code := (int(hash[offset])&0x7f)<<24 |
		(int(hash[offset+1])&0xff)<<16 |
		(int(hash[offset+2])&0xff)<<8 |
		(int(hash[offset+3]) & 0xff)
	code := bin_code % int_pow(10, h.digits)
	return code.str()
}


pub fn (h Hotp) verify(otp int, counter int) bool{
	totp := new_hotp(h.secret, h.digits, h.digest)
	code := totp.generate_hotp(counter)
	if code == otp.str() {
		return true
	}
	return false
}


