From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] fs: overlayfs: override creds with the ones from the
 superblock mounter (fwd)
Date: Thu, 7 Apr 2016 15:36:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1604071534500.3169@hadrien>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:65019
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbcDGNgk (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 7 Apr 2016 09:36:40 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Antonio Murdaca <amurdaca@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, vgoyal@redhat.com, ebiederm@redhat.com, seth.forshee@canonical.com, luis.henriques@canonical.com, kbuild-all@01.org

The goto out_free_oe on line 1119 looks problematic.

julia

---------- Forwarded message ----------
Date: Thu, 7 Apr 2016 21:31:44 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] fs: overlayfs: override creds with the ones from the
    superblock mounter

Hi Antonio,

[auto build test WARNING on v4.6-rc2]
[also build test WARNING on next-20160407]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Antonio-Murdaca/fs-overlayfs-override-creds-with-the-ones-from-the-superblock-mounter/20160407-205959
:::::: branch date: 32 minutes ago
:::::: commit date: 32 minutes ago

>> fs/overlayfs/super.c:1142:7-15: ERROR: reference preceded by free on line 1103
   fs/overlayfs/super.c:1139:12-17: ERROR: reference preceded by free on line 1110
   fs/overlayfs/super.c:1140:7-12: ERROR: reference preceded by free on line 1110

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout c9c3d05e9c7164d4203b022a3800462beda044b6
vim +1142 fs/overlayfs/super.c

3b7a9a24 Miklos Szeredi        2014-12-13  1097  		goto out_free_oe;
e9be9d5e Miklos Szeredi        2014-10-24  1098
e9be9d5e Miklos Szeredi        2014-10-24  1099  	mntput(upperpath.mnt);
a78d9f0d Miklos Szeredi        2014-12-13  1100  	for (i = 0; i < numlower; i++)
a78d9f0d Miklos Szeredi        2014-12-13  1101  		mntput(stack[i].mnt);
e9be9d5e Miklos Szeredi        2014-10-24  1102  	path_put(&workpath);
a78d9f0d Miklos Szeredi        2014-12-13 @1103  	kfree(lowertmp);
e9be9d5e Miklos Szeredi        2014-10-24  1104
e9be9d5e Miklos Szeredi        2014-10-24  1105  	oe->__upperdentry = upperpath.dentry;
a78d9f0d Miklos Szeredi        2014-12-13  1106  	for (i = 0; i < numlower; i++) {
a78d9f0d Miklos Szeredi        2014-12-13  1107  		oe->lowerstack[i].dentry = stack[i].dentry;
a78d9f0d Miklos Szeredi        2014-12-13  1108  		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
a78d9f0d Miklos Szeredi        2014-12-13  1109  	}
0f95502a Konstantin Khlebnikov 2015-08-24  1110  	kfree(stack);
e9be9d5e Miklos Szeredi        2014-10-24  1111
e9be9d5e Miklos Szeredi        2014-10-24  1112  	root_dentry->d_fsdata = oe;
e9be9d5e Miklos Szeredi        2014-10-24  1113
ed06e069 Miklos Szeredi        2015-12-09  1114  	ovl_copyattr(ovl_dentry_real(root_dentry)->d_inode,
ed06e069 Miklos Szeredi        2015-12-09  1115  		     root_dentry->d_inode);
ed06e069 Miklos Szeredi        2015-12-09  1116
c9c3d05e Antonio Murdaca       2016-04-07  1117  	ufs->creator_cred = prepare_creds();
c9c3d05e Antonio Murdaca       2016-04-07  1118  	if (!ufs->creator_cred)
c9c3d05e Antonio Murdaca       2016-04-07  1119  		goto out_free_oe;
c9c3d05e Antonio Murdaca       2016-04-07  1120
cc259639 Andy Whitcroft        2014-10-24  1121  	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
e9be9d5e Miklos Szeredi        2014-10-24  1122  	sb->s_op = &ovl_super_operations;
e9be9d5e Miklos Szeredi        2014-10-24  1123  	sb->s_root = root_dentry;
e9be9d5e Miklos Szeredi        2014-10-24  1124  	sb->s_fs_info = ufs;
e9be9d5e Miklos Szeredi        2014-10-24  1125
e9be9d5e Miklos Szeredi        2014-10-24  1126  	return 0;
e9be9d5e Miklos Szeredi        2014-10-24  1127
3b7a9a24 Miklos Szeredi        2014-12-13  1128  out_free_oe:
3b7a9a24 Miklos Szeredi        2014-12-13  1129  	kfree(oe);
e9be9d5e Miklos Szeredi        2014-10-24  1130  out_put_lower_mnt:
dd662667 Miklos Szeredi        2014-12-13  1131  	for (i = 0; i < ufs->numlower; i++)
dd662667 Miklos Szeredi        2014-12-13  1132  		mntput(ufs->lower_mnt[i]);
dd662667 Miklos Szeredi        2014-12-13  1133  	kfree(ufs->lower_mnt);
3b7a9a24 Miklos Szeredi        2014-12-13  1134  out_put_workdir:
3b7a9a24 Miklos Szeredi        2014-12-13  1135  	dput(ufs->workdir);
e9be9d5e Miklos Szeredi        2014-10-24  1136  	mntput(ufs->upper_mnt);
e9be9d5e Miklos Szeredi        2014-10-24  1137  out_put_lowerpath:
a78d9f0d Miklos Szeredi        2014-12-13  1138  	for (i = 0; i < numlower; i++)
a78d9f0d Miklos Szeredi        2014-12-13  1139  		path_put(&stack[i]);
a78d9f0d Miklos Szeredi        2014-12-13  1140  	kfree(stack);
a78d9f0d Miklos Szeredi        2014-12-13  1141  out_free_lowertmp:
a78d9f0d Miklos Szeredi        2014-12-13 @1142  	kfree(lowertmp);
3b7a9a24 Miklos Szeredi        2014-12-13  1143  out_put_workpath:
3b7a9a24 Miklos Szeredi        2014-12-13  1144  	path_put(&workpath);
e9be9d5e Miklos Szeredi        2014-10-24  1145  out_put_upperpath:

:::::: The code at line 1142 was first introduced by commit
:::::: a78d9f0d5d5ca9054703376c7c23c901807ddd87 ovl: support multiple lower layers

:::::: TO: Miklos Szeredi <mszeredi@suse.cz>
:::::: CC: Miklos Szeredi <mszeredi@suse.cz>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
