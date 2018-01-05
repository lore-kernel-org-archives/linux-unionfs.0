From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] tmpfs: allow decoding a file handle of an unlinked file
Date: Fri, 5 Jan 2018 17:40:53 +0200
Message-ID: <CAOQ4uxgnzRummiQm0DNP52QxGoJ8XN+EtEkYBWxyTD5YUWf+nQ@mail.gmail.com>
References: <1510555438-28996-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:38752 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbeAEPky (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 10:40:54 -0500
In-Reply-To: <1510555438-28996-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org

On Mon, Nov 13, 2017 at 8:43 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> tmpfs uses the helper d_find_alias() to find a dentry from a decoded
> inode, but d_find_alias() skips unhashed dentries, so unlinked files
> cannot be decoded from a file handle.
>
> This can be reproduced using xfstests test program open_by_handle:
> $ open_by handle -c /tmp/testdir
> $ open_by_handle -dk /tmp/testdir
> open_by_handle(/tmp/testdir/file000000) returned 116 incorrectly on an
> unlinked open file!
>
> To fix this, if d_find_alias() can't find a hashed alias, call
> d_find_any_alias() to return an unhashed one.
>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Al, Miklos,
>
> Can either of you take this patch through your tree?
>
> Thanks,
> Amir.
>
> Changes since v1:
> - Prefer a hashed alias (James)
> - Use existing d_find_any_alias() helper
>
>  mm/shmem.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 07a1d22807be..5d3fa4099f54 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3404,6 +3404,15 @@ static int shmem_match(struct inode *ino, void *vfh)
>         return ino->i_ino == inum && fh[0] == ino->i_generation;
>  }
>
> +/* Find any alias of inode, but prefer a hashed alias */
> +static struct dentry *shmem_find_alias(struct inode *inode)
> +{
> +       struct dentry *alias = d_find_alias(inode);
> +
> +       return alias ?: d_find_any_alias(inode);
> +}
> +
> +
>  static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
>                 struct fid *fid, int fh_len, int fh_type)
>  {
> @@ -3420,7 +3429,7 @@ static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
>         inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
>                         shmem_match, fid->raw);
>         if (inode) {
> -               dentry = d_find_alias(inode);
> +               dentry = shmem_find_alias(inode);
>                 iput(inode);
>         }
>
> --

Hugh,

Did you get a chance to look at this patch?

The test for decoding a file handle of an unlinked file has already been
merged to xfstest generic/467 and the test is failing on tmpfs without this
change.

Can you please take or ACK this patch?

Thanks,
Amir.
