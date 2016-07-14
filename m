From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 8/9] overlayfs: Dilute permission checks on lower only if
 not special file
Date: Thu, 14 Jul 2016 08:51:48 +0200
Message-ID: <CAJfpegsTUcDOwE6Y_2A+erSWrK+6prFe8ztj8zm0X=Nyro+Y=g@mail.gmail.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com> <1468421095-22322-9-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1468421095-22322-9-git-send-email-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, pmoore@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 13, 2016 at 4:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now if file is on lower/, we remove MAY_WRITE/MAY_APPEND bits from
> mask as lower/ will never be written and file will be copied up. But this
> is not true for special files. These files are not copied up and are
> opened in place. So don't dilute the checks for these types of files.

Pushed this one as well.

Miklos

>
> Reported-by: Dan Walsh <dwalsh@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 66f42f5..6d9d86e 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -140,7 +140,7 @@ int ovl_permission(struct inode *inode, int mask)
>                 return err;
>
>         old_cred = ovl_override_creds(inode->i_sb);
> -       if (!is_upper)
> +       if (!is_upper && !special_file(realinode->i_mode))
>                 mask &= ~(MAY_WRITE | MAY_APPEND);
>         err = inode_permission(realinode, mask);
>         revert_creds(old_cred);
> --
> 2.7.4
>
