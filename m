From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4] ovl: lockdep annotate of nested stacked overlayfs
 inode lock
Date: Wed, 8 Feb 2017 09:42:58 +0200
Message-ID: <CAOQ4uxjOePL4zEhtDZG634MkkKvrP3AvYwnv_78EWo2ZVBKgGQ@mail.gmail.com>
References: <1484129266-8968-1-git-send-email-amir73il@gmail.com> <CAOQ4uxhy_4ymrya5AMZ3AvFU0t4u+ytV6QOcAB9oriiAwNuCSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:36541 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932344AbdBHHnA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Feb 2017 02:43:00 -0500
Received: by mail-ot0-f195.google.com with SMTP id 36so17135562otx.3
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Feb 2017 23:42:59 -0800 (PST)
In-Reply-To: <CAOQ4uxhy_4ymrya5AMZ3AvFU0t4u+ytV6QOcAB9oriiAwNuCSg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On Tue, Jan 31, 2017 at 9:15 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 11, 2017 at 12:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> An overlayfs instance can be the lower layer of another overlayfs
>> instance. This setup triggers a lockdep splat of possible recursive
>> locking of sb->s_type->i_mutex_key in iterate_dir(). Trimmed snip:
>>
>>  [ INFO: possible recursive locking detected ]
>>  bash/2468 is trying to acquire lock:
>>   &sb->s_type->i_mutex_key#14, at: iterate_dir+0x7d/0x15c
>>  but task is already holding lock:
>>   &sb->s_type->i_mutex_key#14, at: iterate_dir+0x7d/0x15c
>>
>> One problem observed with this splat is that ovl_new_inode()
>> does not call lockdep_annotate_inode_mutex_key() to annotate
>> the dir inode lock as &sb->s_type->i_mutex_dir_key like other
>> fs do.
>>
>> The other problem is that the 2 nested levels of overlayfs inode
>> lock are annotated using the same key, which is the cause of the
>> false positive lockdep warning.
>>
>> Fix this by annotating overlayfs inode lock in ovl_fill_inode()
>> according to stack level of the super block instance and use
>> different key for dir vs. non-dir like other fs do.
>>
>> Here is an edited snip from /proc/lockdep_chains after
>> iterate_dir() of nested overlayfs:
>>
>>  [...] &ovl_i_mutex_dir_key[depth]   (stack_depth=2)
>>  [...] &ovl_i_mutex_dir_key[depth]#2 (stack_depth=1)
>>  [...] &type->i_mutex_dir_key        (stack_depth=0)
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/inode.c | 38 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>
>> v4:
>> - further simplify by removing unneeded ofs->nested
>>
>
> Miklos,
>
> This patch version addresses your review comments from previous merge cycle
> and it has zero impact without CONFIG_LOCKDEP as you requested.
>

Ping.

Would you mind queuing this one as well for 4.11?

Thanks,
Amir.

>
>> v3:
>> - discard different annotation for nesting level 0
>> - compile away without CONFIG_LOCKDEP
>>
>> v2:
>> - specific implementation in overlayfs
>>
>> v1:
>> - generic implemetnation in vfs
>>
>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>> index 08643ac..b954622 100644
>> --- a/fs/overlayfs/inode.c
>> +++ b/fs/overlayfs/inode.c
>> @@ -301,6 +301,42 @@ static const struct inode_operations ovl_symlink_inode_operations = {
>>         .update_time    = ovl_update_time,
>>  };
>>
>> +/*
>> + * It is possible to stack overlayfs instance on top of another
>> + * overlayfs instance as lower layer. We need to annonate the
>> + * stackable i_mutex locks according to stack level of the super
>> + * block instance. An overlayfs instance can never be in stack
>> + * depth 0 (there is always a real fs below it).  An overlayfs
>> + * inode lock will use the lockdep annotaion ovl_i_mutex_key[depth].
>> + *
>> + * For example, here is a snip from /proc/lockdep_chains after
>> + * dir_iterate of nested overlayfs:
>> + *
>> + * [...] &ovl_i_mutex_dir_key[depth]   (stack_depth=2)
>> + * [...] &ovl_i_mutex_dir_key[depth]#2 (stack_depth=1)
>> + * [...] &type->i_mutex_dir_key        (stack_depth=0)
>> + */
>> +
>> +static struct lock_class_key ovl_i_mutex_key[FILESYSTEM_MAX_STACK_DEPTH];
>> +static struct lock_class_key ovl_i_mutex_dir_key[FILESYSTEM_MAX_STACK_DEPTH];
>> +
>> +static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
>> +{
>> +#ifdef CONFIG_LOCKDEP
>> +       int depth = inode->i_sb->s_stack_depth - 1;
>> +
>> +       if (WARN_ON_ONCE(depth < 0))
>> +               depth = 0;
>> +
>> +       if (S_ISDIR(inode->i_mode))
>> +               lockdep_set_class(&inode->i_rwsem,
>> +                                 &ovl_i_mutex_dir_key[depth]);
>> +       else
>> +               lockdep_set_class(&inode->i_rwsem,
>> +                                 &ovl_i_mutex_key[depth]);
>> +#endif
>> +}
>> +
>>  static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
>>  {
>>         inode->i_ino = get_next_ino();
>> @@ -310,6 +346,8 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
>>         inode->i_acl = inode->i_default_acl = ACL_DONT_CACHE;
>>  #endif
>>
>> +       ovl_lockdep_annotate_inode_mutex_key(inode);
>> +
>>         switch (mode & S_IFMT) {
>>         case S_IFREG:
>>                 inode->i_op = &ovl_file_inode_operations;
>> --
>> 2.7.4
>>
