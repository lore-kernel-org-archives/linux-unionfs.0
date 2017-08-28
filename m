From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: problem about lower symlink
Date: Mon, 28 Aug 2017 12:20:02 +0800
Message-ID: <baf5c3bc-f611-797e-7f98-691d4432b63e@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:5472 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdH1EUR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Aug 2017 00:20:17 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, Amir Goldstein <amir73il@gmail.com>
Cc: miaoxie@huawei.com, yi.zhang@huawei.com

Hi all:

I notice that if the lower dir have absolute path symlink to another lower file,
the lower origin file will be modified if we do something to this symlink in merge
layer, such as chown or chmod. It can be reproduced as these steps:

$ mkdir lower upper worker merger
$ touch lower/aa
$ ln -s $(pwd)/lower/aa $(pwd)/lower/bb
$ mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
$ ls -l merger/aa
  -rw-r--r--. 1 root root  0 Aug 28 07:42 merger/aa
$ chmod 777 merger/bb
$ ls -l merger/aa
  -rwxrwxrwx. 1 root root  0 Aug 28 07:42 merger/aa


I have an idea to resolve this problem, we can do someting in ovl_get_link(). I.e. like that:

static const char *ovl_get_link(struct dentry *dentry,
				struct inode *inode,
				struct delayed_call *done)
{
	const struct cred *old_cred;
	const char *p;

	if (!dentry)
		return ERR_PTR(-ECHILD);

	old_cred = ovl_override_creds(dentry->d_sb);
	p = vfs_get_link(ovl_dentry_real(dentry), done);
	revert_creds(old_cred);

+	if (*p == '/')
+		return ovl_get_link_orig(ofs, p);

	return p;
}

In ovl_get_link_orig(), we can deal with three cases:
1) Link origin belongs to the lower layer:
   Find which lower layer it belongs to, then convert absolute path to relative
   path and return. We also can save the relative path in a string to ovl_inode,
   which can get directly next time;
2) Link origin belongs to the upper layer:
   No problem, do nothing;
3) Link origin not handled by overlayfs:
   Return ENOENT errno.

What do you think? Please let me know if you have some suggestiones.

Thanks,
ZhangYi.
