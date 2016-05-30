From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v3 00/17] Xattr inode operation removal
Date: Mon, 30 May 2016 21:29:37 +0200
Message-ID: <CAHc6FU5_ptUJG15k+c=5xcBa1CtNXzVk3pC7jT5iW_CU56tnFA@mail.gmail.com>
References: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
	<CA+icZUXGxsw-g1W8QzwuFx=8UTnxzQD9UsNEH2PHCGrqW=0xdA@mail.gmail.com>
	<CAHc6FU6gZHEcrqvyKdKJbFVrd0L8=M2ynm2GD6tQx32fzTjD=g@mail.gmail.com>
	<CA+icZUVmB1pSuG1_3-nkiKjoDH9UrvUEsZjy8hS6_+Y2yDyruA@mail.gmail.com>
	<CA+icZUWVdtqK4OcXhjVDbrqfXBO5-DpbB5nVpX+iTN_RBDH5Xw@mail.gmail.com>
	<CAHc6FU40o3VpzV-oL81NqrYB3Ryt-nCOeEZCfnQSPFZ==cWvDA@mail.gmail.com>
	<CA+icZUWUkY7Rj6+K26tAffUtCbySLiCvyD+ZYvoPrJPQO1cO+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c0485daf08b8105341446f7
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+icZUWUkY7Rj6+K26tAffUtCbySLiCvyD+ZYvoPrJPQO1cO+w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: sedat.dilek@gmail.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, LSM <linux-security-module@vger.kernel.org>, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

--94eb2c0485daf08b8105341446f7
Content-Type: text/plain; charset=UTF-8

On Mon, May 30, 2016 at 8:51 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Which "trusted." line or lines shall I remove?

You can try something like the attached patch. Ovetall, the test case
doesn't seem very useful.

Thanks,
Andreas

--94eb2c0485daf08b8105341446f7
Content-Type: text/x-patch; charset=US-ASCII; name="ltp-xattr.patch"
Content-Disposition: attachment; filename="ltp-xattr.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ioueqojr0

ZGlmZiAtLWdpdCBhL3Rlc3RjYXNlcy9rZXJuZWwvY29udHJvbGxlcnMvY2dyb3VwX3hhdHRyL2Nn
cm91cF94YXR0ci5jIGIvdGVzdGNhc2VzL2tlcm5lbC9jb250cm9sbGVycy9jZ3JvdXBfeGF0dHIv
Y2dyb3VwX3hhdHRyLmMKaW5kZXggNDkyZGRjNy4uYTdjMTMxZiAxMDA2NDQKLS0tIGEvdGVzdGNh
c2VzL2tlcm5lbC9jb250cm9sbGVycy9jZ3JvdXBfeGF0dHIvY2dyb3VwX3hhdHRyLmMKKysrIGIv
dGVzdGNhc2VzL2tlcm5lbC9jb250cm9sbGVycy9jZ3JvdXBfeGF0dHIvY2dyb3VwX3hhdHRyLmMK
QEAgLTY0LDkgKzY0LDkgQEAgc3RydWN0IHRzdF9rZXkgewogCiAvKiBvbmx5IHNlY3VyaXR5Liog
JiB0cnVzdGVkLiogYXJlIHZhbGlkIGtleSBuYW1lcyAqLwogc3RhdGljIHN0cnVjdCB0c3Rfa2V5
IHRrZXlzW10gPSB7Ci0JeyAubmFtZSA9ICJzZWN1cml0eS4iLAkJLmdvb2QgPSAxLAl9LAorCXsg
Lm5hbWUgPSAic2VjdXJpdHkuIiwJCS5nb29kID0gMCwJfSwgIC8qIHNlZSBzZXR1cCgpICovCiAJ
eyAubmFtZSA9ICJ0cnVzdGVkLnRlc3QiLAkuZ29vZCA9IDEsCX0sCi0JeyAubmFtZSA9ICJ0cnVz
dGVkLiIsCQkuZ29vZCA9IDEsCX0sCisJeyAubmFtZSA9ICJ0cnVzdGVkLiIsCQkuZ29vZCA9IDAs
CX0sICAvKiBzZWUgc2V0dXAoKSAqLwogCXsgLm5hbWUgPSAidXNlci4iLAkJLmdvb2QgPSAwLAl9
LAogCXsgLm5hbWUgPSAic3lzdGVtLiIsCQkuZ29vZCA9IDAsCX0sCiB9OwpAQCAtMTQxLDYgKzE0
MSw4IEBAIHN0YXRpYyB2b2lkIGhlbHAodm9pZCkKIAogdm9pZCBzZXR1cChpbnQgYXJnYywgY2hh
ciAqYXJndltdKQogeworCXVuc2lnbmVkIGludCBpOworCiAJdHN0X3BhcnNlX29wdHMoYXJnYywg
YXJndiwgb3B0aW9ucywgaGVscCk7CiAKIAl0c3RfcmVxdWlyZV9yb290KCk7CkBAIC0xNTMsMTcg
KzE1NSwxMSBAQCB2b2lkIHNldHVwKGludCBhcmdjLCBjaGFyICphcmd2W10pCiAJCQkiVGVzdCBt
dXN0IGJlIHJ1biB3aXRoIGtlcm5lbCAzLjcgb3IgbmV3ZXIiKTsKIAl9CiAKLQlpZiAodHN0X2t2
ZXJjbXAoMywgMTUsIDApID49IDApIHsKLQkJLyogSW4ga2VybmVsIHYzLjE1IGNncm91cCB3YXMg
Y29udmVydGVkIHRvIGtlcm5mcwotCQkgKiB0aGF0IGRvZXNuJ3QgcHJvdmlkZSBzaW1wbGUgc2Vj
dXJpdHkgbmFtZXNwYWNlIGhhbmRsZXJzLgotCQkgKiBTZXR0aW5nIGp1c3QgJ3NlY3VyaXR5Licg
c2hvdWxkIHJldHVybiBFT1BOT1RTVVBQLgotCQkgKi8KLQkJdW5zaWduZWQgaW50IGk7Ci0JCWZv
ciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHRrZXlzKTsgKytpKSB7Ci0JCQlpZiAoIXN0cmNtcCh0
a2V5c1tpXS5uYW1lLCAic2VjdXJpdHkuIikpIHsKLQkJCQl0a2V5c1tpXS5nb29kID0gMDsKLQkJ
CQlicmVhazsKLQkJCX0KKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRSh0a2V5cyk7ICsraSkg
eworCQlpZiAoIXN0cmNtcCh0a2V5c1tpXS5uYW1lLCAic2VjdXJpdHkuIikpIHsKKwkJCXRrZXlz
W2ldLmdvb2QgPSB0c3Rfa3ZlcmNtcCgzLCAxNSwgMCkgPCAwOworCQl9IGVsc2UgaWYgKCFzdHJj
bXAodGtleXNbaV0ubmFtZSwgInRydXN0ZWQuIikpIHsKKwkJCXRrZXlzW2ldLmdvb2QgPSB0c3Rf
a3ZlcmNtcCg0LCA1LCAwKSA8IDA7CiAJCX0KIAl9CiAK
--94eb2c0485daf08b8105341446f7--
