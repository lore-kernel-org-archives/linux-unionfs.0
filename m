Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40709 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfCPJKJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 16 Mar 2019 05:10:09 -0400
Received: by mail-yw1-f65.google.com with SMTP id p64so5888619ywg.7
        for <linux-unionfs@vger.kernel.org>; Sat, 16 Mar 2019 02:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxipOHT+OzPtFE1ZoSFEJSrEr-MErwp5KX+tBwXq39sx8g@mail.gmail.com>
 <20190316032135.GA9179@dnyarri>
In-Reply-To: <20190316032135.GA9179@dnyarri>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 Mar 2019 11:09:56 +0200
Message-ID: <CAOQ4uxgW6AcBBwys-RE=6=F=rsaVk1qSgRZOEGRGfJe08XCnuA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Don't open files with O_NOATIME in lowerdir
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: aszlig <aszlig@nix.build>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Graham Christensen <graham@grahamc.com>, Samuel Dionne-Riel <samuel@dionne-riel.com>, michael bishop <cleverca22@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Mar 16, 2019 at 5:23 AM aszlig <aszlig@nix.build> wrote:
>
> Being able to read a file despite being the owner but having read
> permissions is pefectly fine, however due to the fact that O_NOATIME is
> passed in ovl_open_realfile (which also affects lowerdir), the open()
> fails.
>
> Now in normal situations where the overlayfs is mounted as root, this
> shouldn't be a problem, but as soon as you have a networked file system,
> things go bad.
>
> That's what happens in NixOS VM tests, where there is a 9p file system
> mounted in a guest VM and a lowerdir of overlayfs on top of that. If the
> file owner on the host is the same as the current uid of qemu process,
> the open() works correctly. However if it's not the case, it will fail
> with EPERM on the host side (even though you have read access).
>

Have a client of network fs pass O_NOATIME flag to server seems strange
in the first place. Is that what other network filesystems do?
man page for open(2) says "This flag may not be effective on all filesystems.
One example is NFS, where the server maintains the access time."

It seems more logical for the 9p server to completely ignore this request,
so you do have another option to fix 9p open.

> I originally thought about adding a condition on whether to add the
> flag, but I only see two options here, which IMHO are bad in their own
> rights:
>
>   * Using inode_owner_or_capable() to check whether to add O_NOATIME,
>     which has the downside that it will not work with networked file
>     systems where you map different users (I've tested this already with
>     a different patch[1]).
>   * Check for failure of open_with_fake_path() and retry without
>     O_NOATIME, which *could* be an option, but I think that might come
>     with a performance penalty.
>
> Actually, a third option would be to just ignore O_NOATIME in fs/namei.c
> instead of returning -EPERM, but I think that could open up a whole
> range of other bugs.
>
> So I'm simply removing the O_NOATIME flag when it comes to lowerdir,
> because for now it is IMHO the most sensible option, as it doesn't cause
> problems with network file systems and also leaves the atime/noatime
> decision to the administrator of the corresponding system. This also
> reverts the behaviour to what we had prior to Linux 4.19.
>

Your patch is incomplete, it doesn't do exactly what I suggested
and the reasoning is also incomplete.

My reasoning was that ovl_path_open() is always called with realpath.
realpath has either lower_layers[i].mnt or upper_mnt.
lower_layers mnt already has MNT_NOATIME so trying to open
a lower file/dir with O_NOATIME is redundant.
With upper file, I am not sure what was the intention of removing
MNT_NOATIME from upper_mnt and then using O_NOTIME for
file open.

> Originally, I had only removed the flag from ovl_open_realfile, but as
> Amir Goldstein pointed out, this is also the case when copying files to
> upperdir. On NixOS I didn't notice this, because Nix store paths are
> never changed and only new ones are added if the build recipe differs.
>

What about ovl_dir_open() and ovl_dir_read() that also call
ovl_path_open() why aren't you seeing the problem there?

> Signed-off-by: aszlig <aszlig@nix.build>
> ---
>  fs/overlayfs/copy_up.c | 7 ++++++-
>  fs/overlayfs/file.c    | 2 +-
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 9e62dcf06fc4..e43d2a2e9d49 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -131,7 +131,12 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>         if (len == 0)
>                 return 0;
>
> -       old_file = ovl_path_open(old, O_LARGEFILE | O_RDONLY);
> +       /*
> +        * Note that this is not using ovl_path_open() because it will use
> +        * O_NOATIME, which in turn could cause issues for networked file
> +        * systems.
> +        */
> +       old_file = dentry_open(old, O_LARGEFILE | O_RDONLY, current_cred());

Not like this.
I think you could check for (path->mnt & MNT_NOATIME) in ovl_path_open()
and not add the O_NOATIME flag in that case for the plain reason that it is
redundant.
Or pass is_upper argument to ovl_path_open() to determine if flag should be
set, so you won't change behavior for upper.


>         if (IS_ERR(old_file))
>                 return PTR_ERR(old_file);
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 84dd957efa24..3f9b9275267b 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -31,7 +31,7 @@ static struct file *ovl_open_realfile(const struct file *file,
>         const struct cred *old_cred;
>
>         old_cred = ovl_override_creds(inode->i_sb);
> -       realfile = open_with_fake_path(&file->f_path, file->f_flags | O_NOATIME,
> +       realfile = open_with_fake_path(&file->f_path, file->f_flags,
>                                        realinode, current_cred());

Not what I meant.
I meant that if you pass realpath to open_with_fake_path() and if realpath
is lower, I see no need to add the O_NOATIME flag.
For upper path there could be other implications, so I am not sure this is
the right thing to do, but for lower path, I don't see any obvious problem.

I would need Miklos to weight in on this, but I am guessing his first quetion
would be "Why?" referring to why should 9p server respect O_NOATIME,
so you'd better have an answer for that first.

Thanks,
Amir.
