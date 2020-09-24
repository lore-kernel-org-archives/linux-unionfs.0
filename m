Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A872AC4363D
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DDC423741
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="ZNhD53NL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgIXQi1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:38:27 -0400
Received: from mail-eopbgr50101.outbound.protection.outlook.com ([40.107.5.101]:64359
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbgIXQiX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 12:38:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtaYp8t5OwMZv1VIS0FUjgHLukTp4v/59HlSS7Cbw72k6Q3BqgzuUZYKireqlgn/SkRCx1FWlqrg+D1qEA/PMrlYj50ldiY9+ljibyoW3L+moIfkGPhxFw22WHE0zheAwuFpD92/SAXG2Hmbi4FCm5x334lrCbqh7ygJr54HY8QymtObhY6BEM+ioV0Bv9ZI3PD3j5mcDrqjZ5lFLYjSH/bUgvtZQJkqnV0iUDyieLxjCOQA8zHPlQ9HHnYYn0jz2D/zgDaXr+LauzXJcCskjS+5crpYM5V19BnExeIZ0PdCMbkcwVOxE1QT3RDhoSDcXVAw/L2KYdPKB3/ImZytUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDL7wTKT7AeFbt0w0y7R/vLvhuZJuH3eK6OPkg/AbvE=;
 b=QPbrb/U6T013bJJxk8/5DqN3aAxm8EPAA6WP5dGHepClhCAHujdx9tCPp1y5lIT5IY+7Nfii2gDh7dhB7/s3CHO+H3YJYlw7ebCbv+6SBzUWnrbnKmK8m8Kjyfe50AGWK3P8MIeFnklwQUOqsJp0616MqpiXcFLJNlU0iK2AGfrFhpgGjGdZBQcDTMGbW56Of7jdFt7rye/JAyBrKPWeyyKZ0MHKvUX1cuFJA66j+iisCu+178mqigGnjqrbmWXe1cwhysblFcW3yj2CywrLKPS4kRXr5dtDDEgoEp5eKyCeCqSM0hp5qttcuwfCs3ZRhvf9+AudSQ+XjN2rslRqlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDL7wTKT7AeFbt0w0y7R/vLvhuZJuH3eK6OPkg/AbvE=;
 b=ZNhD53NL9ijWztPcjGioRKYW8K5vR0/BsmoURMM4ZV6rPEChmoYuvT2rjlKniNfbhpzRHz8ZVJxlsqnhpxbQ2bUYMShhhzhJtnv6NhqfISmg/yz4Za93uoC85EYmq/ctPlzO3bP+CWBgEajpe1qowN1A6GZPTrT21xzTW1nckqY=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM7PR08MB5430.eurprd08.prod.outlook.com (2603:10a6:20b:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Thu, 24 Sep
 2020 16:38:14 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Thu, 24 Sep 2020
 16:38:14 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] ovl: introduce new "uuid=off" option for inodes index feature
Date:   Thu, 24 Sep 2020 19:37:55 +0300
Message-Id: <20200924163755.7717-3-ptikhomirov@virtuozzo.com>
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
Received: from localhost.localdomain (95.179.127.150) by AM3PR07CA0084.eurprd07.prod.outlook.com (2603:10a6:207:6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.15 via Frontend Transport; Thu, 24 Sep 2020 16:38:13 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e8e5059-e829-484b-46fb-08d860a83bae
X-MS-TrafficTypeDiagnostic: AM7PR08MB5430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR08MB54303EEBCAC9868E87139B53B7390@AM7PR08MB5430.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gPFY1v/rsvX5FDOWTOex37bAZRDevjchL4RoC5i9R3a53JOFDpX2bqTU/dnt4A1Eu9hbks6dVexpt/czTVX3dF9Qoe2O9dRJbqRfD6Xp0xCsu+v3EIC6mf5Vgr3s9r/roNPF76v7hLoui+41Sb4uvMvfdximkmyd/lK3EfUfSHSoabmY/CQBBo/PymZRtALwdDyVmqfL7Db7Eb2pQNbgZ2mW4ojLynSd/8WByhmOiDG0H9cbkLzh5hC/NS0uxj1yCAOIKHcMHgYiePUjBkWKIto/h28Nk8MiUDn1OcTPs0ZiJ4RXCUJbxiGwM9hEZUZ9oP95zizdii3IVdI212uUilEoQ26bDweUOg9ZV0TvofpWzBaobXxbDK34cJcPaqPV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(52116002)(316002)(478600001)(186003)(6506007)(1076003)(36756003)(4326008)(6512007)(86362001)(6916009)(2906002)(16526019)(66556008)(5660300002)(26005)(8936002)(69590400008)(6666004)(6486002)(83380400001)(956004)(66946007)(2616005)(54906003)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IZl9fG9oTqGC8qHhRSg1w13Jq352q85GyNTRySGDLB6K6XgoHSlwmMwQyOeQ0BwKIap82cQjisetYqJ+pZPcrf6GjAeOO+FUBq3KgxhBHNwa8vVjm/IrzNmVbIZ1QFLYP+Ga4RXBfw1z7yFhDbQG5HZYp5KFt8rzDg6arqqeRZNAmwL4Wogt03szno24d9MXmGJo/154EbYkKQCy1DELg8TKjx62+qva28qJ/xsfpIgvJE3EffKPouoTGL1sN47sBMI0TLIEP6El8PDW54KvObVIcAjyWC+2lkmLYoG/vv8Phy4ShSy2HZ46FIIvK/LBM2o1TovFfu0kmHzZZA8sec85yyoh1NqBJkZzrv77WwyVB2KDNayG6Bzuo/3AbwFVYYc2s/fM0lgse6kRR3xm7gjSpjWv7o3q5aeTw/aKVK8GUdLCtpuxZ1eA/T2QDlU/THWyZPERTVnQc98hsSHVQV3dc8Md46ZC4B138li6lz14cdOAu8pw+vsK/MPvZCtm1nWKTeemTZ/9ZgEmW7PGvLk5uWi6UKsJ950BXwnKgrtQEJwvhfsMDVBVr5ju4eQyxF12xIdRQRe2oQDDt6cnM9A1ymepmai4s/e6AQf/sSFh4QI1wCHNCjr/jC+EzkNF6xMU675m0SXNs6La2vg8Lw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8e5059-e829-484b-46fb-08d860a83bae
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 16:38:14.6713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqN1oef5ACPDzwG/o4mQ7dfzEUZ8iB5o03tWtSZZg/UWBxA9HRU/YFeXuPHU1WRSyUw+/3jTThpIF3++aCWKTYE+Q0BPHz3ffQrSo75HR28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5430
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This replaces uuid with null in overelayfs file handles and thus relaxes
uuid checks for overlay index feature. It is only possible in case there
is only one filesystem for all the work/upper/lower directories and bare
file handles from this backing filesystem are uniq. In other case when
we have multiple filesystems lets just fallback to "uuid=on" which is
and equivalent of how it worked before with all uuid checks.

This is needed when overlayfs is/was mounted in a container with index
enabled (e.g.: to be able to resolve inotify watch file handles on it to
paths in CRIU), and this container is copied and started alongside with
the original one. This way the "copy" container can't have the same uuid
on the superblock and mounting the overlayfs from it later would fail.

Note: In our (Virtuozzo) use case users inside a container can create
"regular" overlayfs mounts without any "index=" option, but we still
want to migrate this containers with CRIU so we set "index=on" as kernel
default so that all the container overlayfs mounts get support of file
handles automatically. With "uuid=off" we want the same thing (to be
able to "copy" container with uuid change) - we would set kernel default
so that all the container overlayfs mounts get "uuid=off" automatically.

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
crate the copy of container and we require fs uuid to be uniq for a new
container.

v2: in v1 I missed actual uuid check skip
v3: rebase to overlayfs-next, replace uuid with null in file handles,
split ovl_fs propagation to function arguments to separate patch, add
separate bool "uuid=on/off" option, move numfs check up, add doc note.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-unionfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 Documentation/filesystems/overlayfs.rst |  6 ++++++
 fs/overlayfs/Kconfig                    | 17 +++++++++++++++++
 fs/overlayfs/copy_up.c                  |  3 ++-
 fs/overlayfs/namei.c                    |  5 ++++-
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 25 +++++++++++++++++++++++++
 6 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 580ab9a0fe31..4f9cc20f255c 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -563,6 +563,12 @@ This verification may cause significant overhead in some cases.
 Note: the mount options index=off,nfs_export=on are conflicting for a
 read-write mount and will result in an error.
 
+Note: the mount option uuid=off (or corresponding module param, or kernel
+config) can be used to replace UUID of the underlying filesystem in file
+handles with null, and effectively disable UUID checks. This can be useful in
+case the underlying disk is copied and the UUID of this copy is changed. This
+is only applicable if all lower/upper/work directories are on the same
+filesystem, otherwise it will fallback to normal behaviour.
 
 Volatile mount
 --------------
diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index dd188c7996b3..888c6e5e71ee 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -61,6 +61,23 @@ config OVERLAY_FS_INDEX
 
 	  If unsure, say N.
 
+config OVERLAY_FS_INDEX_UUID_OFF
+	bool "Overlayfs: export null uuid in file handles"
+	depends on OVERLAY_FS
+	help
+	  If this config option is enabled then overlay will replace uuid with
+	  null in overlayfs file handles, effectively disabling uuid checks for
+	  them. This affects overlayfs mounted with "index=on". This only can be
+	  done if all upper and lower directories are on the same filesystem
+	  where basic fhandles are uniq. In case the latter is not true
+	  overlayfs would fallback to normal uuid checking mode.
+
+	  It is needed to overcome possible change of uuid on superblock of the
+	  backing filesystem, e.g. when you copied the virtual disk and mount
+	  both the copy of the disk and the original one at the same time.
+
+	  If unsure, say N.
+
 config OVERLAY_FS_NFS_EXPORT
 	bool "Overlayfs: turn on NFS export feature by default"
 	depends on OVERLAY_FS
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
index f058bf8e8b87..0262c39886d0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -159,8 +159,11 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
 	 * layer where file handle will be decoded.
+	 * In case of index=nouuid option just make sure that stored
+	 * uuid is null.
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
index 290983bcfbb3..8bbd45fcf7b8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -43,6 +43,11 @@ module_param_named(index, ovl_index_def, bool, 0644);
 MODULE_PARM_DESC(index,
 		 "Default to on or off for the inodes index feature");
 
+static bool ovl_uuid_off_def = IS_ENABLED(CONFIG_OVERLAY_FS_UUID_OFF);
+module_param_named(uuid_off, ovl_uuid_off_def, bool, 0644);
+MODULE_PARM_DESC(uuid_off,
+		 "Export null uuid in file handles of inodes index feature");
+
 static bool ovl_nfs_export_def = IS_ENABLED(CONFIG_OVERLAY_FS_NFS_EXPORT);
 module_param_named(nfs_export, ovl_nfs_export_def, bool, 0644);
 MODULE_PARM_DESC(nfs_export,
@@ -356,6 +361,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
+	if (ofs->config.uuid == ovl_uuid_off_def)
+		seq_printf(m, ",uuid=%s", ofs->config.uuid ? "on" : "off");
 	if (ofs->config.nfs_export != ovl_nfs_export_def)
 		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
 						"on" : "off");
@@ -410,6 +417,8 @@ enum {
 	OPT_REDIRECT_DIR,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_UUID_ON,
+	OPT_UUID_OFF,
 	OPT_NFS_EXPORT_ON,
 	OPT_NFS_EXPORT_OFF,
 	OPT_XINO_ON,
@@ -429,6 +438,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR,		"redirect_dir=%s"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_UUID_ON,			"uuid=on"},
+	{OPT_UUID_OFF,			"uuid=off"},
 	{OPT_NFS_EXPORT_ON,		"nfs_export=on"},
 	{OPT_NFS_EXPORT_OFF,		"nfs_export=off"},
 	{OPT_XINO_ON,			"xino=on"},
@@ -549,6 +560,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
@@ -1877,6 +1896,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->share_whiteout = true;
 
 	ofs->config.index = ovl_index_def;
+	ofs->config.uuid = !ovl_uuid_off_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
 	ofs->config.metacopy = ovl_metacopy_def;
@@ -1956,6 +1976,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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

