Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D556C4363D
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E8520888
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="JJAAtIah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgIYIfu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:35:50 -0400
Received: from mail-eopbgr70123.outbound.protection.outlook.com ([40.107.7.123]:60481
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYIft (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 04:35:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9VPYwPiz6eew8Lsa0yKR786dnGIDAZN8E8Hyf+6xbJiryWDNhHLkfiu2zObSfNXrZulNy29sJc99GLgGVyIuUOHhtYVbRnZHENDPYFlvdJX9nDOTY2IivYLRVHFZQ/dGU/gaQrqX5nwJU9Fph34L/pJCAqgYQCxCwf1ofaoSEXLG9xx/VfxEtVqqWq/Gs4uryemxA0vSokiKNNLMu4edFCaaNWomCcH4h6RbNeCIaLLfho10Bbjw+TmYAyuMaQmCPUTJHm/KrMC6CO6HAKubmylyduarW5QzmVwfKKdy2pOr0lfuyK7/1KUvpcsu63SLaKYq61Zaw6QhrQ0pj0Xig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/FHcu3CdVyEnhyABAG1i64pICW3JVcVQxRdNHG6EQA=;
 b=d95Q+73GxbW1vLZU8JJvjB6bflhmpMFPr81zroGmoRzDAGn21y+67wnnKEixrwcS+qvSFXNFr9lPSfmeufdsl08vz/OLrAidvaCn2gtoNXfQnggLBQwFnZRFu8D3v+LENUjUtCeux4U/5q99j/N6h2uOwtmBURKdyAEkI4ggkhXBp1FXX8ar6fElRg1wFrUngY9DoUie8NoZNKejvmU6aFBw7HQiRQoS4tL+/tQis0Rvx/juBzDjlDFy4ZoLAFMMYdEa/vglTrZlY1gYuT5uknYIa/KguCtagzomGGEIJ0z80o4XOXxs+wLOj8dCIH+GSQhI2JgQN6y/WSOEFE/dvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/FHcu3CdVyEnhyABAG1i64pICW3JVcVQxRdNHG6EQA=;
 b=JJAAtIah33R/qPFxmRArZVxGUZfCC3EdcGt1H2hjClmntlEvFhIQHq+LPy5ijd5xzfP9bw0ieigB8aEtlKldExZ/mrY4Ediq4vdwJ8uDwkceXZ+8bFxbtNSEphFB40ybIiEhpzuK7ly30ma5vMf3MlMGKR4Ht8f3iSCOp82eoyo=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3333.eurprd08.prod.outlook.com (2603:10a6:209:45::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Fri, 25 Sep
 2020 08:35:40 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 08:35:40 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
Date:   Fri, 25 Sep 2020 11:35:06 +0300
Message-Id: <20200925083507.13603-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925083507.13603-1-ptikhomirov@virtuozzo.com>
References: <20200925083507.13603-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0087.eurprd05.prod.outlook.com
 (2603:10a6:208:136::27) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from snorch.sw.ru (95.179.127.150) by AM0PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:208:136::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 08:35:35 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb21f392-865c-4326-701e-08d8612df9a2
X-MS-TrafficTypeDiagnostic: AM6PR08MB3333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3333A75F743EAB347ACA54DEB7360@AM6PR08MB3333.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:226;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vxMhfUljefiQT7x4r4KqbyBT+2f/7q0+WaGywSnUeJ8W2WqJBGTXKsfWYwXlvA3iasXqLd6JvFGsR0HnEDfnzeH1kCkgUpyjby+OxJuUYu4mR3FvInkTQvPtUjWHrKy9Dx/vr1cGUCiQH05IrYhoENxp0vLAqx0/Jcec6TIMP73xQmmwbCLzoKAhVfttt8y5JZWNXzSByU7XWfVvsXYjAl9VtJN8vKa3839i9AaDYKai1YwvVfDM5z32yY1sApBahs67SUcl4Gyg28xpeENMfxBLCg3iaK8VJpg88TlFgm6YbphliJ1he/jBtllg8bo0WjgbG2i8g4xvl5JosbFO3ch9pAiELbo4N2To9RZHcPwQ7AvRszGD4bL61zIfyPN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39840400004)(186003)(36756003)(66946007)(8676002)(86362001)(16526019)(956004)(66556008)(6916009)(8936002)(2906002)(66476007)(316002)(5660300002)(6486002)(2616005)(1076003)(6512007)(4326008)(83380400001)(54906003)(478600001)(6506007)(52116002)(30864003)(6666004)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vAFN2By5/9eTSakGe8UInDQJ5p2SOstWO+DdjggghuoWNZrG3O4/bY4N+L9nnUlxWihzP6ppfliIk0fLc1U1BlGshDKwcb3feQICS8keKAtTeIFofYmZHkPduvJZLSw34jzGQtKQAGM4oh9pfzWvVGvCUrQGwMKzzswGZbfFLMyOepmStTGTi1lOGWqXLVrUYogQtzwISd4kEPl70pAJ3IvboPRj4ePm7SxYH54xTzAh5GN54H2gih/uHI0AoKs7k0MYTC5UDk5RS/KekruTUmGVmWbH0U4gZ2Tw+UCC/QdFl2jA4TnDEqjZQ9MJ/G2dcS2zfK7+VlnNP+sOiv1WUBfzqdtiD/tKeVVEs6IFcIZEirLSs6WhO68Pid4nhVzqnmVVokPf97cURlASjiy8ctTfAUvR+Jyq09/ohDIm8QaRMUq3jYeIog8Np1oamaxr0NtGAjUWxAliyY2lUVehbB69gLaQsbjgl+VcBPhL3eJCm0br34Tzpf+F2DWnvvQz0Ep6okt8UcDYLxNQ/aRYyVmduVO2+UCj9EqoJH3LvzF+PJ2ZYI68l8GP7piavh58OrkL1EhS8d7R9l2Ad1W/VIexEfErjZW8oG9pcL4yVrDuvuzsKo4wcIbbpWAdWPWm+05tOrm5qSw6OUR9OlwcUA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb21f392-865c-4326-701e-08d8612df9a2
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 08:35:36.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sY+GaVWFmYJO2/zIumxhFFz3LY0+0MsYEFdk1n5NjTb7tCaXaWPwYbLmBMWZ0RUiqt/gepaUYssclK9Tshp22LfEFd979jcqqrATeA1KxZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3333
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

