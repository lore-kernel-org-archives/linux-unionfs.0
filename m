From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: check IS_APPEND() on real upper inode
Date: Fri, 7 Apr 2017 19:19:09 +0300
Message-ID: <CAOQ4uxhCN3UngJ9mz=SsGrm_x2FFFpZce8L_uDuU3cyQ5wkxpw@mail.gmail.com>
References: <1491555701-16608-1-git-send-email-amir73il@gmail.com>
 <1491555701-16608-4-git-send-email-amir73il@gmail.com> <CAJfpegtkq=2KQz0-6JujiRqt7GurzjBO0Rj75ky5saEVLYdFHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35811 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933588AbdDGQTK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 12:19:10 -0400
In-Reply-To: <CAJfpegtkq=2KQz0-6JujiRqt7GurzjBO0Rj75ky5saEVLYdFHQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Apr 7, 2017 at 4:33 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 7, 2017 at 11:01 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> For overlay file open, check IS_APPEND() on the real upper inode
>> inside d_real(), because the overlay inode does not have the
>> S_APPEND flag and IS_APPEND() can only be checked at open time.
>>
>> Note that because overlayfs does not copy up the chattr inode flags
>> (i.e. S_APPEND, S_IMMUTABLE), the IS_APPEND() check is only relevant
>> for upper inodes that were set with chattr +a and not to lower
>> inodes that had chattr +a before copy up.
>
> Okay.   Maybe rename ovl_may_open() to ovl_check_append_only(),
> because that what it does.

Agree. Also I can pass the inode instead of dentry.

>
> Thanks,
> Miklos
>
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/super.c | 30 +++++++++++++++++++++++++++---
>>  1 file changed, 27 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index c9e70d3..13806b8 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -49,11 +49,30 @@ static void ovl_dentry_release(struct dentry *dentry)
>>         }
>>  }
>>
>> +static int ovl_may_open(struct dentry *dentry, int flag)
>> +{
>> +       struct inode *inode = dentry->d_inode;
>> +
>> +       /*
>> +        * This test was moot in vfs may_open() because overlay inode does
>> +        * not have the S_APPEND flag
>> +        */
>> +       if (IS_APPEND(inode)) {
>> +               if  ((flag & O_ACCMODE) != O_RDONLY && !(flag & O_APPEND))
>> +                       return -EPERM;
>> +               if (flag & O_TRUNC)
>> +                       return -EPERM;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>  static struct dentry *ovl_d_real(struct dentry *dentry,
>>                                  const struct inode *inode,
>>                                  unsigned int open_flags)
>>  {
>>         struct dentry *real;
>> +       int err;
>>
>>         if (!d_is_reg(dentry)) {
>>                 if (!inode || inode == d_inode(dentry))
>> @@ -65,15 +84,20 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>>                 return dentry;
>>
>>         if (open_flags) {
>> -               int err = ovl_open_maybe_copy_up(dentry, open_flags);
>> -
>> +               err = ovl_open_maybe_copy_up(dentry, open_flags);
>>                 if (err)
>>                         return ERR_PTR(err);
>>         }
>>
>>         real = ovl_dentry_upper(dentry);
>> -       if (real && (!inode || inode == d_inode(real)))
>> +       if (real && (!inode || inode == d_inode(real))) {
>> +               if (!inode) {
>> +                       err = ovl_may_open(real, open_flags);
>> +                       if (err)
>> +                               return ERR_PTR(err);
>> +               }
>>                 return real;
>> +       }
>>
>>         real = ovl_dentry_lower(dentry);
>>         if (!real)
>> --
>> 2.7.4
>>
