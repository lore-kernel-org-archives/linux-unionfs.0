From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: two questiones about overlayfs
Date: Mon, 7 Aug 2017 15:57:17 +0800
Message-ID: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3013 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752349AbdHGH64 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Aug 2017 03:58:56 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, Amir Goldstein <amir73il@gmail.com>, miaoxie@huawei.com

Hi,all:
I found two problemes about overlayfs, please let me know what you think:

1. Cannot update upper dir's access time.
Reproduce:
# mkdir lower upper worker merger
# mkdir upper/dir
# mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
# ls mrger/dir
# stat mrger/dir
  Access: 2017-08-07 11:03:56.364771584 -0400
  Modify: 2017-08-07 11:01:52.319771584 -0400
  Change: 2017-08-07 11:01:52.319771584 -0400
# touch mrger/dir/aa
# stat mrger/dir
  Access: 2017-08-07 11:03:56.364771584 -0400
  Modify: 2017-08-07 11:05:33.969771584 -0400
  Change: 2017-08-07 11:05:33.969771584 -0400
# ls mrger/dir
# stat mrger/dir
  Access: 2017-08-07 11:03:56.364771584 -0400
  Modify: 2017-08-07 11:05:33.969771584 -0400
  Change: 2017-08-07 11:05:33.969771584 -0400

I find the reason of this problem is in update_ovl_inode_times():
(598e3c8f7 "vfs: update ovl inode before relatime check")

static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
			       bool rcu)
{
	if (!rcu) {
		struct inode *realinode = d_real_inode(dentry);

	*d_real_inode() cannot get dir's real inode, so i_mtime always equal to i_ctime*
	*an not updated*

		if (unlikely(inode != realinode) &&
		    (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
		     !timespec_equal(&inode->i_ctime, &realinode->i_ctime))) {
			inode->i_mtime = realinode->i_mtime;
			inode->i_ctime = realinode->i_ctime;
		}
	}
}

2. Chattr will modify lower file's attributes directly.
Reproduce:
# mkdir lower upper worker merger
# touch lower/aa
# lsattr -p lower/aa
    0 --------------e---- lower/aa
# mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
# chattr -p 123 merger/aa             #set project id
# lsattr -p lower/aa
  123 --------------e---- lower/aa

If we try to set "immutable" or any other attributes, the result are consistent.
Because chattr open file in RDONLY mode, so it will not trigger copyup, and then,
FS_IOC_SETFLAGS ioctl will get the lower inode and modify it. By the way,
ovl's directory not support ioctl now, so we fail to change dir's attributes.

Do you think these two "problemes" need to fix or should avoid ?

Thanks,
ZhangYi.
