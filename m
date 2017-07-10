From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] ovl: introduce the inodes index dir feature
Date: Mon, 10 Jul 2017 17:16:11 +0300
Message-ID: <20170710141611.wlz2rsoul4v43bi6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18188 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932284AbdGJOQV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 10 Jul 2017 10:16:21 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org

Hello Amir Goldstein,

The patch 02bcd1577400: "ovl: introduce the inodes index dir feature"
from Jun 21, 2017, leads to the following static checker warning:

	fs/overlayfs/super.c:1062 ovl_fill_super()
	warn: 'ufs->indexdir' isn't an ERR_PTR

fs/overlayfs/super.c
  1050          if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
  1051                  /* Verify lower root is upper root origin */
  1052                  err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
  1053                                          stack[0].dentry, false, true);
  1054                  if (err) {
  1055                          pr_err("overlayfs: failed to verify upper root origin\n");
  1056                          goto out_put_lower_mnt;
  1057                  }
  1058  
  1059                  ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
  1060                                                     OVL_INDEXDIR_NAME, true);
  1061                  err = PTR_ERR(ufs->indexdir);
  1062                  if (IS_ERR(ufs->indexdir))
  1063                          goto out_put_lower_mnt;
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This hunk isn't needed any more now that ovl_workdir_create() doesn't
return error pointers.

  1064  
  1065                  if (ufs->indexdir) {
                            ^^^^^^^^^^^^^
We check for NULL here so the code so that's OK except what do we want to
set the error code to if ovl_workdir_create() fails?  Right now it's
set to a random pointer casted to int.

  1066                          /* Verify upper root is index dir origin */
  1067                          err = ovl_verify_origin(ufs->indexdir, ufs->upper_mnt,
  1068                                                  upperpath.dentry, true, true);
  1069                          if (err)
  1070                                  pr_err("overlayfs: failed to verify index dir origin\n");
  1071  
  1072                          /* Cleanup bad/stale/orphan index entries */
  1073                          if (!err)
  1074                                  err = ovl_indexdir_cleanup(ufs->indexdir,
  1075                                                             ufs->upper_mnt,
  1076                                                             stack, numlower);
  1077                  }
  1078                  if (err || !ufs->indexdir)
  1079                          pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
  1080                  if (err)
  1081                          goto out_put_indexdir;

regards,
dan carpenter
