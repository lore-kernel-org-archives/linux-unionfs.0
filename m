Return-Path: <SRS0=fTQB=DU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4EBC43457
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D210F248B1
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:00:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="bVjTexSr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgJMPAy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 11:00:54 -0400
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:49025
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727112AbgJMPAx (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Oct 2020 11:00:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RhRx0QvYuu4KOLLUk1aT4F2FuV4CsEdaE1liTN10Rq9zL20G7Uugr17gRKIP0MEtpFpLAU+MI4z1LYDaZXUMwsGDVpTUF9E1oVJCQW9xtbCgGYAM7QO+DPoTag/Qy6uTZ7zsOs6VVQe7LdeiGURLfPWy1JydpebkG9EmeorTqtBDebzpdW2S++SLRVRCv151afJSaUY5QCmpEkpo9eSVvvGk2h7f0cmZ8IE8yE3lGxJegZtjpGF5xknPc2T3s4CTvjOPZ0fIInArQ6KAhuE7kYvtSpu/ITKRQ3mWKcOvPOcBBDNXzWBTxtUhtCKbYURjyJHNgJkDv2bkP1H09K6snQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ig+477ALwSmX0NZa6Ko3S7cIZYJfd52SlKYTet52dcg=;
 b=Y7y5Y6+SRl2UgBsK9B0zMGBpQtaX0uRpl1TjPbw1EJ/FomFoGGTG74IL/f1dM2gtWaq9cwimH/mEMUVA5JKVvd45StsmWknEkCK+2f0b7vQiwxtMQdci/uAiYjgegucaKL5dsWPBZigkMvyJSRcF2iXpT9kNGzSvoickoPiYW5VR/+7NMypI5O/r+OrxOfnqXScIYqCm/KHAwzJ66+/OqILmcMTa1FmXzX8yj1Nz8PN9z0MGZaHvV3/d27pVO6x6wtRrn6zTTXeQmMYHDIGTKPquB9xLGtPup67t3zgS+Y2GUsqUA1EGHTW7smXJpYXsKdfHt8zR9iZsyz/MkqmdLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ig+477ALwSmX0NZa6Ko3S7cIZYJfd52SlKYTet52dcg=;
 b=bVjTexSr5u3jnRjw1kjX4ltECSJy+QnoaoB1Y5ElY017lFrDxXKsADLuKnfja8t+om2SSG7eZFjqiLcDfPw0hEHFVyOJ63CbkFymC8PP/OltAuf8d6dbnfZQT3dgIyaKm+g16Ni09UuZiVO9oidFx6JQatCAJX8zAct9d0+rFTY=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3190.eurprd08.prod.outlook.com (2603:10a6:209:46::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 13 Oct
 2020 15:00:48 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4%5]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 15:00:48 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/2] ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
Date:   Tue, 13 Oct 2020 17:59:53 +0300
Message-Id: <20201013145954.4274-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201013145954.4274-1-ptikhomirov@virtuozzo.com>
References: <20201013145954.4274-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [46.39.230.109]
X-ClientProxiedBy: AM0PR04CA0132.eurprd04.prod.outlook.com
 (2603:10a6:208:55::37) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (46.39.230.109) by AM0PR04CA0132.eurprd04.prod.outlook.com (2603:10a6:208:55::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Tue, 13 Oct 2020 15:00:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86fe6de5-f659-460a-e2ce-08d86f88c518
X-MS-TrafficTypeDiagnostic: AM6PR08MB3190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB31904D66400EA70D9E3DC19FB7040@AM6PR08MB3190.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:226;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsbrj1w2NVzK4JYU67CDYhqbRDLQpUh9yfFqSMMrA1XCsuY2alkUaaMCZ2HS297eXpdrtNBtCGf4uxBgIZZ/tUhu67DjLj5Cq/N9r58WDaH9GFlkyUUm5IcUlACQr8hTfHJ1UJoxElp8irrcyFLayVRyh3wantbJU+NGS4fsHzGvaifWWrrJZ/L+6HLs84EnPtOLL9SmSx2CKWTO8Wt+FA9NWDfT38Uloxa/ENEPDHPMpOKh6Lp7l2IE4VRt+9g268M4V0wMR80NuX6AHYNb4scwNNitar6BJnv9tWmrV7RMTvZlFHjdhTchRa/3DhFFluiuM3kC4ll59KIJPSqPkFe5xv/aurPT0NgwyF0W1GQ+29Wug3Xbdl7qBu3EFsUj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39840400004)(366004)(376002)(396003)(136003)(83380400001)(66946007)(69590400008)(86362001)(16526019)(26005)(6486002)(66476007)(66556008)(6512007)(52116002)(956004)(2616005)(186003)(6506007)(478600001)(1076003)(316002)(6666004)(8936002)(54906003)(4326008)(2906002)(6916009)(5660300002)(30864003)(36756003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 1j7iIFswLTFqV9nItMRnpjMfbqZNRhJjxXbCuDarf8il3LA8uU0Fbo/59bQF9cQsYf7BVF10FUHD5k9yODeYpKcuJ4MYLcFmHP2xd8YX9mo8ZaiglXdVaibpGIsnupUQRt3xIu92XK8L+uXEYkICMFGefvZExDtjiT6B/AE1KEs1u9d63ON1tPOSLQ34FMuh9kgXwMTD/KJtNshEpC47pflSW4AaorFIgAuMzEEDYGTUjUEE/oEyVtEAGDUW94qmqIB/Pti0tBdjRYbwwFKti+L+liqfP0hp09Jr+jhQ1yDB3x13eEeEz2s8t/tJeNhbtFBz4RDXV2xVDRu82h5D865Jxhxtkeb1zBzhTXRRtw2zE5c3+PxEzoTla402BhCrKTV3bGyzVBve3WEFhgHCQff3WhEKyyfbcn4YJPUtdHgOLaNM81kTFDWdnqjKDUezISITSNq99voGd4yAwZBAmEMCIojtw+Xnj7n5eMA6XNzq0UpWoi+f94mof+vIusBn8d/QoQlgIfMWRN1KcuJbijTmosolb6Jf1rZvzkCpf3nHOqN5TzZMWyIZe1xsQLx9rZ5Y43WO+f4y4tiMH+zZD5t3UP3HcObYmMBf0bxj9JMv9YW6LONEcJ0Mad989i9g8Wtad+XjDC14FFz2Ltmz2A==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fe6de5-f659-460a-e2ce-08d86f88c518
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 15:00:48.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UU6yH/q5LEx9zfzhYOXFxs6e8EL5UJw+lpij+O9D2x25/lH6EYaqnpwkFozJhyVuW588L1v7IuBxNopDOAwcv5GpOT6pU5Zx3HGBE0XqF84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3190
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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

