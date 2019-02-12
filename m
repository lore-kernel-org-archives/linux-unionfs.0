MIME-Version: 1.0
Date: Tue, 12 Feb 2019 09:11:00 +0100
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
	<CAJfpegt_nxPbSxXUSOpYoJxg541cGSMtVrPGFCriQ-QYOaBvhA@mail.gmail.com>
	<CAOQ4uxh+b+ur3oCWxMkrueJqA-gGo3A=YRrfeUVaQu4obGPKpw@mail.gmail.com>
In-Reply-To: <CAOQ4uxh+b+ur3oCWxMkrueJqA-gGo3A=YRrfeUVaQu4obGPKpw@mail.gmail.com>
Message-ID: <CAJfpegsyA4SjmtAEpkMoKsvgmW0CiEwWEAbU7v3yJztLKmC0Eg@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Feb 12, 2019 at 8:44 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > I think the only case where upper doesn't have direct IO support is
> > tmpfs.  And in that case we should just turn off overlay pagecache by
> > default, since there's no upside to having a cache at the overlay
> > level.  Same probably holds for DAX mounted filesystems as well.
> >
>
> Confused. Isn't overlay page cache the mechanism by which we
> plan to resolve MMAP_SHARED inconsistency.
> Do you propose that tmpfs/DAX won't be able to get MMAP_SHARED
> consistency, or am I missing something?

What I propose is making the default behavior be the most optimal (no
overlay pagecache for tmpfs or dax), but allow forcing overlay
pagecache on or off.

As you've said, the most important goodie to come from the overlay
pagecache is correct selection of inodes on syncfs.  MAP_SHARED
consistency is more of a tickbox thing, IMO.

>
> This thread has been rolling for a while, so here is a recap of remaining
> issues:
>
> - Fix st_blocks failing tests
> - Synchronize page faults with truncate/fallocate?
>   :Also fallocate/copyfile/reflink/etc will need some thought as we need
>   :to not only flush out dirty pages, but in some cases prevent new
>   :faults while the operation is in progress.
> - Optimization/performance
>   :And after that it needs to be optimized (->readpages() and
>   :->writepages()), but I think that's the easy part.
> - Truncate upper inode pages (post copyup and tail page write)
> - Make page cache opt-in and require direct_IO()
> - ovl_sync_fs()
>
> Did I miss anything?
>
> I will try to carve out some time to work on this during next cycle
> and/or chew at the TODO list occasionally, unless you get to it
> before I do. Let me know if you intend to work on this.

Okay.

Thanks,
Miklos
