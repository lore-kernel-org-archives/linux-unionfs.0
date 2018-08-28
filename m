From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 2/3] overlayfs: check CAP_MKNOD before issuing vfs_whiteout
Date: Tue, 28 Aug 2018 20:43:21 +0300
Message-ID: <CAOQ4uxhRPOC_prhygrjndMMUrtU-S7FrLJ0tb4eJUV94GFj38w@mail.gmail.com>
References: <20180828165319.211563-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828165319.211563-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Aug 28, 2018 at 7:53 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
> Assumption never checked, should fail if the mounter creds are not
> sufficient.
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> v5
> - dependency of "overlayfs: override_creds=off option bypass creator_cred"
> ---
>  fs/overlayfs/overlayfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 7538b9b56237..bf3a80157d42 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -176,7 +176,7 @@ static inline int ovl_do_rename(struct inode *olddir, struct dentry *olddentry,
>
>  static inline int ovl_do_whiteout(struct inode *dir, struct dentry *dentry)
>  {
> -       int err = vfs_whiteout(dir, dentry);
> +       int err = capable(CAP_MKNOD) ? vfs_whiteout(dir, dentry) : -EPERM;

Should that be ns_capable()? Should the test go into vfs_whiteout()?
I feel there is no convention at all.

Thanks,
Amir.
