Return-Path: <fvogt@suse.de>
From: Fabian Vogt <fvogt@suse.de>
Subject: Re: [RFC PATCH 0/5] Fix overlayfs on EVM
Date: Tue, 12 Feb 2019 11:55:35 +0100
Message-ID: <3938260.lArqBy00Sx@linux-e202.suse.de>
In-Reply-To: <CAOQ4uxhyk7BEmQYf8D6j8FvYJGaxPoa2oJePeF42jbdp__=PSA@mail.gmail.com>
References: <20190211165323.9369-1-iforster@suse.com> <CAOQ4uxhyk7BEmQYf8D6j8FvYJGaxPoa2oJePeF42jbdp__=PSA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: Amir Goldstein <amir73il@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

Am Dienstag, 12. Februar 2019, 04:29:30 CET schrieb Amir Goldstein:
> On Mon, Feb 11, 2019 at 10:28 PM Ignaz Forster <iforster@suse.com> wrote:
> >
> > From: Ignaz Forster <iforster@suse.de>
> >
> > This patch series tries to solve several problems found when using
> > EVM on an overlay file system.
> >
> > Especially patch 4 and 5 will need further discussion; patch 4 will
> > introduce follow up problems, patch 5 can be considered a workaround
> > at best.
> >
> 
> I think maybe the entire series (short of vfs_create hook) is a workaround.

Correct.

> Let's stop and think. What is IMA/EVM meant to do?
> Provide tamper proof protection for persistent storage. Right?
> 
> Overlayfs uses other filesystems to store persistent data/metadata,
> so if IMA/EVM already protect those other filesystems, we got
> tamper proof already don't we?

Yup. There are two approaches overlayfs can interface with IMA/EVM:
a) (vfs) -> IMA/EVM -> overlayfs -> filesystem
b) (vfs) -> overlayfs -> IMA/EVM -> filesystem

Both are from my view equally valid, just with different issues.
Currently the first approach is used, as all IMA/EVM and security hooks
are invoked from the "high-level" vfs functions and overlayfs calls
the lower functions to interface with the underlying filesystems, skipping
all those checks/processes.

Doing b) has the disadvantage that overlayfs needs to become IMA/EVM-aware
(or use the high-level functions for everything) and special care needs to
be taken to a) do IMA/EVM work properly b) not do it twice.
It would avoid an entire class of IMA/EVM issues though, by only doing work
on the actual filesystem nodes and not on the virtual overlayfs ones.

> The issue with overlayfs and security hooks is often credentials
> because underlying filesystems are accessed with different
> credentials (mounter credentials) than the overlay file access.
> Is that an issue for IMA/EVM?

I'm not familiar enough with IMA/EVM internals to comment here, but I assume
that IMA/EVM is only invoked after a related operation succeeded, e.g.
security.ima is only updated after a successful write. So this shouldn't be
an issue (?). We could do some tests, but I'm not sure what we would need to
look out for.

> Or is it an issue that IMA policy is path based and may only
> apply to the overlay path and not underlying path??

I'm not quite sure what you mean by that - I've never seen any paths involved
in the IMA policy (/sys/kernel/security/ima/policy).

> I had already suggested once to mark overlay inodes with
> NOIMA flag:
> https://marc.info/?l=linux-unionfs&m=154529013929472&w=2
> and there was a similar suggestion for FUSE:
> https://marc.info/?l=linux-fsdevel&m=151871326115716&w=2

That explains why it was also broken with unionfs when I tried that briefly,
I expected that FUSE mounts would just ignore IMA and due to access from
userspace work properly with IMA/EVM OOTB as well - apparently not yet.

> If my assumptions so far are correct, then the effort for making
> IMA/EVM work with overlayfs should focus around finding the
> places where overlayfs uses lower level vfs interface (often
> vfs_xxx helpers) and make sure that the IMA hooks are place
> in those lower vfs interfaces, just like vfs_create() patch does
> and like vfs_tmpfile() patch did before it.

So basically turning on NOIMA for overlayfs while ensuring that integrity
checks and operations still perform as expected?

Thanks,
Fabian

> Thanks,
> Amir.
