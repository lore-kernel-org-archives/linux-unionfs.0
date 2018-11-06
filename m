From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] vfs: swap names of {do,vfs}_clone_file_range()
Date: Tue, 6 Nov 2018 08:30:03 +0200
Message-ID: <CAOQ4uxgbO2G8hxxNyKP7ZQ7gGuLFX4D4WU3d13BVQ6vB4f80dw@mail.gmail.com>
References: <20181022175646.20146-1-amir73il@gmail.com> <CAOQ4uxjWKZtjrERj3LGLE8D1B9c=0mR7XQc4oWx_Suwj0bccHQ@mail.gmail.com>
 <20181106001205.GX194472@sasha-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181106001205.GX194472@sasha-vm>
Sender: stable-owner@vger.kernel.org
To: sashal@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <miklos@szeredi.hu>, stable <stable@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Nov 6, 2018 at 2:12 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Sat, Nov 03, 2018 at 06:17:09PM +0200, Amir Goldstein wrote:
> >On Mon, Oct 22, 2018 at 8:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >>
> >> commit a725356b6659469d182d662f22d770d83d3bc7b5 upstream.
> >>
> >> Commit 031a072a0b8a ("vfs: call vfs_clone_file_range() under freeze
> >> protection") created a wrapper do_clone_file_range() around
> >> vfs_clone_file_range() moving the freeze protection to former, so
> >> overlayfs could call the latter.
> >>
> >> The more common vfs practice is to call do_xxx helpers from vfs_xxx
> >> helpers, where freeze protecction is taken in the vfs_xxx helper, so
> >> this anomality could be a source of confusion.
> >>
> >> It seems that commit 8ede205541ff ("ovl: add reflink/copyfile/dedup
> >> support") may have fallen a victim to this confusion -
> >> ovl_clone_file_range() calls the vfs_clone_file_range() helper in the
> >> hope of getting freeze protection on upper fs, but in fact results in
> >> overlayfs allowing to bypass upper fs freeze protection.
> >>
> >> Swap the names of the two helpers to conform to common vfs practice
> >> and call the correct helpers from overlayfs and nfsd.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> >> Fixes: 031a072a0b8a ("vfs: call vfs_clone_file_range() under freeze...")
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>
> >> Greg,
> >>
> >> The upstream commit (-rc8) is not a bug fix, it's a vfs API fix.
> >> If we do not apply it to stable kernels, we are going to have a
> >> backporting landmine, should a future fix use vfs_clone_file_range()
> >> it will not do the same thing upstream and in stable.
> >>
> >> I backported the change to linux-4.18.y and added the Fixes label.
> >> I verified that there are no pathces between the Fixes commit and
> >> current master that use {vfs,do}_clone_file_range() and could be
> >> considered for backporting to stable (all thoses that can be considered
> >> are already in stable).
> >>
> >> I verified that that with this backport applies to v4.18.16 there are no
> >> regression of quick clone tests in xfstests with overlayfs and with xfs.
> >> Backport patch also applies cleanly to v4.14.78.
> >>
> >
> >Hi Greg,
> >
> >I hope this email finds you well rested... I am going to assume that your
> >memory has been reset, so pinging to remind you on this with some new
> >information.
> >
> >commit 452ce65951a2 ("vfs: plumb remap flags through the vfs clone
> >functions") is now in master as part of a patch series by Darrick to fix
> >several clone_file_range() issues. I am not sure if anyone is going to
> >backport that series, but just in case, its best to have the vfs API fix
> >in stable for this or any future commits that use the vfs helpers.
> >Specifically, the above commit will not apply to stable without $SUBJECT
> >patch, so there is no risk of silent stable regression, but the risk exists for
> >future patches.
> >
> >I tested that my backport patch cleanly to v4.14.78 and that there are no
> >regression of quick clone tests in xfstests with overlayfs and with xfs.
>
> Hi Amir,
>
> It is quite an interesting issue. Any idea on how this might affect
> <4.14 kernels?
>

This affects kernels >= 4.10 which may have future patches using either
helpers backported. Now that Darrick changed the vfs API signature in
v4.20-rc1 a simple backport of future patch to stable kernel will at least not
compile, but there is still a chance that future backported will just fix the
API without noticing the helpers swap.

> Maybe we should consider a "landmine" coccinelle script to share between
> folks who deal with backports...
>

I wouldn't know where to begin with heuristics. I would say that if we need to
start somewhere we need to look for negating return value landmines, such as
the infamous backporting landmine that was missed and was one of the triggers
for the current xfs "stable embargo":
https://www.spinics.net/lists/xfs/msg27904.html

Thanks,
Amir.
