module vtotp
import crypto.hmac
import crypto.sha1
import crypto.sha256
import crypto.sha512
import time
import encoding.base32
import regex


pub const (
	v_version = '0.4.3 bc24683'
	author = 'odai alghamdi'
)

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


fn u64_to_bytes(n i64) []u8 {
	mut bytes := []u8{len: 8}
	mut nn := n
	for i := 7; i >= 0; i-- {
		bytes[i] = u8(nn & 0xff)
		nn >>= 8
	}
	return bytes
}

fn get_hash(msg []u8, key []u8, digest string) []u8 {
	match digest {
	"sha1" {
		return hmac.new(key,msg, sha1.sum, sha1.block_size)
	}
	"sha256"{
		return hmac.new(key,msg, sha256.sum, sha256.block_size)
	}
	"sha512" {
		return hmac.new(key,msg, sha512.sum512, sha512.block_size)
	}
	else{
		panic('Unsupported digest')
	}
	}
}

fn int_pow(base int, exp int) int {
	mut result := 1
	for i := 0; i < exp; i++ {
		result *= base
	}
	return result
}


fn missing_pad(text string) string {
	mut new_text := text
	missing_padding := text.len % 8
	missing := (8 - missing_padding)
	mut i := 0
	
	if missing_padding != 0 {
		
		for i < missing {
			new_text += '='
			i++

		}
	}

	return new_text
}


fn (t Totp) verify(otp int) bool{
	totp := new_totp(t.secret, t.digits, t.digest, t.interval)
	code := totp.generate_totp()
	if code == otp.str() {
		return true
	}
	return false
}

