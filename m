From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 1/3] overlayfs: check CAP_DAC_READ_SEARCH before
 issuing exportfs_decode_fh
Date: Tue, 28 Aug 2018 20:34:40 +0300
Message-ID: <CAOQ4uxgwKe7_QC7Rg=BTQ_WvnAm+-kSh0LXWGVOoHHAqJt3aXA@mail.gmail.com>
References: <20180828165259.211474-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828165259.211474-1-salyzyn@android.com>
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
> v5:
> - dependency of "overlayfs: override_creds=off option bypass creator_cred"
> ---
>  fs/overlayfs/namei.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index c993dd8db739..84982b6525fb 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -193,6 +193,11 @@ struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
>         if (!uuid_equal(&fh->uuid, &mnt->mnt_sb->s_uuid))
>                 return NULL;
>
> +       if (!capable(CAP_DAC_READ_SEARCH)) {
> +               origin = ERR_PTR(-EPERM);
> +               goto out;

Which branch is this works based on?
I don't see any out label in current code.

> +       }
> +
>         bytes = (fh->len - offsetof(struct ovl_fh, fid));
>         real = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
>                                   bytes >> 2, (int)fh->type,
> --

Please add same test in ovl_can_decode_fh().

Problem: none of the ovl_export_operations functions override creds.
I guess things are working now because nfsd is privileged enough.
IOW, the capability check you added doesn't check mounter creds
when coming from nfs export ops - I guess that is not what you want
although you probably don'r enable nfs export.

Thanks,
Amir.
