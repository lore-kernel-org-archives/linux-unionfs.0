Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfE2Kba (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 May 2019 06:31:30 -0400
Date: Wed, 29 May 2019 13:31:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ovl: detect overlapping layers
Message-ID: <20190529103120.GA15021@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hello Amir Goldstein,

The patch 0e7f2cccb42a: "ovl: detect overlapping layers" from Apr 18,
2019, leads to the following static checker warning:

	fs/overlayfs/super.c:998 ovl_setup_trap()
	warn: passing a valid pointer to 'PTR_ERR'

fs/overlayfs/super.c
   991  static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
   992                            struct inode **ptrap, const char *name)
   993  {
   994          struct inode *trap;
   995          int err;
   996  
   997          trap = ovl_get_trap_inode(sb, dir);
   998          err = PTR_ERR(trap);
   999          if (IS_ERR(trap) && err == -ELOOP) {
  1000                  pr_err("overlayfs: conflicting %s path\n", name);
  1001                  return err;
  1002          }
  1003  
  1004          *ptrap = trap;
  1005          return 0;
  1006  }

The warning message is wrong but the code is also wrong.  The
ovl_get_trap_inode() can return ERR_PTR(-ENOMEM) and that would lead to
and Oops when we try to call iput() on it.

regards,
dan carpenter
