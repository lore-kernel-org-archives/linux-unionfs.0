From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs access checks on underlying layers
Date: Wed, 28 Nov 2018 11:00:09 +0100
Message-ID: <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com> <20181127210542.GA2599@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181127210542.GA2599@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Nov 27, 2018 at 10:05 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Nov 27, 2018 at 08:58:06PM +0100, Miklos Szeredi wrote:
> > [resending with fixed email address for Paul Moore]
> >
> > Moving discussion from github[1] to here.
> >
> > To summarize: commit 007ea44892e6 ("ovl: relax permission checking on
> > underlying layers") was added in 4.20-rc1 to make overlayfs access
> > checks on underlying "real" filesystems more consistent.  The
> > discussion leading up to this commit can be found at [2].  The commit
> > broke some selinux-testsuite cases, possibly indicating a security
> > hole opened by this commit.
> >
> > The model this patch tries to follow is that if "cp --preserve=all"
> > was allowed to the mounter from underlying layer to the overlay layer,
> > then operation is allowed.  That means even if mounter's creds doesn't
> > provide permission to for example execute underying file X, if
> > mounter's creds provide sufficient permission to perform "cp
> > --preserve=all X Y"  and original creds allow execute on Y, then the
> > operation is allowed.  This provides consistency in the face of
> > copy-ups.  Consistency is only provided in sane setups, where mounter
> > has sufficient privileges to access both the lower and upper layers.
>
> [cc daniel walsh]
>
> I think current selinux testsuite tests are written keeping these
> rules in mind.
>
> 1. Check overlay inode creds in the context of task and underlying
>    inode creds (lower/upper), in the context of mounter.
>
> 2. For a lower inode, if said file is being copied up, then only
>    check MAY_READ on lower. This is equivalent to mounter creating
>    a copy of file and providing caller access to it (context mount).
>
> For the case of special devices, we do not copy up these. So should
> we continue to do check on lower inode in the context of mounter
> (instead of not doing any check on lower at all).

Hmm, I'm trying to understand the logic... If we follow the "cp
--preserve=all" thing, than mounter needs to have CREATE permission
for the special file, not READ or WRITE.  Does that make sense?  Would
that help with the context= mount use case?

>
> For being able to execute a file, should we atleast check MAY_READ
> on lower.

Yep, that looks like a bug present from day one: MAY_EXEC doesn't
always imply MAY_READ, but to be able to execute a file, the kernel
must read it first, and if mounter doesn't have privilege to read the
file, then user should not be allowed to execute it.

> I am not sure why did we have to drop current checks on special file
> and execute. I will read through the thread you pointed out.

TL;DR: NFS access model is that creds are checked by server (and
cached in client), and server could be denying write access to a
device file to mounter (root) independently of DAC. In that case write
access by user to device file would be inconsistent (denied before
copy-up, allowed after copy-up).  Same goes for execute.

And same goes for MAC:  if it's denying READ/WRITE on device or
denying EXECUTE on readable file to mounter, and mounter can just copy
that device/file to a temporry location not controlled by that MAC,
than it can work around that restriction.  IOW, this is just a
generalization of the rule that we ignore WRITE access on lower layer,
because a write will never reach the lower layer.

Thanks,
Miklos
