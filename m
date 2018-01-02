From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix inconsistent d_ino for legacy merge dir
Date: Tue, 2 Jan 2018 10:14:19 +0200
Message-ID: <CAOQ4uxiJY+1nz3P1fpy8hukCGL1Vx8GOhX3PFjCO6LM5nSA3_Q@mail.gmail.com>
References: <1514713778-15640-1-git-send-email-amir73il@gmail.com> <273d72b1-8c19-ef41-ef26-6304a333b532@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:33533 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbeABIOU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 03:14:20 -0500
Received: by mail-yb0-f194.google.com with SMTP id f16so3929432ybn.0
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Jan 2018 00:14:20 -0800 (PST)
In-Reply-To: <273d72b1-8c19-ef41-ef26-6304a333b532@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>

On Tue, Jan 2, 2018 at 10:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/12/31 17:49, Amir Goldstein Wrote:
>> For a merge dir that was copied up before v4.12 or that was hand crafted
>> offline (e.g. mkdir {upper/lower}/dir), upper dir does not contain the
>> 'trusted.overlay.origin' xattr.  In that case, stat(2) on the merge dir
>> returns the lower dir st_ino, but getdents(2) returns the upper dir d_ino.
>>
>> After this change, on merge dir lookup, missing origin xattr on upper
>> dir will be fixed and 'impure' xattr will be fixed on parent of the legacy
>> merge dir.
>>
>> Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Zhangyi,
>>
>> Please review/test this patch.
>> I ended up applying it at the bottom of verify_dir [1] series,
>> so it could be merged to v4.15 and/or easily backported to v4.14
>> (where consistent d_ino was merged) if Miklos thinks this is an important
>> use case to fix.
>>
>
> Hi Amir,
> This patch looks good (one nit below) but still have a case which will lead to problem
> we missed in last discussion:
> Call getdent(2) before invoke ovl_lookup() after first mount.
>
> eg:
> 1) mkdir {upper/lower}/dir merge work
> 2) mount to merge
> 3) getdent merge
> 2253114  directory    24          2  dir
> 4) ls merge
> 5) getdent merge
> 2253113  directory    24          2  dir
>
> Strictly speaking, it is a problem ,but not sure it's worth to fix now.

Yeh, it's true.

Please note, that the sole purpose of "impure" xattr in the world,
is to optimize away the need to lookup directory entries in getdents
for fixing d_ino.
So yes, I think this specific corner case is something that users will have to
be educated about.

Also please note that I have not found any program that relies of d_ino of
directories (not that I would know where to look). I did check that
'find -inum <ino>'
does NOT reply of values of d_ino for subdirs. 'find' always call
stat(2) for subdirs.
So that is one less program to worry about.

>
> Thanks,
> zhangyi.
>
>> Thanks,
>> Amir.
>>
>> [1] https://github.com/amir73il/linux/commits/ovl-verify-dir
>>
>>  fs/overlayfs/namei.c     | 36 +++++++++++++++++++++++++++++++-----
>>  fs/overlayfs/overlayfs.h |  2 +-
>>  fs/overlayfs/super.c     |  5 +++--
>>  3 files changed, 35 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index 9cf15463754c..bd7375c05f7d 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -343,13 +343,13 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
>>  /*
>>   * Verify that an inode matches the origin file handle stored in upper inode.
>>   *
>> - * If @set is true and there is no stored file handle, encode and store origin
>> - * file handle in OVL_XATTR_ORIGIN.
>> + * If @set is non-null and there is no stored file handle, set *@set to true
>> + * and try to encode and store origin file handle in OVL_XATTR_ORIGIN.
>>   *
>> - * Return 0 on match, -ESTALE on mismatch, < 0 on error.
>> + * Return 0 on match or successful set, -ESTALE on mismatch, < 0 on error.
>>   */
>>  int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
>> -                   bool is_upper, bool set)
>> +                   bool is_upper, bool *set)
>>  {
>>       struct inode *inode;
>>       struct ovl_fh *fh;
>> @@ -361,8 +361,13 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
>>               goto fail;
>>
>>       err = ovl_verify_origin_fh(dentry, fh);
>> -     if (set && err == -ENODATA)
>> +     if (set && err == -ENODATA) {
>> +             *set = true;
>>               err = ovl_do_setxattr(dentry, OVL_XATTR_ORIGIN, fh, fh->len, 0);
>> +             if (err)
>> +                     goto fail;
>
> Remove this repeated error handle ?
>

Right. Thanks,
Amir.
