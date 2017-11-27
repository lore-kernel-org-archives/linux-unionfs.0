From: cgxu <cgxu@mykernel.net>
Subject: Re: sync filesystem of overlayfs
Date: Mon, 27 Nov 2017 23:30:40 +0800
Message-ID: <E07939CC-AD3C-41B9-B500-A15DAEFAE981@mykernel.net>
References: <5862C310-F8B9-40AF-826D-BE867CCDA519@mykernel.net>
 <CAOQ4uxjnVajcd=0tqVYbGiTSmMhN_Pemjn3N2fhTZs4KYasV_w@mail.gmail.com>
 <771732B7-80A0-4011-BC98-9A40375A8858@mykernel.net>
 <CAOQ4uxiROew32J_Xv7bGnHxaM9iexjJ6dQSbJ1gENbCUtHi1aQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtpbg299.qq.com ([184.105.67.99]:37038 "EHLO smtpbg299.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752291AbdK0Pax (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 10:30:53 -0500
In-Reply-To: <CAOQ4uxiROew32J_Xv7bGnHxaM9iexjJ6dQSbJ1gENbCUtHi1aQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, suyue@meili-inc.com

Hi Amir

Per the previous discussion, my opinion is calling __sync_filesystem() in ovl_sync_fs()
would be better for current stage. If we pick up overlayfs’s dirty inodes we may need to
involve writeback and cgroup logics in overlayfs and put all things into sync_fs seems 
quite heavy and complex. If you agree I’ll make new patch for review.



Best Regards,
Chengguang



> 在 2017年11月27日，下午7:30，Amir Goldstein <amir73il@gmail.com> 写道：
> 
> On Mon, Nov 27, 2017 at 12:31 PM, cgxu <cgxu@mykernel.net> wrote:
>> 
>> 
>>> 在 2017年11月27日，下午4:59，Amir Goldstein <amir73il@gmail.com> 写道：
>>> 
>>> On Mon, Nov 27, 2017 at 10:08 AM, cgxu <cgxu@mykernel.net> wrote:
>>>> 
>>>> Hi,
>>>> 
>>>> Recently I found syncfs and umount could not make data consistency in overlayfs.
>>>> I did some investigations and now I know synchronization didn’t directly happen
>>>> in upperdir filesystem during these operations executed in overlayfs.
>>>> 
>>> 
>>> Can you share the method of your investigation?
>>> Maybe make it into an xfstest?
>>> You can probably use dmflakey target.
>> 
>> Testing method as below. (I tested in virtual machine)
>> 
>> 1. stop bd_writeback behavior by adjusting parameters in /proc/sys/vm/
>> 2. copy a large file to overlayfs directory and then do syncfs or umount.
>> 3. power off && power on
>> 4. compare content of files using diff.
>> 
>> and I also applied below simple quick patch (may need more check for detail) to check fixing result.
>> 
>> -----------
>> $ git diff
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 7b64d5c..3ab25a7 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -1222,11 +1222,24 @@ static struct dentry *ovl_mount(struct file_system_type *fs_type, int flags,
>>        return mount_nodev(fs_type, flags, raw_data, ovl_fill_super);
>> }
>> 
>> +static void ovl_kill_super(struct super_block *sb)
>> +{
>> +        struct ovl_fs *ufs = sb->s_fs_info;
>> +       struct super_block *real_super = ufs->upper_mnt->mnt_sb;
>> +
>> +        if (!(sb->s_flags & MS_RDONLY)) {
>> +                down_read(&real_super->s_umount);
>> +                sync_filesystem(real_super);
>> +                up_read(&real_super->s_umount);
>> +        }
>> +        kill_anon_super(sb);
>> +}
>> +
> 
> kill_anon_super() -> generic_shutdown_super() -> sync_filesystem()
> 
> So your implementation should go into ovl_sync_fs instead to cover
> other cases like freeze_super() and plain syncfs().
> 
>> static struct file_system_type ovl_fs_type = {
>>        .owner          = THIS_MODULE,
>>        .name           = "overlay",
>>        .mount          = ovl_mount,
>> -       .kill_sb        = kill_anon_super,
>> +       .kill_sb        = ovl_kill_super,
>> };
>> MODULE_ALIAS_FS("overlay");
>> 
>> diff --git a/fs/sync.c b/fs/sync.c
>> index 83ac79a..d49792c 100644
>> --- a/fs/sync.c
>> +++ b/fs/sync.c
>> @@ -161,6 +161,8 @@ void emergency_sync(void)
>>        if (!f.file)
>>                return -EBADF;
>>        sb = f.file->f_path.dentry->d_sb;
>> +       if (!(sb->s_flags & MS_RDONLY))
>> +               sb = d_real(f.file->f_path.dentry, NULL, f.file->f_flags, 0)->d_sb;
>> 
> 
> No reason to change vfs.
> sync_filesystem() calls ovl_sync_fs() where upper fs can be synced.
> 
>>        down_read(&sb->s_umount);
>>        ret = sync_filesystem(sb);
>> 
>> 
>> -----------
>> 
>> 
>>> 
>>>> I'm also confused by below comment in function ovl_sync_fs() in super.c
>>>> 
>>>> /* real inodes have already been synced by sync_filesystem(ovl_sb) */
>>>> 
>>>> In my understanding sync_filesystem(ovl_sb) can not make real inodes synced
>>>> unless delivers real superblock of upperdir filesystem to sync_filesystem().
>>>> 
>>>> I can’t make sure current implementation is by design or for some other reasons because
>>>> sync upperdir filesystem may be a little bit heavy especially in a large filesystem.
>>>> Could anyone give me a hint for this？
>>>> 
>>> 
>>> Looks like you are right.
>>> That comment I wrote is an oversight, not by design, although the concern
>>> that you raise is valid.
>>> 
>>>> If this problem needs to be fix, I’ll try to make a patch for review.
>>>> 
>>> 
>>> So the simple way would be to call __sync_filesystem() from ovl_sync_fs()
>>> instead of calling upper_sb->s_op->sync_fs(), but that would be heavy
>>> as you said.
>>> A better fix would be to iterate overlay sb inodes and flush only the dirty
>>> ovl_inode_upper() pages, before calling upper_sb->s_op->sync_fs().
>>> 
>>> I didn't look closely to see how complex that would be, so let me know what
>>> you think is best.
>> 
>> The easiest way is as you said or like quick patch above,
>> but sync_fs() seems like doing superblock related things only in most case.
>> 
> 
> It does everything that generic vfs sync_filesystem() doesn't do.
> In overlayfs case, that is syncing upper fs.
> 
>> For me maybe ideal way is define new virtual BDI for overlayfs,
>> and using that to organize dirty inodes, so that we don’t have to put much
>> effort to looking for target inodes. If this approach makes sense I’ll
>> carefully consider detail.
>> 
>> We can just fix this problem in simple way first and consider
>> better solution later because that is probably related to many complex things.
>> 
> 
> Agree. Safety first!
> 
>> I think for most people umount or sync_fs takes time is acceptable and at least
>> it is much better than data inconsistency.
>> 
> 
> Not sure about that. I heard there are use cases for containers for
> which the time
> of mount/umount matters.
> We'll have to see about that.
> 
> Thanks,
> Amir.
