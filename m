Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfLMKiF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Dec 2019 05:38:05 -0500
Date: Fri, 13 Dec 2019 13:37:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ovl: make sure that real fid is 32bit aligned in memory
Message-ID: <20191213103705.iurz35cawvp6w46w@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hello Amir Goldstein,

This is a semi-automatic email about new static checker warnings.

The patch cbe7fba8edfc: "ovl: make sure that real fid is 32bit 
aligned in memory" from Nov 15, 2019, leads to the following Smatch 
complaint:

    fs/overlayfs/copy_up.c:338 ovl_set_origin()
     warn: variable dereferenced before check 'fh' (see line 337)

fs/overlayfs/copy_up.c
   336		 */
   337		err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh->buf,
                                                                          ^^^^^^^
The patch adds an unconditional dereference

   338					 fh ? fh->fb.len : 0, 0);
                                         ^^
but "fh" can be NULL.

   339		kfree(fh);
   340	

regards,
dan carpenter
