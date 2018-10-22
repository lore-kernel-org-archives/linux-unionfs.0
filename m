From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Date: Mon, 22 Oct 2018 17:34:44 +0200
Message-ID: <CACna6rzvzc-_X3VDeA-nwtTW7KHaQGtbvzjVNoOFEQuHKi3PJg@mail.gmail.com>
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <CACna6rx_jSTEEt6TAzQcBpAHZA_CJGhkjJhWWJKG3cQmr9c9ug@mail.gmail.com>
 <3000620.g91H2S8sUk@blindfold>
 <CAOQ4uxii0rZv3SVXWNN7yug_WZ-TKLL3Wo-mti0y9K66Z+-EcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000c694880578d2fe72"
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <CAOQ4uxii0rZv3SVXWNN7yug_WZ-TKLL3Wo-mti0y9K66Z+-EcQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Richard Weinberger <richard@nod.at>, Miklos Szeredi <miklos@szeredi.hu>, Adrian Hunter <adrian.hunter@intel.com>, linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, linux-fsdevel@vger.kernel.org, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-Id: linux-unionfs@vger.kernel.org

--000000000000c694880578d2fe72
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Oct 2018 at 10:57, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Oct 22, 2018 at 11:26 AM Richard Weinberger <richard@nod.at> wrot=
e:
> >
> > Am Montag, 22. Oktober 2018, 09:14:08 CEST schrieb Rafa=C5=82 Mi=C5=82e=
cki:
> > > On Fri, 19 Oct 2018 at 14:31, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.c=
om> wrote:
> > > > Since OpenWrt switch from kernel 4.9 to 4.14 users started randomly
> > > > reporting file system corruptions. OpenWrt uses overlay(fs) with
> > > > squashfs as lowerdir and ubifs as upperdir. Russell managed to isol=
ate
> > > > & describe test case for reproducing corruption when doing a power =
cut
> > > > after first boot.
> > > >
> > > > (...)
> > > >
> > > > Can I ask you to check if there is something possibly wrong with th=
e
> > > > above ovl commit? Or does it expose some problem with the ubifs? Or
> > > > maybe the whole UBI?
> > > >
> > > > FWIW testing above commit (and one before it) always results in sin=
gle
> > > > error in the kernel log:
> > > > [   14.250184] UBIFS error (ubi0:1 pid 637): ubifs_add_orphan: orph=
aned twice
> > > >
> > > > That UBIFS error doesn't occur with 4.12.14. Unfortunately it's
> > > > impossible to cleanly revert 3a1e819b4e80 from the top of 4.12.14.
> > >
> > > Let me provide a summary of all relevant commits & tests:
> > >
> > > By "Corruption" I mean file system corruption after power cut
> >
> > Well, is the filesystem not consistent anymore?
> > From what Russel explained to me, I thought the main problem is that no=
 write back happens.
> > IOW the inode is present, has correct length, but no content is there (=
all zeros).
> >
> > Just like the typical case where userspace does not fsync.
> > But in your case sooner or later write back should have happened becaus=
e the writeback timer
> > fires at some point.
> >
>
> For the records overlayfs does:
> - open(O_TMPFILE)
> - setxattr() [with 3a1e819b4e80]
> - write to tmpfile
> - fsync tmpfile
> - link tmpfile
>
> I suggest that you try the same from user space on ubifs.

Are you 100% sure about it? I tried writing C app behaving as you
described above and I could not reproduce the problem.

Then I took a close look at ovl_copy_up_locked() and it seems above
info isn't accurate. It seems to me that setxattr() happens between
fsync and link. I modified my C app to follow that order (open, write,
fsync, setxattr, link) and I can reproduce the problem now!

Steps to reproduce the problem:
1) compile tmptest.c
2) tmptest /overlay/upper/foo.txt user.bar baz
3) wait 5 seconds (so ubifs writes to flash)
4) power cut
5) boot again and check content of /overlay/upper/foo.txt
6) in my case content appears to be 00 00 00 00

Is this correct for ovl to call vfs_setxattr() *after* calling vfs_fsync()?

--=20
Rafa=C5=82

--000000000000c694880578d2fe72
Content-Type: text/x-csrc; charset="US-ASCII"; name="tmptest.c"
Content-Disposition: attachment; filename="tmptest.c"
Content-Transfer-Encoding: base64
Content-ID: <f_jnkghgd90>
X-Attachment-Id: f_jnkghgd90

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8bGliZ2VuLmg+
CiNpbmNsdWRlIDxsaW51eC9saW1pdHMuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxz
dHJpbmcuaD4KI2luY2x1ZGUgPHN5cy94YXR0ci5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgpzdGF0
aWMgY29uc3QgY2hhciBmb29bXSA9ICJmb29cbiI7CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAq
KmFyZ3YpIHsKCWNoYXIgcGF0aFtQQVRIX01BWF07CgljaGFyICpkaXI7CglpbnQgZXJyOwoJaW50
IGZkOwoKCWlmIChhcmdjIDwgMikgewoJCWZwcmludGYoc3RkZXJyLCAiWW91IGhhdmUgdG8gcGFz
cyBmaWxlIGFzIGFyZ3VtZW50XG4iKTsKCQlyZXR1cm4gLUVOT0VOVDsKCX0KCglkaXIgPSBzdHJk
dXAoYXJndlsxXSk7CglpZiAoIWRpcikgewoJCXJldHVybiAtRU5PTUVNOwoJfQoJZGlyID0gZGly
bmFtZShkaXIpOwoJZmQgPSBvcGVuKGRpciwgT19UTVBGSUxFIHwgT19SRFdSKTsKCWlmIChmZCA8
IDApIHsKCQllcnIgPSAtZXJybm87CgkJZnByaW50ZihzdGRlcnIsICJGYWlsZWQgdG8gb3BlbiBP
X1RNUEZJTEU6ICVkXG4iLCBlcnIpOwoJCXJldHVybiBlcnI7Cgl9CgojaWYgMAoJaWYgKGFyZ2Mg
Pj0gNCkgewoJCWlmIChmc2V0eGF0dHIoZmQsIGFyZ3ZbMl0sIGFyZ3ZbM10sIHN0cmxlbihhcmd2
WzNdKSwgMCkgIT0gMCkgewoJCQllcnIgPSAtZXJybm87CgkJCWZwcmludGYoc3RkZXJyLCAiRmFp
bGVkIHRvIGZzZXR4YXR0cigpOiAlZFxuIiwgZXJyKTsKCQkJcmV0dXJuIGVycjsKCQl9CgkJcHJp
bnRmKCJXcm90ZSB4YXR0ciBcIiVzXCIgdmFsdWUgXCIlc1wiXG4iLCBhcmd2WzJdLCBhcmd2WzNd
KTsKCX0KI2VuZGlmCgoJaWYgKHdyaXRlKGZkLCBmb28sIHNpemVvZihmb28pKSAhPSBzaXplb2Yo
Zm9vKSkgewoJCWVyciA9IC1lcnJubzsKCQlmcHJpbnRmKHN0ZGVyciwgIkZhaWxlZCB0byB3cml0
ZSgpOiAlZFxuIiwgZXJyKTsKCQlyZXR1cm4gZXJyOwoJfQoKCWlmIChmc3luYyhmZCkgPCAwKSB7
CgkJZXJyID0gLWVycm5vOwoJCWZwcmludGYoc3RkZXJyLCAiRmFpbGVkIHRvIGZzeW5jKCk6ICVk
XG4iLCBlcnIpOwoJCXJldHVybiBlcnI7Cgl9CgojaWYgMQoJaWYgKGFyZ2MgPj0gNCkgewoJCWlm
IChmc2V0eGF0dHIoZmQsIGFyZ3ZbMl0sIGFyZ3ZbM10sIHN0cmxlbihhcmd2WzNdKSwgMCkgIT0g
MCkgewoJCQllcnIgPSAtZXJybm87CgkJCWZwcmludGYoc3RkZXJyLCAiRmFpbGVkIHRvIGZzZXR4
YXR0cigpOiAlZFxuIiwgZXJyKTsKCQkJcmV0dXJuIGVycjsKCQl9CgkJcHJpbnRmKCJXcm90ZSB4
YXR0ciBcIiVzXCIgdmFsdWUgXCIlc1wiXG4iLCBhcmd2WzJdLCBhcmd2WzNdKTsKCX0KI2VuZGlm
CgoJc25wcmludGYocGF0aCwgc2l6ZW9mKHBhdGgpLCAiL3Byb2Mvc2VsZi9mZC8lZCIsIGZkKTsK
CWlmIChsaW5rYXQoLTEsIHBhdGgsIEFUX0ZEQ1dELCBhcmd2WzFdLCBBVF9TWU1MSU5LX0ZPTExP
VykgIT0gMCkgewoJCWVyciA9IC1lcnJubzsKCQlmcHJpbnRmKHN0ZGVyciwgIkZhaWxlZCB0byBs
aW5rYXQoKTogJWRcbiIsIGVycik7CgkJcmV0dXJuIGVycjsKCX0KCglwcmludGYoIlN1Y2Nlc3Mh
XG4iKTsKCglyZXR1cm4gMDsKfQo=
--000000000000c694880578d2fe72
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

--000000000000c694880578d2fe72--
