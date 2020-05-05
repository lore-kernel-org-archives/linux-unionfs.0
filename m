Return-Path: <SRS0=h8cR=6T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D367C47254
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 13:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E36206A5
	for <linux-unionfs@archiver.kernel.org>; Tue,  5 May 2020 13:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qkN/CC14"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgEENuf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:50:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38894 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgEENue (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 May 2020 09:50:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045DlqCC109629;
        Tue, 5 May 2020 13:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=/Fq/7ltq0itZPkq24VsyhajdLkb3KOw00lzFYqr8DJE=;
 b=qkN/CC14e8NEapWrNthBx2INxPfpwH+Dp0OZEX2zO9SLf2cLrWyxhJuvv/xF0z0kER7b
 mU7Tat1kEEVcz+KYsoHalrdhb5+nbY2hOj0x2sjkRpeUFBg0OwOIAY96Dfv8iBLHvt2H
 riYwDn05MKXnllXYB6a/t6F+SaA7WrYCjj5iDZfSBP75aehldPrh8G2ZIQbfqoQ1V+Y9
 RWO9Er8Zk77P5BPohWZwWjc/+AzjWzmF8dWSp/kGPrLGak0JQoajEml1g998lj8sN0RY
 yV8VZuf0RKf+0oKQcC95h9f1B2Oyi4dnw6w1zX4rVAVE6gUJ8s6QITjeKSbztw7pzvSS bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn4n1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 13:50:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045DmZQL109495;
        Tue, 5 May 2020 13:50:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjyqmjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 13:50:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045DoW5X001099;
        Tue, 5 May 2020 13:50:32 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 06:50:31 -0700
Date:   Tue, 5 May 2020 16:50:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org
Subject: [bug report] ovl: make sure that real fid is 32bit aligned in memory
Message-ID: <20200505135026.GA38935@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=595 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=632
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050111
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello Amir Goldstein,

The patch cbe7fba8edfc: "ovl: make sure that real fid is 32bit
aligned in memory" from Nov 15, 2019, leads to the following static
checker warning:

	fs/overlayfs/export.c:791 ovl_fid_to_fh()
	warn: check that subtract can't underflow

fs/overlayfs/export.c
   775  static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
   776  {
   777          struct ovl_fh *fh;
   778  
   779          /* If on-wire inner fid is aligned - nothing to do */
   780          if (fh_type == OVL_FILEID_V1)
   781                  return (struct ovl_fh *)fid;
   782  
   783          if (fh_type != OVL_FILEID_V0)
   784                  return ERR_PTR(-EINVAL);
   785  
   786          fh = kzalloc(buflen, GFP_KERNEL);
   787          if (!fh)
   788                  return ERR_PTR(-ENOMEM);
   789  
   790          /* Copy unaligned inner fh into aligned buffer */
   791          memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^

   792          return fh;
   793  }

Samtch thinks buflen can be "0,4-128".  OVL_FH_WIRE_OFFSET is 3. The
problem is that 0 - 3 is a negative and the memcpy() will crash.

In do_handle_to_path() we do:

	handle_dwords = handle->handle_bytes >> 2;

Handle ->handle_bytes is non-zero but when it's >> 2 then it can become
zero.  It's a round down.  In ovl_fh_to_dentry() we do:

	int len = fh_len << 2;

If we rounded down to zero then "len" is still zero.  Obviously one fix
would be to add a check in ovl_fid_to_fh().

	if (buflen < sizeof(*fh))
		return ERR_PTR(-EINVAL);

But that feels like papering over the bug.

regards,
dan carpenter
