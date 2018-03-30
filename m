Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-13-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-13-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 12:24:15 +0300
Message-ID: <CAOQ4uxhaD9bkmm3UCSM_E30SX7SEuJHzfa8xrNyRnJ4wqLBm7A@mail.gmail.com>
Subject: Re: [PATCH v13 12/28] ovl: Fix ovl_getattr() to get number of blocks
 from lower
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If an inode has been copied up metadata only, then we need to query the
> number of blocks from lower and fill up the stat->st_blocks.
>
> We need to be careful about races where we are doing stat on one cpu and
> data copy up is taking place on other cpu. We want to return
> stat->st_blocks either from lower or stable upper and not something in
> between. Hence, ovl_has_upperdata() is called first to figure out whether
> block reporting will take place from lower or upper.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c     | 17 ++++++++++++++++-
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 16 ++++++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index e1dbfed0c449..cd03f3e642fd 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -76,6 +76,9 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>         bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
>         bool samefs = ovl_same_sb(dentry->d_sb);
>         int err;
> +       bool metacopy = false;
> +
> +       metacopy = ovl_is_metacopy_dentry(dentry);
>
>         type = ovl_path_real(dentry, &realpath);
>         old_cred = ovl_override_creds(dentry->d_sb);
> @@ -93,7 +96,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>         if (!is_dir || samefs) {
>                 if (OVL_TYPE_ORIGIN(type)) {
>                         struct kstat lowerstat;
> -                       u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
> +                       u32 lowermask = STATX_INO | STATX_BLOCKS |
> +                                       (!is_dir ? STATX_NLINK : 0);

Leftover.

But I think you could do with one vfs_getattr():

         if (!is_dir || samefs) {
                   u32 lowermask = metacopy ? STATX_BLOCKS : 0;
                   if (OVL_TYPE_ORIGIN(type))
                           lowermask |= STATX_INO | (!is_dir ? STATX_NLINK : 0);
                   if (lowermask) {
                           ovl_path_lower(dentry, &realpath);
                           err = vfs_getattr(&realpath, &lowerstat,

...

Thanks,
Amir.
