From: cgxu <cgxu@mykernel.net>
Subject: Re: [PATCH] ovl: Sync upper dirty data when sync overlayfs
Date: Tue, 28 Nov 2017 16:18:29 +0800
Message-ID: <0DEF5E95-D6C6-4F2C-9710-C4DC8BB14691@mykernel.net>
References: <1511844026-12765-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxiL8vdkcTSGnqGKtH1AVaZ+W0LcaTaoi6mifGjhq48Ljg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtpbg299.qq.com ([184.105.67.99]:60393 "EHLO smtpbg299.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdK1ISk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 03:18:40 -0500
In-Reply-To: <CAOQ4uxiL8vdkcTSGnqGKtH1AVaZ+W0LcaTaoi6mifGjhq48Ljg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Suyue <suyue@meili-inc.com>


> 在 2017年11月28日，下午2:47，Amir Goldstein <amir73il@gmail.com> 写道：
> 
> On Tue, Nov 28, 2017 at 6:40 AM, Chengguang Xu <cgxu@mykernel.net> wrote:
>> Executes filesystem sync or umount on overlayfs, dirty data does not be synced as expected on upper filesystem.
>> This patch fixes sync filesystem method to keep data consistency for overlayfs.
>> 
>> Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
>> ---
>> fs/overlayfs/super.c | 24 ++++++++++++++++++++----
>> 1 file changed, 20 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index f5738e9..9c54345 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -17,6 +17,7 @@
>> #include <linux/statfs.h>
>> #include <linux/seq_file.h>
>> #include <linux/posix_acl_xattr.h>
>> +#include <linux/writeback.h>
>> #include "overlayfs.h"
>> #include "ovl_entry.h"
>> 
>> @@ -231,6 +232,7 @@ static void ovl_put_super(struct super_block *sb)
>>        kfree(ufs);
>> }
>> 
>> +/* Sync real dirty inodes in upper filesystem (if it exists) */
>> static int ovl_sync_fs(struct super_block *sb, int wait)
>> {
>>        struct ovl_fs *ufs = sb->s_fs_info;
>> @@ -240,12 +242,26 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>>        if (!ufs->upper_mnt)
>>                return 0;
>>        upper_sb = ufs->upper_mnt->mnt_sb;
>> -       if (!upper_sb->s_op->sync_fs)
>> -               return 0;
>> 
>> -       /* real inodes have already been synced by sync_filesystem(ovl_sb) */
>>        down_read(&upper_sb->s_umount);
>> -       ret = upper_sb->s_op->sync_fs(upper_sb, wait);
>> +       if (wait)
>> +               sync_inodes_sb(upper_sb);
>> +       else
>> +               writeback_inodes_sb(upper_sb, WB_REASON_SYNC);
>> +
>> +       if (upper_sb->s_op->sync_fs)
>> +               upper_sb->s_op->sync_fs(upper_sb, wait);
>> +
>> +       if (!upper_sb->s_bdev) {
>> +               up_read(&upper_sb->s_umount);
>> +               return 0;
>> +       }
>> +
>> +       if (wait)
>> +               ret = filemap_write_and_wait(upper_sb->s_bdev->bd_inode->i_mapping);
>> +       else
>> +               ret = filemap_flush(upper_sb->s_bdev->bd_inode->i_mapping);
>> +
>>        up_read(&upper_sb->s_umount);
>>        return ret;
>> }
> 
> 
> Unless I am missing something subtle here, you should export vfs
> __sync_filesystem and call it from here instead of duplicating it.
> Any technical reason not to do it?
> 

Actually, not a technical reason. How about below modification?
If it looks good I’ll send patch on new mail thread.


diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f5738e9..736f04d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -231,6 +231,7 @@ static void ovl_put_super(struct super_block *sb)
        kfree(ufs);
 }

+/* Sync real dirty inodes in upper filesystem (if it exists) */
 static int ovl_sync_fs(struct super_block *sb, int wait)
 {
        struct ovl_fs *ufs = sb->s_fs_info;
@@ -240,12 +241,9 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
        if (!ufs->upper_mnt)
                return 0;
        upper_sb = ufs->upper_mnt->mnt_sb;
-       if (!upper_sb->s_op->sync_fs)
-               return 0;

-       /* real inodes have already been synced by sync_filesystem(ovl_sb) */
        down_read(&upper_sb->s_umount);
-       ret = upper_sb->s_op->sync_fs(upper_sb, wait);
+       ret = __sync_filesystem(upper_sb, wait);
        up_read(&upper_sb->s_umount);
        return ret;
 }
diff --git a/fs/sync.c b/fs/sync.c
index 83ac79a..76c913e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -28,7 +28,7 @@
  * wait == 1 case since in that case write_inode() functions do
  * sync_dirty_buffer() and thus effectively write one block at a time.
  */
-static int __sync_filesystem(struct super_block *sb, int wait)
+int __sync_filesystem(struct super_block *sb, int wait)
 {
        if (wait)
                sync_inodes_sb(sb);
@@ -39,6 +39,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
                sb->s_op->sync_fs(sb, wait);
        return __sync_blockdev(sb->s_bdev, wait);
 }
+EXPORT_SYMBOL(__sync_filesystem);

 /*
  * Write out and wait upon all dirty data associated with this
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 885266a..ef03b18 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2464,6 +2464,7 @@ static inline bool sb_is_blkdev_sb(struct super_block *sb)
 }
 #endif
 extern int sync_filesystem(struct super_block *);
+extern int __sync_filesystem(struct super_block *, int);
 extern const struct file_operations def_blk_fops;
 extern const struct file_operations def_chr_fops;
 #ifdef CONFIG_BLOCK


> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
