From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/3] ovl: set origin xattr for merge dir on lookup
Date: Wed, 8 Nov 2017 10:27:03 +0200
Message-ID: <CAOQ4uxjfE+vO9TDwHsuCD5Zwj9-7ZF9km-PibnTooK61ShKQJw@mail.gmail.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
 <1510090740-7216-3-git-send-email-amir73il@gmail.com> <03198975-d870-d49e-f807-01f3d805d001@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:46413 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdKHI1E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 03:27:04 -0500
Received: by mail-yw0-f193.google.com with SMTP id t71so1643494ywc.3
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Nov 2017 00:27:04 -0800 (PST)
In-Reply-To: <03198975-d870-d49e-f807-01f3d805d001@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>

On Wed, Nov 8, 2017 at 8:59 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/11/8 5:38, Amir Goldstein Wrote:
>> For old existing merge dirs whose "origin" xattr was not set at copy up
>> time, we amend the situation on lookup.
>>
>> If no origin fh is stored in upper of a merge dir, store fh of upper most
>> lower dir or 'null' fh if lower does not support file handles. We do this
>> so we can filter out whiteouts in case lower dir is removed offline and
>> then upper dir becomes a pure upper in a future mount.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/namei.c     | 61 ++++++++++++++++++++++++++++++++++++++++--------
>>  fs/overlayfs/overlayfs.h |  2 +-
>>  fs/overlayfs/super.c     |  4 ++--
>>  3 files changed, 54 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index 322c6214114f..65606a0a124c 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -87,6 +87,8 @@ static int ovl_acceptable(void *ctx, struct dentry *dentry)
>>       return 1;
>>  }
>>
>> +static struct ovl_fh ovl_null_fh;
>> +
>>  static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>>  {
>>       int res;
>> @@ -100,7 +102,7 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>>       }
>>       /* Zero size value means "copied up but origin unknown" */
>>       if (res == 0)
>> -             return NULL;
>> +             goto null_fh;
>>
>>       fh  = kzalloc(res, GFP_KERNEL);
>>       if (!fh)
>> @@ -118,12 +120,12 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>>
>>       /* Treat larger version and unknown flags as "origin unknown" */
>>       if (fh->version > OVL_FH_VERSION || fh->flags & ~OVL_FH_FLAG_ALL)
>> -             goto out;
>> +             goto null_fh;
>>
>>       /* Treat endianness mismatch as "origin unknown" */
>>       if (!(fh->flags & OVL_FH_FLAG_ANY_ENDIAN) &&
>>           (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
>> -             goto out;
>> +             goto null_fh;
>>
>>       return fh;
>>
>> @@ -131,6 +133,10 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>>       kfree(fh);
>>       return NULL;
>>
>> +null_fh:
>> +     kfree(fh);
>> +     return &ovl_null_fh;
>> +
>>  fail:
>>       pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
>>       goto out;
>> @@ -149,6 +155,9 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
>>       if (IS_ERR_OR_NULL(fh))
>>               return (struct dentry *)fh;
>>
>> +     if (fh == &ovl_null_fh)
>> +             return NULL;
>> +
>>       /*
>>        * Make sure that the stored uuid matches the uuid of the lower
>>        * layer where file handle will be decoded.
>> @@ -333,6 +342,10 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
>>       if (IS_ERR(ofh))
>>               return PTR_ERR(ofh);
>>
>> +     /* NULL fh (no lower fh support) and stored 'null' fh is a match */
>> +     if (ofh == &ovl_null_fh)
>> +             return fh ? -ESTALE : 0;
>> +
>
> Is -ESTALE -> -ENODATA better ?
>

If -ENODATA is returned of null_fh then ovl_verify_origin() will set
xattr (back to null_fh)
on every lookup, so we need to be able to distinguish between the
cases of no origin
(-ENODATA) and null_fh.
To be honest I have mixed feelings about the ovl_null_fh trick.
We should probably just pick an arbitrary error code to use internally
to describe null_fh,
like -ENOENT, but a part of me thought that the ovl_null_fh trick is
clearer to read???


> Consider the case: We set 'null' fh in merged upper dir on a 'file handle' not supported
> base filesystem, then we copy or tar all underlying directories to another base filesystem which is
> 'file handle' supported and mount overlayfs again. I think we can update upperdir's fh instead of
> return fail.
>

In what way does it help us to update fh in that case?
We are not following to lower directory by fh anyway.
And we cannot really trust that the restored origin is correct
in the context of my 'verify_dir' patches.
The only use case I see for doing that is container migration - if tar
of container
will deliberately replace concrete origin fh on all dirs with null_fh
before migration,
knowing that origin fh are going to become stale on migration.
And then after migration, iterate all dirs in overlay to restore origin.
But we can leave that to a separate change. This one is mostly concerned
about setting origin for the purpose of whiteout exposure.

> At the same time, consider the opposite side, all directories move from a base filesystem which 'file
> handle' supported to a not supported one. It will trigger NULL pointer crash in ovl_verify_origin_fh()
> because fh is NULL but ofh was existed. Following change good ?
>
> -       if (!ofh)
> +       if (!ofh || !fh)
>                 return -ENODATA;
>

Thanks for pointing that out, but change is not good because it looses the
information about finding a stored null_fh.
If we do want to stick with ovl_null_fh trick, I could pass in &ovl_null_fh
instead of NULL, in case of !ovl_can_decode_fh(origin->d_sb).
This fixes the NULL pointer crash and I can remove this special case,
because fh->len + memcmp will do the right thing:

        /* NULL fh (no lower fh support) and stored 'null' fh is a match */
        if (ofh == fh)
                return fh ? -ESTALE : 0;

Amir.
