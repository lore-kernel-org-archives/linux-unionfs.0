From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Date: Mon, 22 Oct 2018 23:23:56 +0200
Message-ID: <CACna6rzbzw-XkUVVFzNvW7fxK3OGutriKKuqA7bx4a+8mvWXUg@mail.gmail.com>
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <CACna6rx_jSTEEt6TAzQcBpAHZA_CJGhkjJhWWJKG3cQmr9c9ug@mail.gmail.com>
 <3000620.g91H2S8sUk@blindfold>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000a23c100578d7dfc4"
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <3000620.g91H2S8sUk@blindfold>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Amir Goldstein <amir73il@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, linux-fsdevel@vger.kernel.org, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-Id: linux-unionfs@vger.kernel.org

--000000000000a23c100578d7dfc4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Oct 2018 at 10:26, Richard Weinberger <richard@nod.at> wrote:
> Am Montag, 22. Oktober 2018, 09:14:08 CEST schrieb Rafa=C5=82 Mi=C5=82eck=
i:
> > On Fri, 19 Oct 2018 at 14:31, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com=
> wrote:
> > > Since OpenWrt switch from kernel 4.9 to 4.14 users started randomly
> > > reporting file system corruptions. OpenWrt uses overlay(fs) with
> > > squashfs as lowerdir and ubifs as upperdir. Russell managed to isolat=
e
> > > & describe test case for reproducing corruption when doing a power cu=
t
> > > after first boot.
> > >
> > > (...)
> > >
> > > Can I ask you to check if there is something possibly wrong with the
> > > above ovl commit? Or does it expose some problem with the ubifs? Or
> > > maybe the whole UBI?
> > >
> > > FWIW testing above commit (and one before it) always results in singl=
e
> > > error in the kernel log:
> > > [   14.250184] UBIFS error (ubi0:1 pid 637): ubifs_add_orphan: orphan=
ed twice
> > >
> > > That UBIFS error doesn't occur with 4.12.14. Unfortunately it's
> > > impossible to cleanly revert 3a1e819b4e80 from the top of 4.12.14.
> >
> > Let me provide a summary of all relevant commits & tests:
> >
> > By "Corruption" I mean file system corruption after power cut
>
> Well, is the filesystem not consistent anymore?
> From what Russel explained to me, I thought the main problem is that no w=
rite back happens.
> IOW the inode is present, has correct length, but no content is there (al=
l zeros).

I probably misused "corruption" word. What I meant by "corruption" was
file having all "00"es instead of expected data.


> Just like the typical case where userspace does not fsync.
> But in your case sooner or later write back should have happened because =
the writeback timer
> fires at some point.

As you probably noticed I wrote tmptest.c - could you test it, please?
See if you can reproduce the problem? Please call it with 3 arguments:
1) Path on ubifs mount point
2) Some xattr name
3) Some xattr value

Please note I wait 5 seconds (this matches
vm.dirty_writeback_centisecs being 500) before doing a power cut. That
lets ubifs write to flash. For some reason files that got fsetxattr
called for them still are all "00"es after a power cut.

I did some extra testing after enabling ubifs debugging for io.c,
file.c and journal.c. Debugging output looks like expected. I can
clearly see wbuf_timer_callback_nolock() being called.
I attached my debugging summary as ubifs-dbg.html please take a look
at it in case I missed something.

--=20
Rafa=C5=82

--000000000000a23c100578d7dfc4
Content-Type: text/html; charset="US-ASCII"; name="ubifs-dbg.html"
Content-Disposition: attachment; filename="ubifs-dbg.html"
Content-Transfer-Encoding: base64
Content-ID: <f_jnkt62jw0>
X-Attachment-Id: f_jnkt62jw0

PCFET0NUWVBFIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KCTxoZWFkPgoJCTxtZXRhIGNoYXJzZXQ9
InV0Zi04IiAvPgoJCTx0aXRsZT51YmlmcyBhbmQgeGF0dHIgdGVzdDwvdGl0bGU+CgkJPHN0eWxl
PgoJCXRhYmxlIHsgYm9yZGVyLWNvbGxhcHNlOiBjb2xsYXBzZTsgfQoJCXRkIHsgcGFkZGluZzog
NHB4IDhweDsgYm9yZGVyOiAxcHggc29saWQgYmxhY2s7IHZlcnRpY2FsLWFsaWduOiB0b3A7IH0K
CQl0ZFtjb2xzcGFuXSB7IHRleHQtYWxpZ246IGNlbnRlcjsgfQoJCXByZSB7IG1hcmdpbjogMDsg
cGFkZGluZzogMDsgfQoJCTwvc3R5bGU+Cgk8L2hlYWQ+Cgk8Ym9keT4KCQk8dGFibGU+CgkJCTx0
Ym9keT4KCQkJCTx0cj4KCQkJCQk8dGQgY29sc3Bhbj0iMiI+PHByZT5lY2hvICJmaWxlIGZzL3Vi
aWZzL2lvLmMgK2ZwIiA+IC9zeXMva2VybmVsL2RlYnVnL2R5bmFtaWNfZGVidWcvY29udHJvbApl
Y2hvICJmaWxlIGZzL3ViaWZzL2ZpbGUuYyArZnAiID4gL3N5cy9rZXJuZWwvZGVidWcvZHluYW1p
Y19kZWJ1Zy9jb250cm9sCmVjaG8gImZpbGUgZnMvdWJpZnMvam91cm5hbC5jICtmcCIgPiAvc3lz
L2tlcm5lbC9kZWJ1Zy9keW5hbWljX2RlYnVnL2NvbnRyb2w8L3ByZT4KCQkJCTwvdHI+CgkJCQk8
dHI+CgkJCQkJPHRkPjxwcmU+cm9vdEBPcGVuV3J0Oi8jIHRtcHRlc3QgL292ZXJsYXkvdXBwZXIv
Zm9vLnR4dApbICAyMDcuOTE1OTU1XSB3cml0ZV9oZWFkOiBVQklGUyBEQkcgam5sIChwaWQgMTI0
Mik6IGpoZWFkIDEgKGJhc2UpLCBMRUIgMTc6ODE5MiwgbGVuIDM4NApbICAyMDcuOTMxODMxXSB1
Ymlmc193YnVmX3dyaXRlX25vbG9jazogVUJJRlMgREJHIGlvIChwaWQgMTI0Mik6IDM4NCBieXRl
cyAoZGlyZW50cnkgbm9kZSkgdG8gamhlYWQgMSAoYmFzZSkgd2J1ZiBhdCBMRUIgMTc6ODE5Mgpb
ICAyMDcuOTU0NDU3XSBuZXdfd2J1Zl90aW1lcl9ub2xvY2s6IFVCSUZTIERCRyBpbyAocGlkIDEy
NDIpOiBzZXQgdGltZXIgZm9yIGpoZWFkIDEgKGJhc2UpLCA1MDAwLTU1MDAgbWlsbGlzZWNzClsg
IDIwNy45NzQ0NzZdIGRvX3JlYWRwYWdlOiBVQklGUyBEQkcgZ2VuIChwaWQgMTI0Mik6IGlubyAx
NTcsIHBnIDAsIGlfc2l6ZSAwLCBmbGFncyAweDEKWyAgMjA3Ljk5MDE1Ml0gdWJpZnNfd3JpdGVf
ZW5kOiBVQklGUyBEQkcgZ2VuIChwaWQgMTI0Mik6IGlubyAxNTcsIHBvcyAwLCBwZyAwLCBsZW4g
NSwgY29waWVkIDUsIGlfc2l6ZSAwClsgIDIwOC4wMDg3NzddIHViaWZzX2ZzeW5jOiBVQklGUyBE
QkcgZ2VuIChwaWQgMTI0Mik6IHN5bmNpbmcgaW5vZGUgMTU3ClsgIDIwOC4wMjE0OThdIHViaWZz
X3dyaXRlcGFnZTogVUJJRlMgREJHIGdlbiAocGlkIDEyNDIpOiBpbm8gMTU3LCBwZyAwLCBwZyBm
bGFncyAweDE2MDkKWyAgMjA4LjAzNzE1N10gdWJpZnNfam5sX3dyaXRlX2RhdGE6IFVCSUZTIERC
RyBqbmwgKHBpZCAxMjQyKTogaW5vIDE1NywgYmxrIDAsIGxlbiA1LCBrZXkgKDE1NywgZGF0YSwg
MCkKWyAgMjA4LjA1NTU1M10gd3JpdGVfbm9kZTogVUJJRlMgREJHIGpubCAocGlkIDEyNDIpOiBq
aGVhZCAyIChkYXRhKSwgTEVCIDE2OjQzMDA4LCBsZW4gNTMKWyAgMjA4LjA3MTM1OV0gdWJpZnNf
d2J1Zl93cml0ZV9ub2xvY2s6IFVCSUZTIERCRyBpbyAocGlkIDEyNDIpOiA1MyBieXRlcyAoZGF0
YSBub2RlKSB0byBqaGVhZCAyIChkYXRhKSB3YnVmIGF0IExFQiAxNjo0MzAwOApbICAyMDguMDkz
MjI4XSBuZXdfd2J1Zl90aW1lcl9ub2xvY2s6IFVCSUZTIERCRyBpbyAocGlkIDEyNDIpOiBzZXQg
dGltZXIgZm9yIGpoZWFkIDIgKGRhdGEpLCA1MDAwLTU1MDAgbWlsbGlzZWNzClsgIDIwOC4xMTMx
MTZdIHViaWZzX3didWZfc3luY19ub2xvY2s6IFVCSUZTIERCRyBpbyAocGlkIDEyNDIpOiBMRUIg
MTc6ODE5MiwgMzg0IGJ5dGVzLCBqaGVhZCAxIChiYXNlKQpbICAyMDguMTMyMTA4XSB1Ymlmc193
YnVmX3N5bmNfbm9sb2NrOiBVQklGUyBEQkcgaW8gKHBpZCAxMjQyKTogTEVCIDE2OjQzMDA4LCA1
NiBieXRlcywgamhlYWQgMiAoZGF0YSk8L3ByZT48L3RkPgoJCQkJCTx0ZD48cHJlPnJvb3RAT3Bl
bldydDovIyB0bXB0ZXN0IC9vdmVybGF5L3VwcGVyL2Jhci50eHQgdXNlci5iYXogcXV4ClsgICA3
My41ODI3MzNdIHdyaXRlX2hlYWQ6IFVCSUZTIERCRyBqbmwgKHBpZCAxMDk0KTogamhlYWQgMSAo
YmFzZSksIExFQiAxNzoxNDMzNiwgbGVuIDM4NApbICAgNzMuNTk4NzI3XSB1Ymlmc193YnVmX3dy
aXRlX25vbG9jazogVUJJRlMgREJHIGlvIChwaWQgMTA5NCk6IDM4NCBieXRlcyAoZGlyZW50cnkg
bm9kZSkgdG8gamhlYWQgMSAoYmFzZSkgd2J1ZiBhdCBMRUIgMTc6MTQzMzYKWyAgIDczLjYyMTQ1
Ml0gbmV3X3didWZfdGltZXJfbm9sb2NrOiBVQklGUyBEQkcgaW8gKHBpZCAxMDk0KTogc2V0IHRp
bWVyIGZvciBqaGVhZCAxIChiYXNlKSwgNTAwMC01NTAwIG1pbGxpc2VjcwpbICAgNzMuNjQxMzI0
XSBkb19yZWFkcGFnZTogVUJJRlMgREJHIGdlbiAocGlkIDEwOTQpOiBpbm8gMTYwLCBwZyAwLCBp
X3NpemUgMCwgZmxhZ3MgMHgxClsgICA3My42NTY5NDddIHViaWZzX3dyaXRlX2VuZDogVUJJRlMg
REJHIGdlbiAocGlkIDEwOTQpOiBpbm8gMTYwLCBwb3MgMCwgcGcgMCwgbGVuIDUsIGNvcGllZCA1
LCBpX3NpemUgMApbICAgNzMuNjc1NTExXSB1Ymlmc19mc3luYzogVUJJRlMgREJHIGdlbiAocGlk
IDEwOTQpOiBzeW5jaW5nIGlub2RlIDE2MApbICAgNzMuNjg4MTkxXSB1Ymlmc193cml0ZXBhZ2U6
IFVCSUZTIERCRyBnZW4gKHBpZCAxMDk0KTogaW5vIDE2MCwgcGcgMCwgcGcgZmxhZ3MgMHgxNjA5
ClsgICA3My43MDM4MDldIHViaWZzX2pubF93cml0ZV9kYXRhOiBVQklGUyBEQkcgam5sIChwaWQg
MTA5NCk6IGlubyAxNjAsIGJsayAwLCBsZW4gNSwga2V5ICgxNjAsIGRhdGEsIDApClsgICA3My43
MjIxODVdIHdyaXRlX25vZGU6IFVCSUZTIERCRyBqbmwgKHBpZCAxMDk0KTogamhlYWQgMiAoZGF0
YSksIExFQiAxNjo0NTA1NiwgbGVuIDUzClsgICA3My43Mzc5NjJdIHViaWZzX3didWZfd3JpdGVf
bm9sb2NrOiBVQklGUyBEQkcgaW8gKHBpZCAxMDk0KTogNTMgYnl0ZXMgKGRhdGEgbm9kZSkgdG8g
amhlYWQgMiAoZGF0YSkgd2J1ZiBhdCBMRUIgMTY6NDUwNTYKWyAgIDczLjc1OTc5MV0gbmV3X3di
dWZfdGltZXJfbm9sb2NrOiBVQklGUyBEQkcgaW8gKHBpZCAxMDk0KTogc2V0IHRpbWVyIGZvciBq
aGVhZCAyIChkYXRhKSwgNTAwMC01NTAwIG1pbGxpc2VjcwpbICAgNzMuNzc5NjAwXSB1Ymlmc193
YnVmX3N5bmNfbm9sb2NrOiBVQklGUyBEQkcgaW8gKHBpZCAxMDk0KTogTEVCIDE3OjE0MzM2LCAz
ODQgYnl0ZXMsIGpoZWFkIDEgKGJhc2UpClsgICA3My43OTg3NzRdIHViaWZzX3didWZfc3luY19u
b2xvY2s6IFVCSUZTIERCRyBpbyAocGlkIDEwOTQpOiBMRUIgMTY6NDUwNTYsIDU2IGJ5dGVzLCBq
aGVhZCAyIChkYXRhKTwvcHJlPjwvdGQ+CgkJCQk8L3RyPgoJCQkJPHRyPgoJCQkJCTx0ZD48L3Rk
PgoJCQkJCTx0ZD48cHJlPlsgICA3My44MTc4MTddIHdyaXRlX2hlYWQ6IFVCSUZTIERCRyBqbmwg
KHBpZCAxMDk0KTogamhlYWQgMSAoYmFzZSksIExFQiAxNzoxNjM4NCwgbGVuIDQwMApbICAgNzMu
ODMzNzU2XSB1Ymlmc193YnVmX3dyaXRlX25vbG9jazogVUJJRlMgREJHIGlvIChwaWQgMTA5NCk6
IDQwMCBieXRlcyAoeGVudHJ5IG5vZGUpIHRvIGpoZWFkIDEgKGJhc2UpIHdidWYgYXQgTEVCIDE3
OjE2Mzg0ClsgICA3My44NTYxMDldIG5ld193YnVmX3RpbWVyX25vbG9jazogVUJJRlMgREJHIGlv
IChwaWQgMTA5NCk6IHNldCB0aW1lciBmb3IgamhlYWQgMSAoYmFzZSksIDUwMDAtNTUwMCBtaWxs
aXNlY3MKWyAgIDczLjg3NTg2M10gdWJpZnNfd2J1Zl9zeW5jX25vbG9jazogVUJJRlMgREJHIGlv
IChwaWQgMTA5NCk6IExFQiAxNzoxNjM4NCwgNDAwIGJ5dGVzLCBqaGVhZCAxIChiYXNlKQpXcm90
ZSB4YXR0ciAidXNlci5iYXoiIHZhbHVlICJxdXgiPC9wcmU+PC90ZD4KCQkJCTwvdHI+CgkJCQk8
dHI+CgkJCQkJPHRkPjxwcmU+WyAgMjA4LjE1MTI5MV0gd3JpdGVfaGVhZDogVUJJRlMgREJHIGpu
bCAocGlkIDEyNDIpOiBqaGVhZCAxIChiYXNlKSwgTEVCIDE3OjEwMjQwLCBsZW4gMzg0ClsgIDIw
OC4xNjcyNzldIHViaWZzX3didWZfd3JpdGVfbm9sb2NrOiBVQklGUyBEQkcgaW8gKHBpZCAxMjQy
KTogMzg0IGJ5dGVzIChkaXJlbnRyeSBub2RlKSB0byBqaGVhZCAxIChiYXNlKSB3YnVmIGF0IExF
QiAxNzoxMDI0MApbICAyMDguMTg5OTkzXSBuZXdfd2J1Zl90aW1lcl9ub2xvY2s6IFVCSUZTIERC
RyBpbyAocGlkIDEyNDIpOiBzZXQgdGltZXIgZm9yIGpoZWFkIDEgKGJhc2UpLCA1MDAwLTU1MDAg
bWlsbGlzZWNzClN1Y2Nlc3MhPC9wcmU+PC90ZD4KCQkJCQk8dGQ+PHByZT5bICAgNzMuODk1MzY4
XSB3cml0ZV9oZWFkOiBVQklGUyBEQkcgam5sIChwaWQgMTA5NCk6IGpoZWFkIDEgKGJhc2UpLCBM
RUIgMTc6MTg0MzIsIGxlbiAzODQKWyAgIDczLjkxMzg3Ml0gdWJpZnNfd2J1Zl93cml0ZV9ub2xv
Y2s6IFVCSUZTIERCRyBpbyAocGlkIDEwOTQpOiAzODQgYnl0ZXMgKGRpcmVudHJ5IG5vZGUpIHRv
IGpoZWFkIDEgKGJhc2UpIHdidWYgYXQgTEVCIDE3OjE4NDMyClsgICA3My45MzkyODJdIG5ld193
YnVmX3RpbWVyX25vbG9jazogVUJJRlMgREJHIGlvIChwaWQgMTA5NCk6IHNldCB0aW1lciBmb3Ig
amhlYWQgMSAoYmFzZSksIDUwMDAtNTUwMCBtaWxsaXNlY3MKU3VjY2VzcyE8L3ByZT48L3RkPgoJ
CQkJPC90cj4KCQkJCTx0cj4KCQkJCQk8dGQ+PHByZT5bICAyMTMuMzA2NDc5XSB3YnVmX3RpbWVy
X2NhbGxiYWNrX25vbG9jazogVUJJRlMgREJHIGlvIChwaWQgMCk6IGpoZWFkIDEgKGJhc2UpClsg
IDIxMy4zMjA1NTBdIHViaWZzX2JnX3didWZzX3N5bmM6IFVCSUZTIERCRyBpbyAocGlkIDM4OCk6
IHN5bmNocm9uaXplClsgIDIxMy4zMzM0NjddIHViaWZzX3didWZfc3luY19ub2xvY2s6IFVCSUZT
IERCRyBpbyAocGlkIDM4OCk6IExFQiAxNzoxMDI0MCwgMzg0IGJ5dGVzLCBqaGVhZCAxIChiYXNl
KTwvcHJlPjwvdGQ+CgkJCQkJPHRkPjxwcmU+WyAgIDc5LjMxNzQ0MF0gd2J1Zl90aW1lcl9jYWxs
YmFja19ub2xvY2s6IFVCSUZTIERCRyBpbyAocGlkIDApOiBqaGVhZCAxIChiYXNlKQpbICAgNzku
MzMxNTA2XSB1Ymlmc19iZ193YnVmc19zeW5jOiBVQklGUyBEQkcgaW8gKHBpZCAzODcpOiBzeW5j
aHJvbml6ZQpbICAgNzkuMzQ0MTkwXSB1Ymlmc193YnVmX3N5bmNfbm9sb2NrOiBVQklGUyBEQkcg
aW8gKHBpZCAzODcpOiBMRUIgMTc6MTg0MzIsIDM4NCBieXRlcywgamhlYWQgMSAoYmFzZSk8L3By
ZT48L3RkPgoJCQkJPC90cj4KCQkJCTx0cj4KCQkJCQk8dGQgY29sc3Bhbj0iMiI+UG93ZXIgY3V0
PC90ZD4KCQkJCTwvdHI+CgkJCQk8dHI+CgkJCQkJPHRkPjxwcmU+cm9vdEBPcGVuV3J0On4jIGhl
eGR1bXAgLXYgLUMgL292ZXJsYXkvdXBwZXIvZm9vLnR4dCAKMDAwMDAwMDAgIDY2IDZmIDZmIDBh
IDAwICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfGZvby4ufDwvcHJlPjwvdGQ+
CgkJCQkJPHRkPjxwcmU+cm9vdEBPcGVuV3J0On4jIGhleGR1bXAgLXYgLUMgL292ZXJsYXkvdXBw
ZXIvYmFyLnR4dCAKMDAwMDAwMDAgIDAwIDAwIDAwIDAwIDAwICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfC4uLi4ufDwvcHJlPjwvdGQ+CgkJCQk8L3RyPgoJCQk8L3Rib2R5PgoJ
CTwvdGFibGU+Cgk8L2JvZHk+CjwvaHRtbD4K
--000000000000a23c100578d7dfc4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

--000000000000a23c100578d7dfc4--
