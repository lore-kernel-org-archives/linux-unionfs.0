From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 1/2] overlayfs: check CAP_DAC_READ_SEARCH before
 issuing exportfs_decode_fh
Date: Mon, 5 Nov 2018 20:35:17 +0200
Message-ID: <CAOQ4uxi_hY4UnGJhr83gfsrKEkK6pgi1OHv8L7p8GvRvR4tF6A@mail.gmail.com>
References: <20181105182146.233025-1-salyzyn@android.com> <20181105182146.233025-2-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181105182146.233025-2-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, kernel-team@android.com
List-Id: linux-unionfs@vger.kernel.org

On Mon, Nov 5, 2018 at 8:22 PM Mark Salyzyn <salyzyn@android.com> wrote:
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
> Cc: kernel-team@android.com
>
> v5:
> - dependency of "overlayfs: override_creds=off option bypass creator_cred"
>
> v6:
> - rebase

1. rebase onto which branch? doesn't look like the right one
2. pls keep patch revision outside of commit message
    you can put it after --- line
3. revisions are usually ordered latest on the top

> ---
>  fs/overlayfs/namei.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index efd372312ef1..aa012b6bd46e 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -163,6 +163,11 @@ struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
>         if (!uuid_equal(&fh->uuid, &mnt->mnt_sb->s_uuid))
>                 return NULL;
>
> +       if (!capable(CAP_DAC_READ_SEARCH)) {
> +               origin = ERR_PTR(-EPERM);
> +               goto out;

I have a deja vu
there is no out label in this function in upstream kernel
you must post patches that are applies and tested on upstream kernel

Thanks,
Amir.

> +       }
> +
>         bytes = (fh->len - offsetof(struct ovl_fh, fid));
>         real = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
>                                   bytes >> 2, (int)fh->type,
> --
> 2.19.1.930.g4563a0d9d0-goog
>
