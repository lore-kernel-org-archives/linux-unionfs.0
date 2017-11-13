From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 1/2] src/t_dir_type.c: Use strtoul() instead of atoll()
Date: Mon, 13 Nov 2017 20:15:26 +0530
Message-ID: <20171113144527.1034-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751303AbdKMOoj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Nov 2017 09:44:39 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vADEiWPG104045
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Nov 2017 09:44:39 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2e7budwgn6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Nov 2017 09:44:38 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 13 Nov 2017 07:44:37 -0700
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com

An overlayfs filesystem instance with one lowerdir filesystem and with
"xino" mount option enabled can have the layer index encoded in the 63rd
bit of the inode number. A signed 64 bit integer won't suffice to store
this inode number. Hence this commit uses strtoul() to convert the inode
number in string form to unsigned integer form.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 src/t_dir_type.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/t_dir_type.c b/src/t_dir_type.c
index 76aaa9b..7bba304 100644
--- a/src/t_dir_type.c
+++ b/src/t_dir_type.c
@@ -85,7 +85,7 @@ main(int argc, char *argv[])
 				break;
 		/* no match ends up with type = -1 */
 		if (type < 0)
-			ino = atoll(argv[2]);
+			ino = strtoul(argv[2], NULL, 10);
 	}
 
 	for ( ; ; ) {
-- 
2.9.5
