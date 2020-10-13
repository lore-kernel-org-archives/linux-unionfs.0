Return-Path: <SRS0=fTQB=DU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC511C43457
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F501216C4
	for <linux-unionfs@archiver.kernel.org>; Tue, 13 Oct 2020 15:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="t3gqTLS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgJMPBD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 11:01:03 -0400
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:49025
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbgJMPBA (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Oct 2020 11:01:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSwp79OK1lUbscAxP9VIcsqnXXi+clr2rK2Vhv6EqpbBHVIBUEa3w/osn5QUM0rmOkr2Mupu9d65V6PQbUXt62YGLY6x2WcVloAM6ZqgrV19OF36Jq5NRTzwbBRtmv/+jS0idkXUQTFaq0A0DTOMvZF/skvvLQ3diHTJ9iCEQk2RlNWbu+glTik0Wn5BifpUBBq53XVH5Ne8m8lVIjU5XSDCNVy8q8bLeufo135C33biRG9tqdZJ3YymTpH9Fwhs1rfB7fJFx8PKD17fDy16xvfaxluwT5moBCk/j7qpV/BJx6sZD2uU/cGyEBtxos2kGPdOtE1ROm6lPYvJjxbCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNcUOf0Y8c4Sdi9u9cTFZBII3FsgBD/8qpbjBgshEXg=;
 b=ILt1EYlBkG0w8FJ8sM4CAr9DWhl9d+IjVCIB0YqIz+xDcKy9xR/r/prGxYgum5GbCdemjKGHOaH8MjD1fnLQ8jOv3+kOSc6f1M9BoC7EcQv8XjHKlMNUzCE3d6tC93osXn2zymBwff+uqON+SiAFrZT4O3pDbm/tWPz/kGwuQL+Ap4pQ3Su8gWEQ5BbS21n8W/nbuw3zGlujpiyXDDp1i+m4Rokgi2qCAEAMZIU2kPxZKwD+7O/HNz3iExGSO3EaGMtR1nPxDRgRheU9Tob0K+UAmO36enHoHI/NmDWozYBm+EACWx6ZCKA+OyTzWCgdbqyB4ohWabTXYJLPjEs+gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNcUOf0Y8c4Sdi9u9cTFZBII3FsgBD/8qpbjBgshEXg=;
 b=t3gqTLS87hN/kl+uz3sfb3Mrzij4BwYRZZxsM9+lWNgo91wMWaHSVGmP5O4dYvuS1+gdImpuwp23JftEyFoa65CP7z4JkZYZelPMIYV1iUTgHscbExDuhCJyrGS8teV1fJ2eOkm7Yq7gSMOANuZ/8UirTAoaZeiuYwAeUI1t/Rw=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3190.eurprd08.prod.outlook.com (2603:10a6:209:46::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 13 Oct
 2020 15:00:49 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::dcd8:72a6:60fc:1fa4%5]) with mapi id 15.20.3455.030; Tue, 13 Oct 2020
 15:00:49 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/2] ovl: introduce new "uuid=off" option for inodes index feature
Date:   Tue, 13 Oct 2020 17:59:54 +0300
Message-Id: <20201013145954.4274-3-ptikhomirov@virtuozzo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 86f0840a-90a3-4e17-ec6c-08d86f88c585
X-MS-TrafficTypeDiagnostic: AM6PR08MB3190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3190A83DD07D7A1D8364709EB7040@AM6PR08MB3190.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hkrjaRF+tXwakjgFzP63zxelH2uKiYAXDzHEfQyZM9fUbb82gJ9Pum59nY7dzTgOTTQtycnMT2Qax+M/wujrXz4euESZa8alzNIiWvKaZalcaKWXv3CRnP2l/choRMM0E9ixuXD2DpAegw9ZJVRf+G4T8703hW+bMuMXaYpW6qaMJiCwGurVB7ELNeOu/tPobS6DVdhdry3CMV00WpmJ9AMxSUE5QZBRD6bvq7mI2uU2XvxDbFp9sgR7f4BqgZdw9jhxKvrRTQ7XkCpqcMzxbW++/pU3n+4qqguRBC67aZLLk1ve1CH6TVyABFgbAxBkciW3b+UHpawYnVoEVUaWiTwtfs5JmulD5e6uA8uNrTCcxWaBebEb2cf/WzFpxkDN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39840400004)(366004)(376002)(396003)(136003)(83380400001)(66946007)(69590400008)(86362001)(16526019)(26005)(6486002)(66476007)(66556008)(6512007)(52116002)(956004)(2616005)(186003)(6506007)(478600001)(1076003)(316002)(6666004)(8936002)(54906003)(4326008)(2906002)(6916009)(5660300002)(36756003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DSy9FCDzgpQPeHWYWH9R/L6WCuAmSQYc5cYRN998le1RC+FR2yfwWgdZLJ4qsfZNl80HZFMCYQTPJDbNJ/JcsUQip0TV865vwOvmSm4Y14/NN5WDPhe7rYiUE+lFadYcOsigK2eiRKwVurJAXqWUd0DKXfaOMkHHoJ05yrug3PxrKHtmlyX4xYtL0xFAU1lgbCBf+vD/Sqfi4Np4kguU8ljK3VVbVXN5YjkXcV+J5Ry3+LPpNvhD+Mpe3jTE9tYCzY3/aoKDGvp2v3XTOlj0w+1kwtDi00ail7WZqjvN+6/U9fu6MB1hio4jDq9CBQFyYB0zuHUqMEaBSYslBvaQaAMec8Z9OzSV/YivTC80ZjZHgd67ts2pib/2NneQhwJJ0iuwAm5Sq2Tf7WHMifLC7ymeMmv40SNqkdx4tIySyvLmevDpVmf9W1CbUPLlEGZaFmnOlWwXSzcyvmRBEQQefO6FSDN/xxPsFCIC6dZxMMOdVA59CXmdE9WV3BAYBGQkYvtrmxZEqBZftOtMAAkiGj/PJRYR3CZqnjB08yI36+U/fiuL+Q3+KyFfvXJqyDP2NmeHjy1kmQrTfekUBNsOX9215V/AFuHOvmK38DfMHGlaky/j4zumm27TjGLNZeBQa50FaHfIv2s8dRC+mO2zxQ==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f0840a-90a3-4e17-ec6c-08d86f88c585
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 15:00:49.6027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNUbBkt0iw6+XbJuYIXHCTXp9ah6rp7XbHnYGfi78OiWSUPKu4vmuAxGExl5GlTB1234KbkYZBH6fipnR6Ge2LVgPG1bCzrX+s8hauT7m/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3190
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This replaces uuid with null in overlayfs file handles and thus relaxes
uuid checks for overlay index feature. It is only possible in case there
is only one filesystem for all the work/upper/lower directories and bare
file handles from this backing filesystem are unique. In other case when
we have multiple filesystems lets just fallback to "uuid=on" which is
and equivalent of how it worked before with all uuid checks.

This is needed when overlayfs is/was mounted in a container with index
enabled (e.g.: to be able to resolve inotify watch file handles on it to
paths in CRIU), and this container is copied and started alongside with
the original one. This way the "copy" container can't have the same uuid
on the superblock and mounting the overlayfs from it later would fail.

That is an example of the problem on top of loop+ext4:

dd if=/dev/zero of=loopbackfile.img bs=100M count=10
losetup -fP loopbackfile.img
losetup -a
  #/dev/loop0: [64768]:35 (/loop-test/loopbackfile.img)
mkfs.ext4 loopbackfile.img
mkdir loop-mp
mount -o loop /dev/loop0 loop-mp
mkdir loop-mp/{lower,upper,work,merged}
mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
umount loop-mp/merged
umount loop-mp
e2fsck -f /dev/loop0
tune2fs -U random /dev/loop0

mount -o loop /dev/loop0 loop-mp
mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
  #mount: /loop-test/loop-mp/merged:
  #mount(2) system call failed: Stale file handle.

If you just change the uuid of the backing filesystem, overlay is not
mounting any more. In Virtuozzo we copy container disks (ploops) when
create the copy of container and we require fs uuid to be unique for a new
container.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-unionfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

---
v2: in v1 I missed actual uuid check skip
v3: rebase to overlayfs-next, replace uuid with null in file handles,
split ovl_fs propagation to function arguments to separate patch, add
separate bool "uuid=on/off" option, move numfs check up, add doc note.
v4: get rid of double negatives, remove nouuid leftower comment, fix
misprint in kernel config name
v5: fix typos; remove config option, module param, ovl_uuid_def and the
corresponding notes

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 Documentation/filesystems/overlayfs.rst |  5 +++++
 fs/overlayfs/copy_up.c                  |  3 ++-
 fs/overlayfs/namei.c                    |  4 +++-
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 20 ++++++++++++++++++++
 5 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 580ab9a0fe31..a3e588dc8437 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -563,6 +563,11 @@ This verification may cause significant overhead in some cases.
 Note: the mount options index=off,nfs_export=on are conflicting for a
 read-write mount and will result in an error.
 
+Note: the mount option uuid=off can be used to replace UUID of the underlying
+filesystem in file handles with null, and effectively disable UUID checks. This
+can be useful in case the underlying disk is copied and the UUID of this copy
+is changed. This is only applicable if all lower/upper/work directories are on
+the same filesystem, otherwise it will fallback to normal behaviour.
 
 Volatile mount
 --------------
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 3380039036d6..0b7e7a90a435 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -320,7 +320,8 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	if (is_upper)
 		fh->fb.flags |= OVL_FH_FLAG_PATH_UPPER;
 	fh->fb.len = sizeof(fh->fb) + buflen;
-	fh->fb.uuid = *uuid;
+	if (ofs->config.uuid)
+		fh->fb.uuid = *uuid;
 
 	return fh;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f058bf8e8b87..f731eb4d35f9 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -159,8 +159,10 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
 	 * layer where file handle will be decoded.
+	 * In case of uuid=off option just make sure that stored uuid is null.
 	 */
-	if (!uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid))
+	if (ofs->config.uuid ? !uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid) :
+			      !uuid_is_null(&fh->fb.uuid))
 		return NULL;
 
 	bytes = (fh->fb.len - offsetof(struct ovl_fb, fid));
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 1b5a2094df8e..b7a73ea147b8 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,7 @@ struct ovl_config {
 	bool redirect_follow;
 	const char *redirect_mode;
 	bool index;
+	bool uuid;
 	bool nfs_export;
 	int xino;
 	bool metacopy;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 290983bcfbb3..4717244e7d7a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -356,6 +356,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
+	if (!ofs->config.uuid)
+		seq_puts(m, ",uuid=off");
 	if (ofs->config.nfs_export != ovl_nfs_export_def)
 		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
 						"on" : "off");
@@ -410,6 +412,8 @@ enum {
 	OPT_REDIRECT_DIR,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_UUID_ON,
+	OPT_UUID_OFF,
 	OPT_NFS_EXPORT_ON,
 	OPT_NFS_EXPORT_OFF,
 	OPT_XINO_ON,
@@ -429,6 +433,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR,		"redirect_dir=%s"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_UUID_ON,			"uuid=on"},
+	{OPT_UUID_OFF,			"uuid=off"},
 	{OPT_NFS_EXPORT_ON,		"nfs_export=on"},
 	{OPT_NFS_EXPORT_OFF,		"nfs_export=off"},
 	{OPT_XINO_ON,			"xino=on"},
@@ -549,6 +555,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			index_opt = true;
 			break;
 
+		case OPT_UUID_ON:
+			config->uuid = true;
+			break;
+
+		case OPT_UUID_OFF:
+			config->uuid = false;
+			break;
+
 		case OPT_NFS_EXPORT_ON:
 			config->nfs_export = true;
 			nfs_export_opt = true;
@@ -1877,6 +1891,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->share_whiteout = true;
 
 	ofs->config.index = ovl_index_def;
+	ofs->config.uuid = true;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
 	ofs->config.metacopy = ovl_metacopy_def;
@@ -1956,6 +1971,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ovl_upper_mnt(ofs))
 		sb->s_flags |= SB_RDONLY;
 
+	if (!ofs->config.uuid && ofs->numfs > 1) {
+		pr_warn("The uuid=off requires a single fs for lower and upper, falling back to uuid=on.\n");
+		ofs->config.uuid = true;
+	}
+
 	if (!ovl_force_readonly(ofs) && ofs->config.index) {
 		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
 		if (err)
-- 
2.26.2

