From: Atom2 <ariel.atom2@web2web.at>
Subject: Re: stat inconsistency with overlayfs
Date: Mon, 02 Mar 2015 21:45:54 +0100
Message-ID: <54F4CC02.3040808@web2web.at>
References: <54E779BB.8030209@web2web.at> <54EEAE3A.5000006@huawei.com> <37851744.28042779.1424933137550.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from grace.univie.ac.at ([131.130.3.115]:58632 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbCBUp4 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 2 Mar 2015 15:45:56 -0500
In-Reply-To: <37851744.28042779.1424933137550.JavaMail.zimbra@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Xu Wang <xuw@redhat.com>, hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

Hi Xu,
thanks for your follow-up.
Am 26.02.15 um 07:45 schrieb Xu Wang:
> Hi, Hu, Atom2,
>
>> I don't have the Overlayfs code on 3.11 or 3.13. I've lookup the v11
>> code in Miklos's git tree:
> Fortunately I got the overlay fs code of kernel V3.18, which is mostly
> same to v11 code in Miklos's git.
>
> 135 static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
> 136              struct kstat *stat)
> 137 {
> 138     int err;
> 139     enum ovl_path_type type;
> 140     struct path realpath;
> 141
> 142     type = ovl_path_real(dentry, &realpath);
> 143     err = vfs_getattr(&realpath, stat);
> 144     if (err)
> 145         return err;
> 146
> 147     stat->dev = dentry->d_sb->s_dev;
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ here set dev number as Hu mentioned
> 148     stat->ino = dentry->d_inode->i_ino;
> 149
> 150     /*
> 151      * It's probably not worth it to count subdirs to get the
> 152      * correct link count.  nlink=1 seems to pacify 'find' and
> 153      * other utilities.
> 154      */
> 155     if (type == OVL_PATH_MERGE)
> 156         stat->nlink = 1;
> 157
> 158     return 0;
> 159 }
>
> And the d_sb->s_dev is coming from the super_block of overlayfs, which is fake.
> The super block s_dev is initialized by the call trace
> "mount_nodev->set_anon_super-->get_anon_bdev".
>
> Either the dir exists in lower or exists in upper, the overlay fs fakes it exits in
> overlay, which holds the fake device number.
I see what you are saying and code-wise that seems to be the cause of 
the behaviour I am seeing. I am, however, still not convinced at all 
that this is the correct/to be expected behaviour.

Giving this some further thought, might this not create more issues 
further down the line: In my (granted: limited) understanding the 
device/i-number combination must be unique across all mounted 
file-systems. Now does this also mean that the i-number is faked as 
well? In other words what is going to happen if the i-number of the 
directory residing in the upperdir (but wrongly attributed to the 
lowerdir) is identical to an i-number of another existing entry in the 
lowerdir?

Finally, stat, as I understand it, amongst other pieces of information 
also provides information about the device an entry resides on and that 
information, IMHO, simply is plain wrong for directories only existing 
on the upperdir.

Thanks Atom2
