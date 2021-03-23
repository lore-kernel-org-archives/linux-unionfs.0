Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0B4C433DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 23 Mar 2021 13:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E9B5619BA
	for <linux-unionfs@archiver.kernel.org>; Tue, 23 Mar 2021 13:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhCWNU0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 09:20:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51702 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhCWNTr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Mar 2021 09:19:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NDJjc5091274;
        Tue, 23 Mar 2021 13:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=5oxBcYZibWT+wM2k0NfcD3Fc24P48iYCKq/0ag727Ok=;
 b=uNVBNRwUXWr7KaW3y86hM+mDrcljaxQv7Qg9Vx6K+f3xPKBA0GuGyucXFyghIqBac21O
 2S4KCzgQDGuRJvqKkxgvFl0t3cWplG1OE4tY9rcEkkA0uv5/kd3f5905h03gSR/P+tZE
 M8iH55pBiZ9n3O8CnhYIE1wdOhBzx4xEUBTS5vbBRIn6h5ymEEKIngG2Yr888/qdl5w3
 xDXq9SVnkubGpBOyJVWNfO5wcNrrTazFKkBCV0b7K27pTpZKhXbbECq8l67xNKo9n/wf
 kZi+rfPW4U9MI7dh4QW/Q/hfEJRvB5DQxGE2ZUuJb/K5o855eEg42ceYEXWwWdtTs+wX 2g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mex2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 13:19:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NDF80D034369;
        Tue, 23 Mar 2021 13:19:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 37dtmpg012-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 13:19:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12NDJgFA026847;
        Tue, 23 Mar 2021 13:19:42 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Mar 2021 06:19:41 -0700
Date:   Tue, 23 Mar 2021 16:19:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ovl: fix missing revert_creds() on error path
Message-ID: <YFnq5wHUQgnw4Rga@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230097
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230098
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Smatch complains about missing that the ovl_override_creds() doesn't
have a matching revert_creds() if the dentry is disconnected.  Fix this
by moving the ovl_override_creds() until after the disconnected check.

Fixes: aa3ff3c152ff ("ovl: copy up of disconnected dentries")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/overlayfs/copy_up.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0b2891c6c71e..2846b943e80c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -932,7 +932,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 {
 	int err = 0;
-	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
+	const struct cred *old_cred;
 	bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);
 
 	/*
@@ -943,6 +943,7 @@ static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	if (WARN_ON(disconnected && d_is_dir(dentry)))
 		return -EIO;
 
+	old_cred = ovl_override_creds(dentry->d_sb);
 	while (!err) {
 		struct dentry *next;
 		struct dentry *parent = NULL;
-- 
2.30.2

