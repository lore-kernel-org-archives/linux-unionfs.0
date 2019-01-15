MIME-Version: 1.0
Date: Tue, 15 Jan 2019 10:19:34 +0100
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com>
	<CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
	<CAJfpegvJU32_9_mVh7kem0s529-8Qs02fPSr4ChCC3ZJ2pRhLw@mail.gmail.com>
	<CAOQ4uxg=Qzau99ZWwNRoEHAKgpMTapDFxjQhCE+ntEbV2AFVOg@mail.gmail.com>
In-Reply-To: <CAOQ4uxg=Qzau99ZWwNRoEHAKgpMTapDFxjQhCE+ntEbV2AFVOg@mail.gmail.com>
Message-ID: <CAJfpegtfjyk+AjGtqtrWgnXMMq_xOcNPM0wtObtJjrW=0e-nJg@mail.gmail.com>
Subject: Re: Postpone copy-up until first real write?
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: cgxu519 <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Jan 13, 2019 at 12:25 PM Amir Goldstein <amir73il@gmail.com> wrote:

> Did you give any consideration to the locking order of copy up
> from write fault context?
>
> I suppose you are aware of this hence the proposal of pre_mmap op:
> https://marc.info/?l=linux-fsdevel&m=152760695502640&w=2

Apparently ->fault() is allowed to release mmap_sem and return
VM_FAULT_RETRY, which is perfect for doing the copy up.

> Do we gain anything (simplicity? relaxed locking order) if we always
> copy up metadata on open O_RDWR and only delay data copy up
> until first write/page fault?

Yeah, maybe doing that as a start makes sense.

Thanks,
Miklos
