Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591F7C4363D
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E4E23741
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="bN+AP8YX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgIXQiV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:38:21 -0400
Received: from mail-eopbgr50101.outbound.protection.outlook.com ([40.107.5.101]:64359
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727728AbgIXQiT (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 12:38:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iR9YkBo6GNp0zkSL/58RSvYkNm97C+7M5pnCSXns4us97b2UelfafcIjCJj/8O6X3kRtWOIlUCuVsEqJrNfj8TLLvV+2mj5seXNXlsEuTOBRAzblRYmyjkqrNEud58hBbqno6c3sbc1NFrlsiqBxZW4Q7bln/vv2DsrNhLvjxv3ashZP2CsEXmuha2GnEEZA+jZlkJx1q/QKtCT/thM15ZpEhemv4jfF3hy1uYf4I3vUUzM5nhoigYM7fmYUV5AA8oQIZyJ4abpehwaT9lEgcafvqet7kmB10zJ29kjgpmCGdilcqrmaj3t+jjXNJyi5F0X5Tdql9TllQcPftv3PYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/FHcu3CdVyEnhyABAG1i64pICW3JVcVQxRdNHG6EQA=;
 b=CORR69xa1tBldZ/L6ylcglEhaikPTnRduBf/lDEzkUleKjhQdR8r/mNZPZtjGLY1Mvy4EIXkpbclxss/y+Dhb/UAXsXT6gX3+4Yhlde1RT7F++Gh2iAiW+/bvCpipgIdmRhFnbfTDkt3yH8RKMJyYz8hvnYxqB6Q1Y0rtJavCsSNjl8zZv9cLpG1ehjQS82b0VThh7mVAaT9MlvsRAvpo4T0SrfHwERpV+cTSXgnDSVTfA5OgloPiKN+CHJGuGYwOq3eSzpyryIjUrEhYJGnG5o6NrZbo3syr9U7E8dQpyA773kJsavSza4QGMAE/CA8vuPCS0kKNcQmTvjrTxOMZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/FHcu3CdVyEnhyABAG1i64pICW3JVcVQxRdNHG6EQA=;
 b=bN+AP8YXR/foJZJRk3b9NKIrX6RCIGyq2VI+NyH1AUddts7jk6LYF/kjU80VYy5gZyEg7rgoDZJM5TVMKpbSZO2hPRufq9ZFCkFxM8SnMAalWxCfD+OIWCkr4GVR+ntcoP52I2DDJk94niyycomiS0z+Gp0HLrAo3eylrNOsj8E=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM7PR08MB5430.eurprd08.prod.outlook.com (2603:10a6:20b:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 24 Sep
 2020 16:38:13 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Thu, 24 Sep 2020
 16:38:13 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
Date:   Thu, 24 Sep 2020 19:37:54 +0300
Message-Id: <20200924163755.7717-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200924163755.7717-1-ptikhomirov@virtuozzo.com>
References: <20200924163755.7717-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0084.eurprd07.prod.outlook.com
 (2603:10a6:207:6::18) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.179.127.150) by AM3PR07CA0084.eurprd07.prod.outlook.com (2603:10a6:207:6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.15 via Frontend Transport; Thu, 24 Sep 2020 16:38:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a5ec316-e23d-4708-7e4a-08d860a83b13
X-MS-TrafficTypeDiagnostic: AM7PR08MB5430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR08MB5430FB5BD70F4DE3B68974D7B7390@AM7PR08MB5430.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:226;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pbl20+cAKdov/ydrFrNXuujja207Tz9NJRQygUohwZzJLocnXok8oRJZWGRMjy5x888zSXOYJP47a/Q75qMQ3mA9ZtMxuZV1EQrGUh11o7zjnnKupRb3wwpm20PQ/q/v+8hw5FRFjtLO8OW84/xJvPVCg51BWkXADohoVnGYWiV4drn8w9fmj5yNLlflzdR9JPP2fJoFDe/mNwjkFcTdhA8Kt2S1vla/ZdINyXCmm1gDVuGXUn1G529ZPI0dAxqJJ26Pkm8ePxtu6fGVbokSeKriFF2Ow2OyvFOaCQ6giboADomkktMkqpI64SgiwfyTogwkUpWP4s7S8ZJ9DIE5bAdYoYRnwkBKk42WvE1R0f0QqtwmN/aypUJNSotOrJnA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(52116002)(316002)(478600001)(186003)(6506007)(1076003)(36756003)(4326008)(6512007)(86362001)(6916009)(30864003)(2906002)(16526019)(66556008)(5660300002)(26005)(8936002)(69590400008)(6666004)(6486002)(83380400001)(956004)(66946007)(2616005)(54906003)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OlBvbxM5bTcxs6xoJ+q92f3YiyShGHkSJe7uPxRHL4i8v4b9+K4gxfB3rkB943H1cs8c1S9kv9IFYo9FALl2D/vDAbqtCB1nV5/4F8fxNudfxxFzzUZmd9B/iMtPUYsfq4ICCPLeStQT7jvXmcNvgQ/GgXiChftVg8kJg28GBublkQyaLTFqH7L0pDV+9g5a/mxmFEmbkHweisnbGGKOXnevRPjLcV17QFrF7Bzp8EtOMekHcxR/CigQrF9G98dZ3ffaejiLiG6HZI4Q7moCYgGBR1u2G0pTQzQdH5pdis33bf/YDdLbkPPEnXY1xZ12Me7z+FpE8oJfe+5wgD+FupNWsNT2lhMUoNnHX4xvjgMYVfuDKUe+HLI6q63+PSJKkNoHwfxy2iwR1YRkFPHXHCDQEnNLxEK6reoNbuxWt4BRqjuSdT7DZA3JaMrfZoreGQIzvkwVS2tgER9VVWiUZArVBxkgQ99eVffQzy5r96kAZk+iA9Kdml0EEGI8zlqC474ayRpRsByOv37EvSVQm0jtFtGVzuUSd0fHODgpAN+Ato/bQuXOuxIjdsmFFPGMxmN+grAYNbHVoqlrtYXBMHEj7uUFQkaSa36VyRvvEiR+j2z2QGIber0CJqqh1w3wPyhY/ouPq2M1JS7dTkGzKg==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5ec316-e23d-4708-7e4a-08d860a83b13
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 16:38:13.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p38I4iWvWj84wrVsdnWgWxeGIugDMYFUD8Ex01GLMcOr5MLZBJBO6ZzyyLNNnW4OkCv7pZFDnmMWGXOg1GO3l6O4SjxtyZOtzuDUZTZKnyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5430
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This will be used in next patch to be able to change uuid checks and
add uuid nullification based on ofs->config.index for a new "uuid=off"
mode.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-unionfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 fs/overlayfs/copy_up.c   | 22 ++++++++++++----------
 fs/overlayfs/export.c    | 10 ++++++----
 fs/overlayfs/namei.c     | 19 ++++++++++---------
 fs/overlayfs/overlayfs.h | 14 ++++++++------
 fs/overlayfs/util.c      |  3 ++-
 5 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 955ecd4030f0..3380039036d6 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -275,7 +275,8 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
+struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
+				  bool is_upper)
 {
 	struct ovl_fh *fh;
 	int fh_type, dwords;
@@ -328,8 +329,8 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 	return ERR_PTR(err);
 }
 
-int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
-		   struct dentry *upper)
+int ovl_set_origin(struct ovl_fs *ofs, struct dentry *dentry,
+		   struct dentry *lower, struct dentry *upper)
 {
 	const struct ovl_fh *fh = NULL;
 	int err;
@@ -340,7 +341,7 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * up and a pure upper inode.
 	 */
 	if (ovl_can_decode_fh(lower->d_sb)) {
-		fh = ovl_encode_real_fh(lower, false);
+		fh = ovl_encode_real_fh(ofs, lower, false);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
@@ -362,7 +363,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
 	const struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(upper, true);
+	fh = ovl_encode_real_fh(ofs, upper, true);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
@@ -380,6 +381,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
 static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 			    struct dentry *upper)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
 	struct inode *dir = d_inode(indexdir);
 	struct dentry *index = NULL;
@@ -402,7 +404,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (WARN_ON(ovl_test_flag(OVL_INDEX, d_inode(dentry))))
 		return -EIO;
 
-	err = ovl_get_index_name(origin, &name);
+	err = ovl_get_index_name(ofs, origin, &name);
 	if (err)
 		return err;
 
@@ -411,7 +413,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (IS_ERR(temp))
 		goto free_name;
 
-	err = ovl_set_upper_fh(OVL_FS(dentry->d_sb), upper, temp);
+	err = ovl_set_upper_fh(ofs, upper, temp);
 	if (err)
 		goto out;
 
@@ -521,7 +523,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 * hard link.
 	 */
 	if (c->origin) {
-		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
+		err = ovl_set_origin(ofs, c->dentry, c->lowerpath.dentry, temp);
 		if (err)
 			return err;
 	}
@@ -700,7 +702,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
-	struct ovl_fs *ofs = c->dentry->d_sb->s_fs_info;
+	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	bool to_index = false;
 
 	/*
@@ -722,7 +724,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 
 	if (to_index) {
 		c->destdir = ovl_indexdir(c->dentry->d_sb);
-		err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
+		err = ovl_get_index_name(ofs, c->lowerpath.dentry, &c->destname);
 		if (err)
 			return err;
 	} else if (WARN_ON(!c->parent)) {
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index ed35be3fafc6..41ebf52f1bbc 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -211,7 +211,8 @@ static int ovl_check_encode_origin(struct dentry *dentry)
 	return 1;
 }
 
-static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
+static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
+			     u32 *fid, int buflen)
 {
 	struct ovl_fh *fh = NULL;
 	int err, enc_lower;
@@ -226,7 +227,7 @@ static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
 		goto fail;
 
 	/* Encode an upper or lower file handle */
-	fh = ovl_encode_real_fh(enc_lower ? ovl_dentry_lower(dentry) :
+	fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_dentry_lower(dentry) :
 				ovl_dentry_upper(dentry), !enc_lower);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
@@ -249,6 +250,7 @@ static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
 static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
 			 struct inode *parent)
 {
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
 	struct dentry *dentry;
 	int bytes, buflen = *max_len << 2;
 
@@ -260,7 +262,7 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
 	if (WARN_ON(!dentry))
 		return FILEID_INVALID;
 
-	bytes = ovl_dentry_to_fid(dentry, fid, buflen);
+	bytes = ovl_dentry_to_fid(ofs, dentry, fid, buflen);
 	dput(dentry);
 	if (bytes <= 0)
 		return FILEID_INVALID;
@@ -680,7 +682,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	if (!ovl_upper_mnt(ofs))
 		return ERR_PTR(-EACCES);
 
-	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
+	upper = ovl_decode_real_fh(ofs, fh, ovl_upper_mnt(ofs), true);
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a6162c4076db..f058bf8e8b87 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -150,8 +150,8 @@ static struct ovl_fh *ovl_get_fh(struct ovl_fs *ofs, struct dentry *dentry,
 	goto out;
 }
 
-struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
-				  bool connected)
+struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
+				  struct vfsmount *mnt, bool connected)
 {
 	struct dentry *real;
 	int bytes;
@@ -354,7 +354,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 		    ofs->layers[i].fs->bad_uuid)
 			continue;
 
-		origin = ovl_decode_real_fh(fh, ofs->layers[i].mnt,
+		origin = ovl_decode_real_fh(ofs, fh, ofs->layers[i].mnt,
 					    connected);
 		if (origin)
 			break;
@@ -450,7 +450,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(real, is_upper);
+	fh = ovl_encode_real_fh(ofs, real, is_upper);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh)) {
 		fh = NULL;
@@ -488,7 +488,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 	if (IS_ERR_OR_NULL(fh))
 		return ERR_CAST(fh);
 
-	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
+	upper = ovl_decode_real_fh(ofs, fh, ovl_upper_mnt(ofs), true);
 	kfree(fh);
 
 	if (IS_ERR_OR_NULL(upper))
@@ -640,12 +640,13 @@ static int ovl_get_index_name_fh(struct ovl_fh *fh, struct qstr *name)
  * index dir was cleared. Either way, that index cannot be used to indentify
  * the overlay inode.
  */
-int ovl_get_index_name(struct dentry *origin, struct qstr *name)
+int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
+		       struct qstr *name)
 {
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(origin, false);
+	fh = ovl_encode_real_fh(ofs, origin, false);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
@@ -694,7 +695,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 	bool is_dir = d_is_dir(origin);
 	int err;
 
-	err = ovl_get_index_name(origin, &name);
+	err = ovl_get_index_name(ofs, origin, &name);
 	if (err)
 		return ERR_PTR(err);
 
@@ -805,7 +806,7 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	if (err)
 		return err;
 
-	err = ovl_set_origin(dentry, lower, upper);
+	err = ovl_set_origin(ofs, dentry, lower, upper);
 	if (!err)
 		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7bce2469fe55..b56b5f46f224 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -383,8 +383,8 @@ static inline int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
 	return ovl_check_fb_len(&fh->fb, fh_len - OVL_FH_WIRE_OFFSET);
 }
 
-struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
-				  bool connected);
+struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
+				  struct vfsmount *mnt, bool connected);
 int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 			struct dentry *upperdentry, struct ovl_path **stackp);
 int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
@@ -392,7 +392,8 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 		      bool set);
 struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
-int ovl_get_index_name(struct dentry *origin, struct qstr *name);
+int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
+		       struct qstr *name);
 struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
@@ -511,9 +512,10 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 		   struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
-int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
-		   struct dentry *upper);
+struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
+				  bool is_upper);
+int ovl_set_origin(struct ovl_fs *ofs, struct dentry *dentry,
+		   struct dentry *lower, struct dentry *upper);
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 23f475627d07..44b4b62a8ac8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -716,6 +716,7 @@ bool ovl_need_index(struct dentry *dentry)
 /* Caller must hold OVL_I(inode)->lock */
 static void ovl_cleanup_index(struct dentry *dentry)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
 	struct inode *dir = indexdir->d_inode;
 	struct dentry *lowerdentry = ovl_dentry_lower(dentry);
@@ -725,7 +726,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	struct qstr name = { };
 	int err;
 
-	err = ovl_get_index_name(lowerdentry, &name);
+	err = ovl_get_index_name(ofs, lowerdentry, &name);
 	if (err)
 		goto fail;
 
-- 
2.26.2

