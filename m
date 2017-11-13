From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ovl: factor out ovl_free_fs() helper
Date: Mon, 13 Nov 2017 12:05:46 +0300
Message-ID: <20171113090546.jdkiaxu3sidsawxi@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16512 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdKMJG0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Nov 2017 04:06:26 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: mszeredi@redhat.com
Cc: linux-unionfs@vger.kernel.org

Hello Miklos Szeredi,

The patch df6c653fd465: "ovl: factor out ovl_free_fs() helper" from
Nov 9, 2017, leads to the following static checker warning:

	fs/overlayfs/super.c:1260 ovl_fill_super()
	error: we previously assumed 'ofs' could be null (see line 1156)

fs/overlayfs/super.c
  1145  static int ovl_fill_super(struct super_block *sb, void *data, int silent)
  1146  {
  1147          struct path upperpath = { };
  1148          struct dentry *root_dentry;
  1149          struct ovl_entry *oe;
  1150          struct ovl_fs *ofs;
  1151          struct cred *cred;
  1152          int err;
  1153  
  1154          err = -ENOMEM;
  1155          ofs = kzalloc(sizeof(struct ovl_fs), GFP_KERNEL);
  1156          if (!ofs)
                     ^^^
kzalloc() fails

  1157                  goto out_err;
  1158  
  1159          ofs->creator_cred = cred = prepare_creds();
  1160          if (!cred)
  1161                  goto out_err;
  1162  

[ snip ]


  1252  
  1253          return 0;
  1254  
  1255  out_free_oe:
  1256          ovl_entry_stack_free(oe);
  1257          kfree(oe);
  1258  out_err:
  1259          path_put(&upperpath);
  1260          ovl_free_fs(ofs);
                            ^^^
it gets dereferenced inside the function.  The path_put() is a no-op at
that point.

  1261  
  1262          return err;
  1263  }

regards,
dan carpenter
