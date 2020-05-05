Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F90DC47247
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5CE206FA
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 18:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eOo/PYV2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgEESdl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 14:33:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgEESdl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 14:33:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045IX9kg049700;
        Tue, 5 May 2020 18:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=9h5WLf4to3NAz3nQNYHcX1SIwQbdGPPfELpgarIi+mM=;
 b=eOo/PYV2p7AmkzNkWK47hKyDOGfWlMkDyGkAMV9Tv6qJD32AQoKTPnZz+2DsxzqgaOZu
 eYvSFiDmGZ9T0yqw2GF8r28WL/fxNpXlGSXVv5H7T3T49kjgtQ3NOxJWQHzczt2MirOC
 L1e6nBuc2jnYj/x89JPf9hIlfMg8MgMTzgUjLBt7nLrxD/Sx+sl+HLbmeqB0w6EC3aF/
 YdbC11ZkRHxSgMkVLpfb5MfJMB/pv8ZgBEkjqYVRp/pyPFMU133pZ5L/OskwZN0WbAx0
 fWh/D8m2qr8IxcAS9B9mRBC1x4AuJLqI1GsbdFCDBsTGyFAqY9dkt9Q2/IjUZs2R14HZ +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tmeet8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 18:33:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045IWbil050839;
        Tue, 5 May 2020 18:33:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30sjk09k1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 18:33:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045IXbhE029511;
        Tue, 5 May 2020 18:33:37 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 11:33:36 -0700
Date:   Tue, 5 May 2020 21:33:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] ovl: potential crash in ovl_fid_to_fh()
Message-ID: <20200505183331.GA49866@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhOi0H4ecJOc6emFc+bUhepscHF8qHywJQUzr-46H3+yw@mail.gmail.com>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050140
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
v2: Move the check after the other checks

 fs/overlayfs/export.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 475c61f53f0fe..ed5c1078919cc 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -783,6 +783,9 @@ static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
 	if (fh_type != OVL_FILEID_V0)
 		return ERR_PTR(-EINVAL);
 
+	if (buflen <= OVL_FH_WIRE_OFFSET)
+		return ERR_PTR(-EINVAL);
+
 	fh = kzalloc(buflen, GFP_KERNEL);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
-- 
2.26.2

