MIME-Version: 1.0
Date: Tue, 29 Jan 2019 13:44:59 +0100
References: <CAOQ4uxhj4X03c43fy2WuOgG7q3ztC=wdw5pBod778d-B5dKmAA@mail.gmail.com>
	<CAOQ4uxj=c9F5NNBNm+ek3NOPPpj4bh86V6WQyN1N88e76QZWdg@mail.gmail.com>
	<CAJfpegusiOjWo-dR3eM0yBWeSE0QTaDwM0-kAoo=fSyuVJgZFQ@mail.gmail.com>
	<CAOQ4uxhgK0tanvqZn9a9=q80Sc4L3GO1Nou7amU51Q66uUXhOg@mail.gmail.com>
	<CAJfpegv48DRJ4Cd40gFX+ssmNmQTtej+8SNAtzCoPtjgBnws9Q@mail.gmail.com>
	<CAOQ4uxjStG-KYaTHcaheZYcPDq7it2c_82RePFnmSzfFND_--A@mail.gmail.com>
	<CAJfpeguv8gebY_7dhOtb7LrhYPW6x3=upqakMTa3f4VuRkEgpA@mail.gmail.com>
	<CAJfpegsVy=tep29H=zWhRYCVHBd4mYO=e_181DinZUQOaetoJA@mail.gmail.com>
	<CAOQ4uxha2VNZ-Da-w6U5yxrqA3PkixXPevk9_5NvMzg4-KkWSg@mail.gmail.com>
	<CAOQ4uxiKss89-J+Wv1q9QtvMMsypKFy-ktBom_Ss9kPr7_te6w@mail.gmail.com>
	<20190128192207.GA10240@redhat.com>
	<CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
	<CAJfpegth1vkgo67MbqfcmjXZLjxAW9mjoNaxLUW78iRtEqcaLQ@mail.gmail.com>
	<CAJfpegtay6O7S92eV0H=kV58E28z3Bmc4M0r6jYtoQkxSCjgUQ@mail.gmail.com>
	<CAOQ4uxhFSa-DAs4_7YQ0DB6yjE7Qr76Dm9TNs17L1wKAnEMy+g@mail.gmail.com>
	<CAJfpegsjfxTV44SbcKzV7T2U+BbOqgwLHgr7-jctqgUXxYzM_A@mail.gmail.com>
	<CAOQ4uxhnFeL-pHY6AM8UWD9RDu-RN=xuM-RCoq5Mw_htUvHBFA@mail.gmail.com>
	<CAJfpegv_GkeGapuTGDMtF79GL1iZK5+HA_p1+OQpqXhZsrS4JQ@mail.gmail.com>
	<CAOQ4uxgcCdpYoAbo5mp5AvdW9B-ENAJXgQbOtjsQoHKjr_b8iA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgcCdpYoAbo5mp5AvdW9B-ENAJXgQbOtjsQoHKjr_b8iA@mail.gmail.com>
Message-ID: <CAJfpegu_w+xfONCDMoqtLs=r6J8DUBjTU_W=pchRK0URum8c+Q@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: multipart/mixed; boundary="00000000000056aafe058098291b"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

--00000000000056aafe058098291b
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 29, 2019 at 10:13 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jan 29, 2019 at 10:58 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, Jan 29, 2019 at 9:54 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Jan 29, 2019 at 9:17 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Mon, Jan 28, 2019 at 11:14 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jan 28, 2019 at 11:22 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > >
> > > > > > On Mon, Jan 28, 2019 at 10:17 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > >
> > > > > > > Trying to put some code together...
> > > > > >
> > > > > > Very rudimentary patch attached.  It doens't do direct IO yet, but
> > > > > > demonstrates what I meant about achoring the upper file in the inode.
> > > > > >
> > > > >
> > > > > Code looks good, but blows up on xfstests, so I'll wait for a baked patch
> > > > > before testing.
> > > > >
> > > > > > Also found the trick to actually make writeback work:
> > > > > > super_setup_bdi() call in fill_super...
> > > > > >
> > > > >
> > > > > Cool, but when adding only setup_bdi() this to my code, I still don't see any
> > > > > writeback. No writeback observed with your patch as well.
> > > >
> > > > I did observe writeback, but haven't done much testing.  Will
> > > > hopefully get this into a better shape today.
> > > >
> > >
> > > OK, I see the writebacks. Didn't see them with test:
> > >
> > > # ./run --ov --samefs --recycle rename-new-pop-dir
> >
> > Which branch is this?  Master doesn't have --recycle.
> >
>
> Sorry, this flag is from branch ovl_snapshot, but exact same
> functionality on master with syntax:
>
> ./run --ov=0 --samefs rename-new-pop-dir

Fix attached.

Need to work on other stuff, so xfstests left for tomorrow (or if you
have time, feel free).

Thanks,
Miklos

--00000000000056aafe058098291b
Content-Type: text/x-patch; charset="US-ASCII"; name="d.patch"
Content-Disposition: attachment; filename="d.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jrhr3br00
Content-ID: <f_jrhr3br00>

LS0tIGEvZnMvb3ZlcmxheWZzL3N1cGVyLmMKKysrIGIvZnMvb3ZlcmxheWZzL3N1cGVyLmMKQEAg
LTM3OCw3ICszODIsNiBAQCBzdGF0aWMgaW50IG92bF9yZW1vdW50KHN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IsIGludCAqZmxhZ3MsIGNoYXIgKmRhdGEpCiBzdGF0aWMgY29uc3Qgc3RydWN0IHN1cGVy
X29wZXJhdGlvbnMgb3ZsX3N1cGVyX29wZXJhdGlvbnMgPSB7CiAJLmFsbG9jX2lub2RlCT0gb3Zs
X2FsbG9jX2lub2RlLAogCS5kZXN0cm95X2lub2RlCT0gb3ZsX2Rlc3Ryb3lfaW5vZGUsCi0JLmRy
b3BfaW5vZGUJPSBnZW5lcmljX2RlbGV0ZV9pbm9kZSwKIAkucHV0X3N1cGVyCT0gb3ZsX3B1dF9z
dXBlciwKIAkuc3luY19mcwk9IG92bF9zeW5jX2ZzLAogCS5zdGF0ZnMJCT0gb3ZsX3N0YXRmcywK
--00000000000056aafe058098291b--
