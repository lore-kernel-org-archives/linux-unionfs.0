From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: two questiones about overlayfs
Date: Tue, 12 Sep 2017 09:07:46 +0800
Message-ID: <b3c2414a-8d60-7436-3ae8-db5f6a7f8766@huawei.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxgshQQcXmt5arJTdmACo2=agViFtTDGJ3kMxPbgX-QQMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:6027 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdILBIu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Sep 2017 21:08:50 -0400
In-Reply-To: <CAOQ4uxgshQQcXmt5arJTdmACo2=agViFtTDGJ3kMxPbgX-QQMw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/9/11 21:34, Amir Goldstein Wrote:
> On Mon, Aug 7, 2017 at 10:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hi,all:
>> I found two problemes about overlayfs, please let me know what you think:
>>
>> 1. Cannot update upper dir's access time.
>> Reproduce:
>> # mkdir lower upper worker merger
>> # mkdir upper/dir
>> # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
>> # ls mrger/dir
>> # stat mrger/dir
>>   Access: 2017-08-07 11:03:56.364771584 -0400
>>   Modify: 2017-08-07 11:01:52.319771584 -0400
>>   Change: 2017-08-07 11:01:52.319771584 -0400
>> # touch mrger/dir/aa
>> # stat mrger/dir
>>   Access: 2017-08-07 11:03:56.364771584 -0400
>>   Modify: 2017-08-07 11:05:33.969771584 -0400
>>   Change: 2017-08-07 11:05:33.969771584 -0400
>> # ls mrger/dir
>> # stat mrger/dir
>>   Access: 2017-08-07 11:03:56.364771584 -0400
>>   Modify: 2017-08-07 11:05:33.969771584 -0400
>>   Change: 2017-08-07 11:05:33.969771584 -0400
>>
>> I find the reason of this problem is in update_ovl_inode_times():
>> (598e3c8f7 "vfs: update ovl inode before relatime check")
>>
>> static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
>>                                bool rcu)
>> {
>>         if (!rcu) {
>>                 struct inode *realinode = d_real_inode(dentry);
>>
>>         *d_real_inode() cannot get dir's real inode, so i_mtime always equal to i_ctime*
>>         *an not updated*
>>
>>                 if (unlikely(inode != realinode) &&
>>                     (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
>>                      !timespec_equal(&inode->i_ctime, &realinode->i_ctime))) {
>>                         inode->i_mtime = realinode->i_mtime;
>>                         inode->i_ctime = realinode->i_ctime;
>>                 }
>>         }
>> }
>>
>> 2. Chattr will modify lower file's attributes directly.
>> Reproduce:
>> # mkdir lower upper worker merger
>> # touch lower/aa
>> # lsattr -p lower/aa
>>     0 --------------e---- lower/aa
>> # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
>> # chattr -p 123 merger/aa             #set project id
>> # lsattr -p lower/aa
>>   123 --------------e---- lower/aa
>>
>> If we try to set "immutable" or any other attributes, the result are consistent.
>> Because chattr open file in RDONLY mode, so it will not trigger copyup, and then,
>> FS_IOC_SETFLAGS ioctl will get the lower inode and modify it. By the way,
>> ovl's directory not support ioctl now, so we fail to change dir's attributes.
>>
>> Do you think these two "problemes" need to fix or should avoid ?
>>
> 
> ZhangYi,
> 
> Now that fixes for the 2 issues you reported are in overlayfs-next,
> could you send those 2 reproducers as xfstests?
>

Yes, I saw the patches and looks good to me. I will send those two reproducers soon, thanks.

Thanks,
ZhangYi.
