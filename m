Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190211165323.9369-1-iforster@suse.com> <CAOQ4uxhyk7BEmQYf8D6j8FvYJGaxPoa2oJePeF42jbdp__=PSA@mail.gmail.com>
 <3938260.lArqBy00Sx@linux-e202.suse.de>
In-Reply-To: <3938260.lArqBy00Sx@linux-e202.suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 12 Feb 2019 15:47:21 +0200
Message-ID: <CAOQ4uxgSZv7t5HznAhsWrzv3e3VwQ7sbZrjgjfRsviq-wsr7EA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Fix overlayfs on EVM
Content-Type: text/plain; charset="UTF-8"
To: Fabian Vogt <fvogt@suse.de>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity <linux-integrity@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Feb 12, 2019 at 12:55 PM Fabian Vogt <fvogt@suse.de> wrote:
>
> Hi,
>
> Am Dienstag, 12. Februar 2019, 04:29:30 CET schrieb Amir Goldstein:
> > On Mon, Feb 11, 2019 at 10:28 PM Ignaz Forster <iforster@suse.com> wrote:
> > >
> > > From: Ignaz Forster <iforster@suse.de>
> > >
> > > This patch series tries to solve several problems found when using
> > > EVM on an overlay file system.
> > >
> > > Especially patch 4 and 5 will need further discussion; patch 4 will
> > > introduce follow up problems, patch 5 can be considered a workaround
> > > at best.
> > >
> >
> > I think maybe the entire series (short of vfs_create hook) is a workaround.
>
> Correct.
>
> > Let's stop and think. What is IMA/EVM meant to do?
> > Provide tamper proof protection for persistent storage. Right?
> >
> > Overlayfs uses other filesystems to store persistent data/metadata,
> > so if IMA/EVM already protect those other filesystems, we got
> > tamper proof already don't we?
>
> Yup. There are two approaches overlayfs can interface with IMA/EVM:
> a) (vfs) -> IMA/EVM -> overlayfs -> filesystem
> b) (vfs) -> overlayfs -> IMA/EVM -> filesystem
>
> Both are from my view equally valid, just with different issues.
> Currently the first approach is used, as all IMA/EVM and security hooks
> are invoked from the "high-level" vfs functions and overlayfs calls
> the lower functions to interface with the underlying filesystems, skipping
> all those checks/processes.
>
> Doing b) has the disadvantage that overlayfs needs to become IMA/EVM-aware
> (or use the high-level functions for everything) and special care needs to
> be taken to a) do IMA/EVM work properly b) not do it twice.
> It would avoid an entire class of IMA/EVM issues though, by only doing work
> on the actual filesystem nodes and not on the virtual overlayfs ones.
>

overlayfs doesn't need to become IMA aware.
It's mostly the other way around.
And BTW, overlay is not the only code calling vfs_xxx helpers
knfsd does that as well.

The fact that nfsd_open() has a ima_ hook means IMA hooks
are not low enough in vfs.

> > The issue with overlayfs and security hooks is often credentials
> > because underlying filesystems are accessed with different
> > credentials (mounter credentials) than the overlay file access.
> > Is that an issue for IMA/EVM?
>
> I'm not familiar enough with IMA/EVM internals to comment here, but I assume
> that IMA/EVM is only invoked after a related operation succeeded, e.g.
> security.ima is only updated after a successful write. So this shouldn't be
> an issue (?). We could do some tests, but I'm not sure what we would need to
> look out for.
>
> > Or is it an issue that IMA policy is path based and may only
> > apply to the overlay path and not underlying path??
>
> I'm not quite sure what you mean by that - I've never seen any paths involved
> in the IMA policy (/sys/kernel/security/ima/policy).
>

I've never seen an IMA policy, but I read that IMA policy can be per file,
so the underlying filesystem files must be enforced by IMA policy.

> > I had already suggested once to mark overlay inodes with
> > NOIMA flag:
> > https://marc.info/?l=linux-unionfs&m=154529013929472&w=2
> > and there was a similar suggestion for FUSE:
> > https://marc.info/?l=linux-fsdevel&m=151871326115716&w=2
>
> That explains why it was also broken with unionfs when I tried that briefly,
> I expected that FUSE mounts would just ignore IMA and due to access from
> userspace work properly with IMA/EVM OOTB as well - apparently not yet.
>
> > If my assumptions so far are correct, then the effort for making
> > IMA/EVM work with overlayfs should focus around finding the
> > places where overlayfs uses lower level vfs interface (often
> > vfs_xxx helpers) and make sure that the IMA hooks are place
> > in those lower vfs interfaces, just like vfs_create() patch does
> > and like vfs_tmpfile() patch did before it.
>
> So basically turning on NOIMA for overlayfs while ensuring that integrity
> checks and operations still perform as expected?
>

Yes.
As far as IMA is concerned, Overlayfs is like a filesystem user from kernel.
Very similar to knfsd in that respect.

Thanks,
Amir.
