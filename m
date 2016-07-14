From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 9/9] overlayfs: Append MAY_READ when diluting write checks
Date: Thu, 14 Jul 2016 08:49:34 +0200
Message-ID: <CAJfpegsu=RU8bMJEi7iiHEQE4vxeByi_TwZU+-zTyTrk1Q9XeA@mail.gmail.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com> <1468421095-22322-10-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1468421095-22322-10-git-send-email-vgoyal@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, pmoore@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 13, 2016 at 4:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now we remove MAY_WRITE/MAY_APPEND bits from mask if realfile is
> on lower/. This is done as files on lower will never be written and will
> be copied up. But to copy up a file, mounter should have MAY_READ permission
> otherwise copy up will fail. So set MAY_READ in mask when MAY_WRITE is
> reset.
>
> Dan Walsh noticed this when he did access(lowerfile, W_OK) and it returned
> True (context mounts) but when he tried to actually write to file, it failed
> as mounter did not have permission on lower file.
>
> Reported-by: Dan Walsh <dwalsh@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 6d9d86e..83b2422 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -140,8 +140,13 @@ int ovl_permission(struct inode *inode, int mask)
>                 return err;
>
>         old_cred = ovl_override_creds(inode->i_sb);
> -       if (!is_upper && !special_file(realinode->i_mode))
> -               mask &= ~(MAY_WRITE | MAY_APPEND);
> +       if (!is_upper && !special_file(realinode->i_mode)) {
> +               if (mask & MAY_WRITE || mask & MAY_APPEND) {

Hmm.   From what I can tell O_APPEND with O_RDONLY is equivalent to
O_RDONLY, hence MAY_APPEND without MAY_WRITE should not behave as if
MAY_WRITE was given.  I.e. it should not trigger a copy up.  Not sure
what MAC checks do with MAY_APPEND, though.

Pushed amended commit to overlayfs-next.

Thanks,
Miklos


> +                       mask &= ~(MAY_WRITE | MAY_APPEND);
> +                       /* Make sure mounter can read file for copy up later */
> +                       mask |= MAY_READ;
> +               }
> +       }
>         err = inode_permission(realinode, mask);
>         revert_creds(old_cred);
>
> --
> 2.7.4
>
