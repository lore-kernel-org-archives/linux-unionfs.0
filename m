Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5AFC47247
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E092D206B8
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pEYWp2zf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgEESHq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 14:07:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgEESHq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 14:07:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045I3AKK191936;
        Tue, 5 May 2020 18:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=ScAX8vSZQvAhSmvUfxCOs1sLqUTNbne2m8bEiaGIqbs=;
 b=pEYWp2zfW3XeEMu62AA+CLp1UNvXfQUr+dnLyF1LTIO0wfP+pENi9ziGLXc6P00f1MvH
 MpFplJ6oDlZhqu46mw0iTtQW319AgdTXSSgMKKnn3l+G414+TXr0n20gk9MCHUCae9q7
 qIJ81TBrsssHpQx8w6SqRk3c6aQlsAkN3pSIsrR76j1BK+09eJnkzNI8n/wi/yXgsej7
 QARQWidjp8HjpGWEasvZKa8R8hRVfXOuAP090BI/8TvejqZs0UoFK55EPqcA8KPQx5Re
 LUbb4adVw5ceE2w11+WIvV7Nlr3uccr+Om9TPLumt8DoM6n3sOW4GRBn/UoKtOHjwQCg Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30s0tmeb0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 18:07:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045I7Ng7149147;
        Tue, 5 May 2020 18:07:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnfa1qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 18:07:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045I7eXR010109;
        Tue, 5 May 2020 18:07:41 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 11:07:40 -0700
Date:   Tue, 5 May 2020 21:07:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ovl: potential crash in ovl_fid_to_fh()
Message-ID: <20200505180734.GA47680@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj0F9V=FOUANKSATR2E==BoLr6OJMqsJe5QCbOLNR0k0A@mail.gmail.com>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050137
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The "buflen" value comes from the user and there is a potential that it
could be zero.  In do_handle_to_path() we know that "handle->handle_bytes"
is non-zero and we do:

	handle_dwords = handle->handle_bytes >> 2;

So values 1-3 become zero.  Then in ovl_fh_to_dentry() we do:

	int len = fh_len << 2;

So now len is in the "0,4-128" range and a multiple of 4.  But if
"buflen" is zero it will try to copy negative bytes when we do the
memcpy in ovl_fid_to_fh().

	memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);

And that will lead to a crash.  Thanks to Amir Goldstein for his help
with this patch.

Fixes: cbe7fba8edfc: ("ovl: make sure that real fid is 32bit aligned in memory")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/overlayfs/export.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 475c61f53f0fe..0e58213ace6d7 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -776,6 +776,9 @@ static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
 {
 	struct ovl_fh *fh;
 
+	if (buflen <= OVL_FH_WIRE_OFFSET)
+		return ERR_PTR(-EINVAL);
+
 	/* If on-wire inner fid is aligned - nothing to do */
 	if (fh_type == OVL_FILEID_V1)
 		return (struct ovl_fh *)fid;
-- 
2.26.2
