MIME-Version: 1.0
Date: Tue, 12 Nov 2019 10:12:28 +0100
References: <1086cadc-53c3-effd-5ba3-797a015944b5@linux.alibaba.com>
In-Reply-To: <1086cadc-53c3-effd-5ba3-797a015944b5@linux.alibaba.com>
Message-ID: <CAJfpegu0CkBUTnkgv+C-cXopoj7oPjqsbFwN49EMhTw7=Pv+Tw@mail.gmail.com>
Subject: Re: [Regression] performance regression since v4.19
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Nov 12, 2019 at 8:53 AM Jiufei Xue <jiufei.xue@linux.alibaba.com> w=
rote:
>
> Hi Miklos,
>
> A performance regression is observed since linux v4.19 when we do aio
> test using fio with iodepth 128 on overlayfs. And we found that queue
> depth of the device is always 1 which is unexpected.
>
> After investigation, it is found that commit 16914e6fc7
> (=E2=80=9Covl: add ovl_read_iter()=E2=80=9D) and commit 2a92e07edc
> (=E2=80=9Covl: add ovl_write_iter()=E2=80=9D) use do_iter_readv_writev() =
to submit
> requests to real filesystem. Async IOs are converted to sync IOs here
> and cause performance regression.
>
> I wondered that is this a design flaw or supposed to be.

It's not theoretically difficult to fix.   The challenge is to do it
without too much complexity or code duplication.

Maybe best would be to introduce VFS helpers specially for stacked
operation such as:

  ssize_t vfs_read_iter_on_file(struct file *file, struct kiocb
*orig_iocb, struct iov_iter *iter);
  ssize_t vfs_write_iter_on_file(struct file *file, struct kiocb
*orig_iocb, struct iov_iter *iter);

Implementation-wise I'm quite sure we need to allocate a new kiocb and
initialize it from the old one, adding our own completion callback.

Thanks,
Miklos
