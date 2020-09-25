Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FCEC4363D
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF85620888
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 08:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="U7QoxrNO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgIYIfy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 04:35:54 -0400
Received: from mail-eopbgr70123.outbound.protection.outlook.com ([40.107.7.123]:60481
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727248AbgIYIfy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 04:35:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyiDUgB6u8LXTLfLSZC6kiScmZ6Aimnh3qGiNLR9OdWu7JMaQjDFI2vK8kEwLaSbO9MA94KKs14gwuOSQhhBU+9fmUy+YOvMatBEihA0cNdo4LM91UMGfXBm4+o2DbAiQxTEdZeb+PcYEtqgy6+E5cYaRdHWZQ7J1qwn8Yp10rLuMmzAMHZBw/xYfP6gmvL69zLvYbxnjnnLJAxN4saTEz20iOdS5mFPk5HOGGeE/WnYpg6X0WyR8kA/T/qlRjph5BNbnMcm4aoG88XGRmHH0tzlTKxR8tQkeFguWIzFgoyTdpCT9F3214JKXVJRdNCMtaDzOJ7KTEIft48FxMGd3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/MzQoLinhHo57x//fYNWCNoRYawp+Xtc9zqkQbeXj4=;
 b=aAt9/YrwOpVmaeiUixhLtpPMjbxkDsZuM72w9V1eHsQ9NEfYTeRmCZKpvaqnJc+3JQxMwdVG5Ir8oYHDP7nYo4wwO2/fKD/yG1RlIEyqafjVeGNoCJaW3Lg7Oew4rpyW2TOyOVerF5t6SrlwMATanr/m/krPvOr8J24mXYmXRJYf3NvHUX4Gzw61ztWps44Z5DsN0Ch3s0LH2J/QBdlu0J2xweN6jSE3xHMino8AXjINP5/I9FJZpWDU6iGHvM1ZDGhvbFgL9E9PVCRQWuhZg3XMjpMO49/Xxr9AnwhElMRGGBhiRbx7IjNIyCrlxLnDM+CWBo8PeEUmsXoie2Yxcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/MzQoLinhHo57x//fYNWCNoRYawp+Xtc9zqkQbeXj4=;
 b=U7QoxrNOJDiika0xAPgx91qg6P2RdeW7P7Z/rdHW376z55HxdqTY0jPGLvoaYUxEi9x+gSkS3ehGfWDPSXkfjOkY1RuapDuPLuH9cHaa1i1prz71gWLoR3GpsP5rwkuAfyzx0+yIC+32HhnIRijXIlMS/TbC/u8dYBT/crombZo=
Authentication-Results: szeredi.hu; dkim=none (message not signed)
 header.d=none;szeredi.hu; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3333.eurprd08.prod.outlook.com (2603:10a6:209:45::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Fri, 25 Sep
 2020 08:35:42 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 08:35:42 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] ovl: introduce new "uuid=off" option for inodes index feature
Date:   Fri, 25 Sep 2020 11:35:07 +0300
Message-Id: <20200925083507.13603-3-ptikhomirov@virtuozzo.com>
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
Received: from snorch.sw.ru (95.179.127.150) by AM0PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:208:136::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 08:35:36 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0fb1330-b53e-42a6-1cb0-08d8612dfa49
X-MS-TrafficTypeDiagnostic: AM6PR08MB3333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3333535CBDFBBB00768DE3E2B7360@AM6PR08MB3333.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vrX5zAFvJRMFjA+783gVxhW/DCTI5HYtKMNd3SplOJq+RItVpErf0ENKEkz65F/+fcKELJOzDgZFSDo7z7KakBYGkb67Fbzyvuqu8mc5cCGy22v2RS+naAwUylZOWNx6B9A9nF3dje/5ky7ihdbOW/Kd05Zt+YDSh5hoZtOdakOvDLvQGswG6WIurcBTG2I1Q2olL+9lBDU5cD3KuKgrftD7PfLerwuiwO1yB4y4y54VjCDFz5TRPwuaK7GpLqp/FIWoW6LFIBjypo2NfI/cWl9RY9PaoHdNhxAkqPy0iMBXMaoIZrsHqEJedhWh2YPCdaEdUp0Rp0MBf6EWh4j2CygGDwaz2xJB+DKwo/9yab3TJie5+1NGQweqp4r+QDu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39840400004)(186003)(36756003)(66946007)(8676002)(86362001)(16526019)(956004)(66556008)(6916009)(8936002)(2906002)(66476007)(316002)(5660300002)(6486002)(2616005)(1076003)(6512007)(4326008)(83380400001)(54906003)(478600001)(6506007)(52116002)(6666004)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vbhofpPNm26CCmp54CrOh8mO+W5UglsNYEXZMlFvp5HYUR6g9fvDAPG6cuyaIwZ/0eBbQmyPW3px4xpltRneek4zzBQBvnLTCAFADWiWQDF+7rOcpKAWyjKkuy8Cbfg6taRBzmovR2hmL9jd3vUo3GGG35/wmpwTa6MweUp9eZRWqRHPtMOhuQ4hDRoGd9UTiL5I3xdAWN4iEHRK1FtuExZ9URVsjXSaMxNfw1vA0A/Rc6oTSMe4FE+UKLdjfnRg/cigG4TT/dE2Si0IwF8EzVX4YISFAmpkZMWq3YiLrHjPSzSC6fUwHDJbrle22U8lHuEXaBvjIsqGYSItMuSr9qg3UO2aNTo0epg4PpsH2JQ3eqvtnWartabdlXfavFsdX3PPB1n7duPfvtYPUenl42OtJ2dQLVTBqCxp1e1H7R6DPs2/jM4OX3Ga5BnpO/90HW3YbLS/Va0unfcI5bu0oypJ3ZyNPWpPCm0qZ8jd9Ei6FQpuimqcVsVV+0NcojRr9Cc+GwyiII0v4v+ZPLOttNb1wO7LBPRSLX5AaT8gzJIJ/jKOMKSujVWdrG2W3nS6O4gMV97bmSiaXJ1wrbejudJpuLaGsSZPg6W4ChBmE3534qvOsiuROoGSZfx5KkPpPgeaf2C5T916hDnnvQQBPw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0fb1330-b53e-42a6-1cb0-08d8612dfa49
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 08:35:37.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vp7zhdu3JSPzoPL3nlG8USxAIW4JGfodxuNoGqkJzrbToaorT03WnlFYNG/hMo1ZCVFU4peuYhQhh2mLE4olHb22BIT4UeLTDBU0slcmHQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3333
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
missprint in kernel config name

 Documentation/filesystems/overlayfs.rst |  6 ++++++
 fs/overlayfs/Kconfig                    | 19 +++++++++++++++++++
 fs/overlayfs/copy_up.c                  |  3 ++-
 fs/overlayfs/namei.c                    |  4 +++-
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 25 +++++++++++++++++++++++++
 6 files changed, 56 insertions(+), 2 deletions(-)

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
index dd188c7996b3..c21abdb43206 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -61,6 +61,25 @@ config OVERLAY_FS_INDEX
 
 	  If unsure, say N.
 
+config OVERLAY_FS_INDEX_UUID
+	bool "Overlayfs: export uuid in file handles"
+	default y
+	depends on OVERLAY_FS
+	help
+	  If this config option is disabled then overlay will replace uuid with
+	  null in overlayfs file handles, effectively disabling uuid checks for
+	  them. This affects overlayfs mounted with "index=on". This only can be
+	  done if all upper and lower directories are on the same filesystem
+	  where basic fhandles are uniq. In case the latter is not true
+	  overlayfs would fallback to normal uuid checking mode.
+
+	  Disabling it is needed to overcome possible change of uuid on
+	  superblock of the backing filesystem, e.g. when you copied the
+	  virtual disk and mount both the copy of the disk and the original one
+	  at the same time.
+
+	  If unsure, say Y.
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
index 290983bcfbb3..a37995138b0d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -43,6 +43,11 @@ module_param_named(index, ovl_index_def, bool, 0644);
 MODULE_PARM_DESC(index,
 		 "Default to on or off for the inodes index feature");
 
+static bool ovl_uuid_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX_UUID);
+module_param_named(uuid, ovl_uuid_def, bool, 0644);
+MODULE_PARM_DESC(uuid,
+		 "Export null uuid in file handles of inodes index feature");
+
 static bool ovl_nfs_export_def = IS_ENABLED(CONFIG_OVERLAY_FS_NFS_EXPORT);
 module_param_named(nfs_export, ovl_nfs_export_def, bool, 0644);
 MODULE_PARM_DESC(nfs_export,
@@ -356,6 +361,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
+	if (ofs->config.uuid != ovl_uuid_def)
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
+	ofs->config.uuid = ovl_uuid_def;
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

