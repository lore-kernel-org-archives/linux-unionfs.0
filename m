Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com>
References: <490ed00a-7e41-71a5-4318-cc95b36a1b2e@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 29 Jun 2018 13:28:26 +0300
Message-ID: <CAOQ4uximXwPiHySiRxKi4UYxdBt=Y8jj38h0ybrrPGCG0F60nQ@mail.gmail.com>
Subject: Re: Postpone copy-up until first real write?
Content-Type: text/plain; charset="UTF-8"
To: cgxu519 <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jun 29, 2018 at 6:35 AM, cgxu519 <cgxu519@gmx.com> wrote:
> Hi guys,
>
> I have a simple question about copy-up timing after implementing stacked
> file operation.
> Could we postpone copy-up until first real write happens?
>
> The background is consuming much time on open is unexpected for some of our
> applications.
>

I need this behavior as well for snapshots.
On first glance it looks feasible to me.
Seems like we could relax copy up on open(O_RDWR) if there were no special
open flags (O_TRUNC, O_CREATE, O_APPEND...), then mask out O_ACCMODE
if opening a lower inode and defer copy up to ovl_real_fdget_meta() in case the
O_ACCMODE flags of file and real->file don't match.

Then we can introduce ovl_real_fdget_read() call to be used in ovl_read_iter()
and ovl_copyfile() (in_file) in which cases the mismatch O_ACCMODE flags
doesn't need to be corrected with copy up.

Miklos? Does this sound reasonable to you?

Chengguang,

Will you take a swing at implementing this if there are no holes found
in the plan?
Do you know if your applications typically open files with O_RDWR? any
other flags?
Deferring copy up to first write with O_WRONLY seems a bit more tricky.

Thanks,
Amir.
