Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190211165323.9369-1-iforster@suse.com> <CAOQ4uxgSZv7t5HznAhsWrzv3e3VwQ7sbZrjgjfRsviq-wsr7EA@mail.gmail.com>
 <1550011897.12743.310.camel@linux.ibm.com> <4472439.nvz8ndpTJa@linux-e202.suse.de>
In-Reply-To: <4472439.nvz8ndpTJa@linux-e202.suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 13 Feb 2019 11:13:59 +0200
Message-ID: <CAOQ4uxhXjYQ4xfF0itXTRtDEqGqqkgxFBVeeDG2qPyfTXz+kCw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Fix overlayfs on EVM
Content-Type: text/plain; charset="UTF-8"
To: Fabian Vogt <fvogt@suse.de>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity <linux-integrity@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Feb 13, 2019 at 10:05 AM Fabian Vogt <fvogt@suse.de> wrote:
>
> Hi,
>
> Am Dienstag, 12. Februar 2019, 23:51:37 CET schrieb Mimi Zohar:
> >
> > > > > If my assumptions so far are correct, then the effort for making
> > > > > IMA/EVM work with overlayfs should focus around finding the
> > > > > places where overlayfs uses lower level vfs interface (often
> > > > > vfs_xxx helpers) and make sure that the IMA hooks are place
> > > > > in those lower vfs interfaces, just like vfs_create() patch does
> > > > > and like vfs_tmpfile() patch did before it.
> > > >
> > > > So basically turning on NOIMA for overlayfs while ensuring that integrity
> > > > checks and operations still perform as expected?
> > >
> > > Yes.
> > > As far as IMA is concerned, Overlayfs is like a filesystem user from kernel.
> > > Very similar to knfsd in that respect.
> >
> > Fabian, if you're thinking of disabling IMA-appraisal on overlay filesystems,
> > have you tried defining an appraise policy rule based on the overlayfs
> > magic number (eg. dont_appraise fsmagic=0x794c7630)?
>
> Yes, that was one of the first approaches we tested - basically switching from
> a) to b) using configuration. It didn't work: Then IMA was completely
> circumvented and neither were hashes updated for changed files nor were they
> checked on access. That was a few months ago though, so it might have changed.
>

Not very surprising considering the missing IMA hooks in level of
vfs_create() and vfs_tmpfile().

Here is a partial list of vfs interfaces used by overlayfs for you to audit:

For copy up:
dentry_open()
do_clone_file_range()
do_splice_direct()
notify_change()

For file open (since kernel v4.19):
open_with_fake_path()

All around:
git grep "vfs_" fs/overlayfs/

Thanks,
Amir.
