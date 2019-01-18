Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com> <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
 <CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
 <CAOQ4uxg=Qzau99ZWwNRoEHAKgpMTapDFxjQhCE+ntEbV2AFVOg@mail.gmail.com> <cc831a7a-c515-fdd2-6971-e79d389058a0@gmx.com>
In-Reply-To: <cc831a7a-c515-fdd2-6971-e79d389058a0@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 18 Jan 2019 15:52:08 +0200
Message-ID: <CAOQ4uxjFUbniWr+b5_KYHJ9AJOyJdUo0-8G0S5f8jo4z6zJHrQ@mail.gmail.com>
Subject: Re: Postpone copy-up until first real write?
Content-Type: text/plain; charset="UTF-8"
To: cgxu519 <cgxu519@gmx.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jan 14, 2019 at 10:21 AM cgxu519 <cgxu519@gmx.com> wrote:
[...]
> > Do we gain anything (simplicity? relaxed locking order) if we always
> > copy up metadata on open O_RDWR and only delay data copy up
> > until first write/page fault?
> >
> > Chengguang,
> >
> > For your use case, is it acceptable if we copy up metadata
> > (and parents) before first write?
>
> In our use case that will be fine if copy up metadata(and parents) is
> quick enough.
>

Chengguang,

I posted an RFC patch (sorry forgot to CC you).
It seems to be working as expected short of the mmap case,
but I only tested manually - have not written any tests yet.

You may test the RFC patch and let me know if it meets the requirements
of your use case.

Thanks,
Amir.
