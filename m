MIME-Version: 1.0
Date: Wed, 6 Feb 2019 16:36:15 +0100
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
	<CAJfpegu_w+xfONCDMoqtLs=r6J8DUBjTU_W=pchRK0URum8c+Q@mail.gmail.com>
	<CAOQ4uxj08PhC2+h1LL+iKrAGnKXvT-oYNkFOjUqHrnBf84DswA@mail.gmail.com>
	<CAJfpegv1J4TvmhUvogGUP5pOZNT+gnRr1ygjWnyt7M56dirP0A@mail.gmail.com>
	<CAOQ4uxjh4yieJaacbP+5JbRY+=LV4oJU+1JCGV4S+eLE7FEcAw@mail.gmail.com>
	<CAJfpegu98HhOpajUOEm3OXXXTR4kePK-X3_hZurfDd=u0eHC0g@mail.gmail.com>
	<CAOQ4uxg4vNVKbNQMVKoT9_+95ft42TVCMqRYAED=AAvUHZQ1Hg@mail.gmail.com>
	<CAJfpegvuHcWX6BW+4rkD9tw5Cuf4OQ7QYZd-7yu9EA8r7o=_vA@mail.gmail.com>
	<CAOQ4uxgft67=tysHZ+zUYk9Pcd7m=Sco0UnXg0J+mX72cJVonA@mail.gmail.com>
	<CAOQ4uxhfc3_npKQYOJDG9TVv-NKEYH-T-zgZWS8Vjixr59r14Q@mail.gmail.com>
	<CAOQ4uxiru5XHcrizm66DOeVC49k-j=GvWLzQEnoQg793D2B0GA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiru5XHcrizm66DOeVC49k-j=GvWLzQEnoQg793D2B0GA@mail.gmail.com>
Message-ID: <CAJfpegt_nxPbSxXUSOpYoJxg541cGSMtVrPGFCriQ-QYOaBvhA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Feb 5, 2019 at 2:03 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Feb 5, 2019 at 9:42 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > > >
> > > > > EIO on clone/dedupe:
> > > > > generic/303 generic/304
> > > > >
> > > > > Wrong st_blocks/fiemap:
> > > > > generic/353 generic/392 generic/422
> > > >
> > > > Hmm, generic/353 passes for me...
> > > >
> > >
> > > So for me:
> > > running generic/353 after generic/303 it fails
> > > and running it again it passes.
> > >
> >
> > The failed line in 303,304 is:
> >
> > xfs_io  -c "pread -v -q 9223372036854775806 1" /mnt/test/foo
> > pread: Input/output error
> >
> > And failure seems not related to clone/dedupe at all.
> > Easily reproduced on any file (i.e. touch /mnt/test/foo),
> > so its probably just an arithmetic len/offset bug.
> >
>
> Yes, pos+PAGE_SIZE < 0 (overrun).
>
> Pushed a fix to truncate upper read to i_size.
> It's more general although maybe non needed
> for the common case, where pos+PAGE_SIZE > 0.

Yes, we can allow tail page DIO reads, with the exception of the page
at LLONG_MAX.

> Interesting side effect. Now generic/353 fails always (or more often).
> It appears as though a 64K reflinked file is broken to 2 extents
> while the test expects it to have a single extent.
>
> I am not sure why the test makes this expectation, maybe because
> it was very probable for buffered write and made it easier to write the test.
> The fact is that if we issue buffered write to upper file, the test passes
> as expected, but when using direct IO to upper file the test fails.
>
> I guess that direct IO results in different block reservation than
> buffered IO in xfs. So it appears that converting buffered IO to direct IO
> on upper file may have some implications.
>
> Its quite likely that this specific issue will go away with ->writepages(),
> so let's wait and see if that is an issue.
> The question is whether we want to mess with hidden filesystem
> implementation details or we would want to provide a knob for the
> user to choose between direct and buffered IO to upper.

I don't think anyone outside that testcase would care.  I'd just add a
knob (and possibly fix the testcase...)

> Double page caches can be mitigated by invalidating upper page
> cache after writeback.  In any case, we need to invalidate upper
> page cache after copy up and in other occasions (like when upper
> fs has no direct IO support), so the code for using buffered IO to
> upper and cleaning upper page cache needs to be implemented anyway.

I think the only case where upper doesn't have direct IO support is
tmpfs.  And in that case we should just turn off overlay pagecache by
default, since there's no upside to having a cache at the overlay
level.  Same probably holds for DAX mounted filesystems as well.

Thanks,
Miklos
