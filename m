From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v14 2/5] overlayfs: check CAP_DAC_READ_SEARCH before
 issuing exportfs_decode_fh
Date: Wed, 23 Oct 2019 09:17:00 +0300
Message-ID: <CAOQ4uxgE_HmVFHJ0ZEoTMotnFokD3X-TR-PiO3By84ShbSfS_Q@mail.gmail.com>
References: <20191022204453.97058-1-salyzyn@android.com> <20191022204453.97058-3-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191022204453.97058-3-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Oct 22, 2019 at 11:46 PM Mark Salyzyn <salyzyn@android.com> wrote:
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
> ---
> v11 + v12 +v13 + v14 - rebase
>
> v10:
> - return NULL rather than ERR_PTR(-EPERM)
> - did _not_ add it ovl_can_decode_fh() because of changes since last
>   review, suspect needs to be added to ovl_lower_uuid_ok()?
>
> v8 + v9:
> - rebase
>
> v7:
> - This time for realz
>
> v6:
> - rebase
>
> v5:
> - dependency of "overlayfs: override_creds=off option bypass creator_cred"
>
> ---
>  fs/overlayfs/namei.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index e9717c2f7d45..9702f0d5309d 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -161,6 +161,9 @@ struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
>         if (!uuid_equal(&fh->uuid, &mnt->mnt_sb->s_uuid))
>                 return NULL;
>
> +       if (!capable(CAP_DAC_READ_SEARCH))
> +               return NULL;
> +

Shouldn't this return EPERM?

>         bytes = (fh->len - offsetof(struct ovl_fh, fid));
>         real = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
>                                   bytes >> 2, (int)fh->type,
> --
> 2.23.0.866.gb869b98d4c-goog
>
