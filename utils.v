module votp
import crypto.hmac
import crypto.sha1
import crypto.sha256
import crypto.sha512


pub const (
	v_version = '0.4.3 bc24683'
	author = 'odai alghamdi'
)



pub fn u64_to_bytes(n i64) []u8 {
	mut bytes := []u8{len: 8}
	mut nn := n
	for i := 7; i >= 0; i-- {
		bytes[i] = u8(nn & 0xff)
		nn >>= 8
	}
	return bytes
}

pub fn get_hash(msg []u8, key []u8, digest string) []u8 {
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

pub fn int_pow(base int, exp int) int {
	mut result := 1
	for i := 0; i < exp; i++ {
		result *= base
	}
	return result
}


pub fn missing_pad(text string) string {
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