From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 15/28] ovl: Open file with data except for the case of fsync
Date: Wed, 30 May 2018 17:12:16 +0200
Message-ID: <CAJfpegvLcFgFi7aMiJs=xotEMKNNDy7rXdms08Mx3c5G37OJgw@mail.gmail.com>
References: <20180529144612.16675-1-mszeredi@redhat.com> <20180529144612.16675-16-mszeredi@redhat.com>
 <20180530143044.GB2717@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530143044.GB2717@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, May 30, 2018 at 4:30 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, May 29, 2018 at 04:45:59PM +0200, Miklos Szeredi wrote:
>> From: Vivek Goyal <vgoyal@redhat.com>
>>
>> ovl_open() should open file which contains data and not open metacopy
>> inode.  With the introduction of metacopy inodes, with current
>> implementaion we will end up opening metacopy inode as well.
>>
>> But there can be certain circumstances like ovl_fsync() where we want to
>> allow opening a metacopy inode instead.
>>
>> Hence, change ovl_open_realfile() and add _ovl_open_real() and add extra
>> parameter which specifies whether to allow opening metacopy inode or not.
>> If this parameter is false, we look for data inode and open that.
>>
>> This should allow covering both the cases.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> ---
>>  fs/overlayfs/file.c | 39 ++++++++++++++++++++++++++++++---------
>>  1 file changed, 30 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> index 266692ce9a9a..c7738ef492c8 100644
>> --- a/fs/overlayfs/file.c
>> +++ b/fs/overlayfs/file.c
>> @@ -14,11 +14,20 @@
>>  #include <linux/uio.h>
>>  #include "overlayfs.h"
>>
>> -static struct file *ovl_open_realfile(const struct file *file)
>> +static char ovl_whatisit(struct inode *inode, struct inode *realinode)
>> +{
>> +     if (realinode != ovl_inode_upper(inode))
>> +             return 'l';
>> +     if (ovl_has_upperdata(inode))
>> +             return 'u';
>> +     else
>> +             return 'm';
>> +}
>> +
>> +static struct file *ovl_open_realfile(const struct file *file,
>> +                                   struct inode *realinode)
>>  {
>>       struct inode *inode = file_inode(file);
>> -     struct inode *upperinode = ovl_inode_upper(inode);
>> -     struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
>>       struct file *realfile;
>>       const struct cred *old_cred;
>>
>> @@ -28,7 +37,7 @@ static struct file *ovl_open_realfile(const struct file *file)
>>       revert_creds(old_cred);
>>
>>       pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
>> -              file, file, upperinode ? 'u' : 'l', file->f_flags,
>> +              file, file, ovl_whatisit(inode, realinode), file->f_flags,
>>                realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
>>
>>       return realfile;
>> @@ -72,17 +81,24 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
>>       return 0;
>>  }
>>
>> -static int ovl_real_fdget(const struct file *file, struct fd *real)
>> +static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
>> +                            bool allow_meta)
>>  {
>>       struct inode *inode = file_inode(file);
>> +     struct inode *realinode;
>>
>>       real->flags = 0;
>>       real->file = file->private_data;
>>
>> +     if (allow_meta)
>> +             realinode = ovl_inode_real(inode);
>> +     else
>> +             realinode = ovl_inode_realdata(inode);
>> +
>>       /* Has it been copied up since we'd opened it? */
>> -     if (unlikely(file_inode(real->file) != ovl_inode_real(inode))) {
>> +     if (unlikely(file_inode(real->file) != realinode)) {
>>               real->flags = FDPUT_FPUT;
>> -             real->file = ovl_open_realfile(file);
>> +             real->file = ovl_open_realfile(file, realinode);
>>
>>               return PTR_ERR_OR_ZERO(real->file);
>>       }
>> @@ -94,6 +110,11 @@ static int ovl_real_fdget(const struct file *file, struct fd *real)
>>       return 0;
>>  }
>>
>> +static int ovl_real_fdget(const struct file *file, struct fd *real)
>> +{
>> +     return ovl_real_fdget_meta(file, real, false);
>> +}
>> +
>>  static int ovl_open(struct inode *inode, struct file *file)
>>  {
>>       struct dentry *dentry = file_dentry(file);
>> @@ -107,7 +128,7 @@ static int ovl_open(struct inode *inode, struct file *file)
>>       /* No longer need these flags, so don't pass them on to underlying fs */
>>       file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
>>
>> -     realfile = ovl_open_realfile(file);
>> +     realfile = ovl_open_realfile(file, ovl_inode_real(file_inode(file)));

That was meant to be

+     realfile = ovl_open_realfile(file, ovl_inode_realdata(file_inode(file)));

Is that correct?

> Hmm...so there have been some changes in this patch. My original intention
> was that to always open data inode (lower/upper) in ovl_open(). So if upper
> inode is a metacopy only, I will open lower inode instead.
>
> But new logic seems to be to always open real inode (that means upper
> metacopy inode as well). And that means that later when read happens
> on the file we will end up opening lower file, read data and close
> lower file.
>
> I am concerned a bit if there are performance implications to this.
> This will be hot path for containers.

Right.   Unfortunately not detected with automatic testing...

Thanks for spotting!

Miklos
