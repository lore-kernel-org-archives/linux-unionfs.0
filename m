Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
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
 <20190128192207.GA10240@redhat.com> <CAOQ4uxg7E=K6_RTd7-qKt6gPGiMx7S46ZYkCECzwEUmxzBkKxQ@mail.gmail.com>
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
 <CAOQ4uxjh4yieJaacbP+5JbRY+=LV4oJU+1JCGV4S+eLE7FEcAw@mail.gmail.com> <CAJfpegu98HhOpajUOEm3OXXXTR4kePK-X3_hZurfDd=u0eHC0g@mail.gmail.com>
In-Reply-To: <CAJfpegu98HhOpajUOEm3OXXXTR4kePK-X3_hZurfDd=u0eHC0g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 1 Feb 2019 15:22:34 +0200
Message-ID: <CAOQ4uxiZu5-Lvy7eeRKmHMwKh7D+zETTQ_4X3=_or4yVarU-4A@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> > > What remains is ctime/mtime support.
> > >
> > > Also fallocate/copyfile/reflink/etc will need some thought as we need
> > > to not only flush out dirty pages, but in some cases prevent new
> > > faults while the operation is in progress.
> >
> > Well, generic/503 which exercises these corners hangs
> > (503.dmesg attached)
>
> That was just a stupid bug in truncate (truncating ovl page with upper
> inode lock held -> ABBA deadlock).
>
> Attached the fix for that one.
>

Force pushed and re-tested.
Summary of regressions of "quick" xfstests since v5.0-rc1:

Wrong st_mtime/st_ctime:
generic/003 generic/080 generic/215

EIO on clone/dedupe:
generic/303 generic/304

Wrong st_blocks/fiemap:
generic/353 generic/392 generic/422

New lazy copy up semantics:
overlay/060

> > >
> > > And after that it needs to be optimized (->readpages() and
> > > ->writepages()), but I think that's the easy part.
> > >
> >
> > And we also need to flush pages on non direct IO cases
> > of ->writepages() and then we can revert:
> > e8d4bfe3a715 ovl: Sync upper dirty data when syncing overlayfs
> > and swoop the grand prize :)
>
> Yeah.
>
> I think the behavior should be tunable (ovl page cache vs. upper page
> cache), at least initially, so it can be benchmarked in various
> situations to see if there are no slowdowns with the new code.
>

Now the real fun begins... choosing the config option name ;-)

Thanks,
Amir.
