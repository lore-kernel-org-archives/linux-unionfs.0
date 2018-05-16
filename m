MIME-Version: 1.0
In-Reply-To: <1526379972-20923-3-git-send-email-amir73il@gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
	<1526379972-20923-3-git-send-email-amir73il@gmail.com>
Date: Wed, 16 May 2018 12:29:15 +0200
Message-ID: <CAJfpegs3AC6zTeHYmn0r9dNTHhf=jRpkkkyOegB+r=CDZCyk4w@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: relax WARN_ON() real inode attributes mismatch
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 15, 2018 at 12:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Overlayfs should cope with online changes to underlying layer
> without crashing the kernel, which is what xfstest overlay/019
> checks.
>
> This test may sometimes trigger WARN_ON() in ovl_create_or_link()
> when linking an overlay inode that has been changed on underlying
> layer.
>
> Replace those WARN_ON() with pr_warn_ratelimited() to prevent
> test from failing and because this is more appropriate to the
> use case.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 62e6733b755c..25b339278684 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -525,9 +525,17 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>         if (!err) {
>                 struct inode *realinode = d_inode(ovl_dentry_upper(dentry));
>
> -               WARN_ON(inode->i_mode != realinode->i_mode);
> -               WARN_ON(!uid_eq(inode->i_uid, realinode->i_uid));
> -               WARN_ON(!gid_eq(inode->i_gid, realinode->i_gid));
> +               if (inode->i_mode != realinode->i_mode ||
> +                   !uid_eq(inode->i_uid, realinode->i_uid) ||
> +                   !gid_eq(inode->i_gid, realinode->i_gid)) {
> +                       pr_warn_ratelimited("overlayfs: real inode attributes mismatch (%pd2, %o.%u.%u != %o.%u.%u).\n",
> +                               dentry, inode->i_mode,
> +                               from_kuid(&init_user_ns, inode->i_uid),
> +                               from_kgid(&init_user_ns, inode->i_gid),
> +                               realinode->i_mode,
> +                               from_kuid(&init_user_ns, realinode->i_uid),
> +                               from_kgid(&init_user_ns, realinode->i_gid));
> +               }

How about just dropping the warnings altogether.  They didn't discover
an issue with the code, just something normal, so IMO we should just
get rid of them.

Thanks,
Miklois
