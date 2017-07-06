From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ovl: hash overlay non-dir inodes by copy up origin
Date: Thu, 6 Jul 2017 12:59:08 +0300
Message-ID: <20170706095908.3v5pvcaorlafm4sv@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40093 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdGFJ7T (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2017 05:59:19 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: mszeredi@redhat.com
Cc: linux-unionfs@vger.kernel.org

Hello Miklos Szeredi,

This is a semi-automatic email about new static checker warnings.

The patch b9ac5c274b8c: "ovl: hash overlay non-dir inodes by copy up
origin" from Jul 4, 2017, leads to the following Smatch complaint:

fs/overlayfs/inode.c:603 ovl_get_inode()
	 warn: variable dereferenced before check 'lowerdentry' (see line 600)

fs/overlayfs/inode.c
   599		if (!realinode)
   600			realinode = d_inode(lowerdentry);
                                            ^^^^^^^^^^^
Old dereference.

   601	
   602		if (!S_ISDIR(realinode->i_mode) &&
   603		    (upperdentry || (lowerdentry && ovl_indexdir(dentry->d_sb)))) {
                                     ^^^^^^^^^^^
New check added here.

   604			struct inode *key = d_inode(lowerdentry ?: upperdentry);
   605			unsigned int nlink;

regards,
dan carpenter
