Return-Path: <vito.caputo@coreos.com>
MIME-Version: 1.0
Date: Wed, 21 Oct 2015 15:41:00 -0700
Message-ID: <CAKp8XJ4QYqdJEevtnb_KRPfCqTT5Hq_jhppnaqdvLtycA2fAyw@mail.gmail.com>
Subject: [PATCH] overlayfs: use a minimal buffer in ovl_copy_xattr
From: Vito Caputo <vito.caputo@coreos.com>
Content-Type: multipart/mixed; boundary=047d7bd75cec99e67a0522a5124b
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

--047d7bd75cec99e67a0522a5124b
Content-Type: multipart/alternative; boundary=047d7bd75cec99e6740522a51249

--047d7bd75cec99e6740522a51249
Content-Type: text/plain; charset=UTF-8

Greetings,

We've been receiving reports of ooms triggered by the high-order allocation
in the overlayfs ovl_copy_xattr() implementation.

The bug is in the handling of direct-reclaim high-order allocations (and
appears to be known and actively being worked on).  Rather than do
something hacky in mm and potentially destabilize everything for a quick
fix, I've put together a simple patch changing the allocation to an
as-needed krealloc() approach which should eliminate the ooms, since 64KiB
extended attributes are uncommon.

CoreOS issue tracking the bug:
https://github.com/coreos/bugs/issues/489

Specific commit in our coreos-linux repo (same as attached):
https://github.com/coreos/linux/commit/885f27cadbb562bb405c258ab6053f52efbf4de7

Regards,
Vito Caputo

--047d7bd75cec99e6740522a51249
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div>Greetings,<br><br></div=
>We&#39;ve been receiving reports of ooms triggered by the high-order alloc=
ation in the overlayfs ovl_copy_xattr() implementation.<br><br></div>The bu=
g is in the handling of direct-reclaim high-order allocations (and appears =
to be known and actively being worked on).=C2=A0 Rather than do something h=
acky in mm and potentially destabilize everything for a quick fix, I&#39;ve=
 put together a simple patch changing the allocation to an as-needed kreall=
oc() approach which should eliminate the ooms, since 64KiB extended attribu=
tes are uncommon.<br><br></div>CoreOS issue tracking the bug:<br><a href=3D=
"https://github.com/coreos/bugs/issues/489">https://github.com/coreos/bugs/=
issues/489</a><br><br></div></div>Specific commit in our coreos-linux repo =
(same as attached):<br><a href=3D"https://github.com/coreos/linux/commit/88=
5f27cadbb562bb405c258ab6053f52efbf4de7">https://github.com/coreos/linux/com=
mit/885f27cadbb562bb405c258ab6053f52efbf4de7</a><br><br></div>Regards,<br><=
/div>Vito Caputo<br><div><div><div><br></div></div></div></div>

--047d7bd75cec99e6740522a51249--

--047d7bd75cec99e67a0522a5124b
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-overlayfs-use-a-minimal-buffer-in-ovl_copy_xattr.patch"
Content-Disposition: attachment;
	filename="0001-overlayfs-use-a-minimal-buffer-in-ovl_copy_xattr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ig1dpe540

RnJvbSA4ODVmMjdjYWRiYjU2MmJiNDA1YzI1OGFiNjA1M2Y1MmVmYmY0ZGU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaXRvIENhcHV0byA8dml0by5jYXB1dG9AY29yZW9zLmNvbT4K
RGF0ZTogTW9uLCAxOSBPY3QgMjAxNSAxNzo1MzoxMiAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIG92
ZXJsYXlmczogdXNlIGEgbWluaW1hbCBidWZmZXIgaW4gb3ZsX2NvcHlfeGF0dHIKClJhdGhlciB0
aGFuIGFsd2F5cyBhbGxvY2F0aW5nIHRoZSBoaWdoLW9yZGVyIFhBVFRSX1NJWkVfTUFYIGJ1ZmZl
cgp3aGljaCBpcyBjb3N0bHkgYW5kIHByb25lIHRvIGZhaWx1cmUsIG9ubHkgYWxsb2NhdGUgd2hh
dCBpcyBuZWVkZWQgYW5kCnJlYWxsb2MgaWYgbmVjZXNzYXJ5LgoKRml4ZXMgaHR0cHM6Ly9naXRo
dWIuY29tL2NvcmVvcy9idWdzL2lzc3Vlcy80ODkKLS0tCiBmcy9vdmVybGF5ZnMvY29weV91cC5j
IHwgMzEgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIy
IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvb3ZlcmxheWZz
L2NvcHlfdXAuYyBiL2ZzL292ZXJsYXlmcy9jb3B5X3VwLmMKaW5kZXggOGY2NmIzOS4uOTQyNmU2
MCAxMDA2NDQKLS0tIGEvZnMvb3ZlcmxheWZzL2NvcHlfdXAuYworKysgYi9mcy9vdmVybGF5ZnMv
Y29weV91cC5jCkBAIC0yMiw4ICsyMiw4IEBACiAKIGludCBvdmxfY29weV94YXR0cihzdHJ1Y3Qg
ZGVudHJ5ICpvbGQsIHN0cnVjdCBkZW50cnkgKm5ldykKIHsKLQlzc2l6ZV90IGxpc3Rfc2l6ZSwg
c2l6ZTsKLQljaGFyICpidWYsICpuYW1lLCAqdmFsdWU7CisJc3NpemVfdCBsaXN0X3NpemUsIHNp
emUsIHZhbHVlX3NpemUgPSAwOworCWNoYXIgKmJ1ZiwgKm5hbWUsICp2YWx1ZSA9IE5VTEw7CiAJ
aW50IGVycm9yOwogCiAJaWYgKCFvbGQtPmRfaW5vZGUtPmlfb3AtPmdldHhhdHRyIHx8CkBAIC00
MSwyMyArNDEsMzYgQEAgaW50IG92bF9jb3B5X3hhdHRyKHN0cnVjdCBkZW50cnkgKm9sZCwgc3Ry
dWN0IGRlbnRyeSAqbmV3KQogCWlmICghYnVmKQogCQlyZXR1cm4gLUVOT01FTTsKIAotCWVycm9y
ID0gLUVOT01FTTsKLQl2YWx1ZSA9IGttYWxsb2MoWEFUVFJfU0laRV9NQVgsIEdGUF9LRVJORUwp
OwotCWlmICghdmFsdWUpCi0JCWdvdG8gb3V0OwotCiAJbGlzdF9zaXplID0gdmZzX2xpc3R4YXR0
cihvbGQsIGJ1ZiwgbGlzdF9zaXplKTsKIAlpZiAobGlzdF9zaXplIDw9IDApIHsKIAkJZXJyb3Ig
PSBsaXN0X3NpemU7Ci0JCWdvdG8gb3V0X2ZyZWVfdmFsdWU7CisJCWdvdG8gb3V0OwogCX0KIAog
CWZvciAobmFtZSA9IGJ1ZjsgbmFtZSA8IChidWYgKyBsaXN0X3NpemUpOyBuYW1lICs9IHN0cmxl
bihuYW1lKSArIDEpIHsKLQkJc2l6ZSA9IHZmc19nZXR4YXR0cihvbGQsIG5hbWUsIHZhbHVlLCBY
QVRUUl9TSVpFX01BWCk7CityZXRyeToKKwkJc2l6ZSA9IHZmc19nZXR4YXR0cihvbGQsIG5hbWUs
IHZhbHVlLCB2YWx1ZV9zaXplKTsKKwkJaWYgKHNpemUgPT0gLUVSQU5HRSkgeworCQkJc2l6ZSA9
IHZmc19nZXR4YXR0cihvbGQsIG5hbWUsIE5VTEwsIDApOworCQl9CisKIAkJaWYgKHNpemUgPD0g
MCkgewogCQkJZXJyb3IgPSBzaXplOwogCQkJZ290byBvdXRfZnJlZV92YWx1ZTsKIAkJfQorCisJ
CWlmIChzaXplID4gdmFsdWVfc2l6ZSkgeworCQkJdm9pZCAqbmV3OworCQkJbmV3ID0ga3JlYWxs
b2ModmFsdWUsIHNpemUsIEdGUF9LRVJORUwpOworCQkJaWYgKCFuZXcpIHsKKwkJCQllcnJvciA9
IC1FTk9NRU07CisJCQkJZ290byBvdXRfZnJlZV92YWx1ZTsKKwkJCX0KKwkJCXZhbHVlID0gbmV3
OworCQkJdmFsdWVfc2l6ZSA9IHNpemU7CisJCQlnb3RvIHJldHJ5OworCQl9CisKIAkJZXJyb3Ig
PSBzZWN1cml0eV9pbm9kZV9jb3B5X3VwX3hhdHRyKG9sZCwgbmV3LAogCQkJCQkJICAgICBuYW1l
LCB2YWx1ZSwgJnNpemUpOwogCQlpZiAoZXJyb3IgPCAwKQotLSAKMi40LjYKCg==
--047d7bd75cec99e67a0522a5124b--
