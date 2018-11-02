From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 0/6] shiftfs fixes and enhancements
Date: Fri, 2 Nov 2018 10:59:38 +0200
Message-ID: <CAOQ4uxipSP_eKF-SZQ7ss1_yjnuTMyGniOZcgp7NXKBYB0E=8g@mail.gmail.com>
References: <20181101214856.4563-1-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101214856.4563-1-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

[cc: linux-unionfs
It should the mailing list for *all* "stacking fs".
We have a lot of common problems I think ;-) ]

On Thu, Nov 1, 2018 at 11:49 PM Seth Forshee <seth.forshee@canonical.com> wrote:
>
> I've done some work to fix and enhance shiftfs for a number of use
> cases, so that we would have an idea what a more full-featured shiftfs
> would look like. I'm intending for these to serve as a point of
> reference for discussing id shifting mounts/filesystems at plumbers in a
> couple of weeks [1].
>
> Note that these are based on 4.18, and I've added a small fix to James'
> most recent patch to fix a build issue there. To work with 4.19 they
> will need a number of updates due to changes in the vfs.
>

Seth,

I like the way you addressed my concerns about nesting and stacking depth.
Will provide specific nits on patch.

In preparation to the Plumbers talk (which I will not be attending), I wanted to
get your opinion on the matters I brought up last time:
https://marc.info/?l=linux-fsdevel&m=153013920904844&w=2

1) Having seen what it takes to catch up with overlayfs w.r.t inotify bugs
and having peeked into 4.19 to see what work you still have lined up for you
to bring shitfs up to speed with vfs, did you have time to look into my proposal
for sharing code with overlayfs in the manner that I have implemented the
snapshotfs POC?
https://github.com/amir73il/linux/commit/25416757f2ca47759f59b115e6461b11898c4f06

Even if you end up not saving a single line of code for shiftfs v1
meaning that all shiftfs_inode_ops are completely separate implementation
from overlayfs inode ops, this may still be beneficial to shitfs in
the long run.
For example, you may, in fact, won't need to change anything to work with v4.19.
shittfs (as an overlayfs alias) would use ovl_file_operations and
shiftfs_inode_ops.

Another example, from the top of my head, see what it took to add NFS export
support to snapshotfs, because of the code reuse with overlayfs:
https://github.com/amir73il/linux/commit/d082eb615133490ec26fa2efaa80ed4723860893
Its practically the exact same implementation shiftfs would need,
so in the far future, shitfs and snapshotfs can share the same
export_operations.

2) Regarding this part:
+               /*
+                * this part is visible unshifted, so make sure no
+                * executables that could be used to give suid
+                * privileges
+                */
+               sb->s_iflags = SB_I_NOEXEC;

Why would you want to make the unshifted fs visible at all?
Is there a requirement for container users to access the unshifted fs
content? Is there a requirement for container admin to mount shitfted fs
NOT from the root of the marked mount?

If those are not required, then I propose NOOP inode operations for
the unshifted fs, specifically, empty readdir, just enough ops to be able
to use the mark mount point as the shitfed mount source - no more.

Thanks,
Amir.
