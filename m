Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFD2C433C1
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4705C6198B
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhCVMSg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:18:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53334 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhCVMSN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Mar 2021 08:18:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MCAi6X154876;
        Mon, 22 Mar 2021 12:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=VFlpEp3qOnm9ZPSR+E6nHnLXpAI5qv7w6U7UWMP7WGM=;
 b=BojyRXAMgml1MbNjV4qE0a8EMoKL3llW0UGlaKUYZk5HVQmkz8ykIHnyWUcmNMT4WKVx
 5+1C1y6M6HYDyLn/cQjAQlMbJDz6Joyn+NdEwlFIAXOssFbH2DrounIZlB4IZxkKL5ll
 7qVKnLoR7QYhlf9JLwBjlVQj7wl1cOwkAVx2hZaqYKPfOBsYR3tgGXAI+YX7TiszuttG
 emEigffoRlPqPFewSpU15TLrnEIuEs5yosSHDOUP4eBTKyZ09rdZUtotx5i6hG84l7Zm
 U+Ynql5jOO7cBZAUha7ERTKII7GKeN5tTJWAHJnZNOGhqLBXdiHHuTuwpJJidHZwqheE qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37d9pmu85j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 12:18:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MCB3KG194801;
        Mon, 22 Mar 2021 12:18:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 37dtmn53md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 12:18:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12MCI90t001220;
        Mon, 22 Mar 2021 12:18:09 GMT
Received: from mwanda (/10.175.191.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Mar 2021 05:18:09 -0700
Date:   Mon, 22 Mar 2021 15:18:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org
Subject: [bug report] ovl: copy up of disconnected dentries
Message-ID: <YFiK/GhGReGqh52w@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=709 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220090
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9930 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=649 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1011 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220090
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello Amir Goldstein,

The patch aa3ff3c152ff: "ovl: copy up of disconnected dentries" from
Oct 15, 2017, leads to the following static checker warning:

	fs/overlayfs/copy_up.c:972 ovl_copy_up_flags()
	warn: 'old_cred' not released on lines: 944.

fs/overlayfs/copy_up.c
   932  static int ovl_copy_up_flags(struct dentry *dentry, int flags)
   933  {
   934          int err = 0;
   935          const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
   936          bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);
   937  
   938          /*
   939           * With NFS export, copy up can get called for a disconnected non-dir.
   940           * In this case, we will copy up lower inode to index dir without
   941           * linking it to upper dir.
   942           */
   943          if (WARN_ON(disconnected && d_is_dir(dentry)))
   944                  return -EIO;

Should this call revert_creds(old_cred); before returning?

   945  
   946          while (!err) {
   947                  struct dentry *next;
   948                  struct dentry *parent = NULL;
   949  
   950                  if (ovl_already_copied_up(dentry, flags))
   951                          break;
   952  
   953                  next = dget(dentry);
   954                  /* find the topmost dentry not yet copied up */
   955                  for (; !disconnected;) {
   956                          parent = dget_parent(next);
   957  
   958                          if (ovl_dentry_upper(parent))
   959                                  break;
   960  
   961                          dput(next);
   962                          next = parent;
   963                  }
   964  
   965                  err = ovl_copy_up_one(parent, next, flags);
   966  
   967                  dput(parent);
   968                  dput(next);
   969          }
   970          revert_creds(old_cred);
   971  
   972          return err;
   973  }

regards,
dan carpenter
