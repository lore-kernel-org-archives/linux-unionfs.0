Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E92397935;
	Mon, 28 Sep 2026 21:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631140; cv=none; b=UYZxOPowieVYMQVP8yLofU4FD5KBCxT/ygp5bcJT6zG7C1VNDR7WAqBfp7Fwnj9pWOO6B4zxLkIPVjfeaA47QraoSNMnyYmWVIq3n7pmnD0sFUpUNU00GNuGoy6xx5ZTWDv7JiTMjJCsJtPE0WgKXbkV1/Xvmj7wpG2g4TNGXUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631140; c=relaxed/simple;
	bh=35g6jc7QcEmURrjgGEgNz8E0NT1qpmZVKdM6CdXfV9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl6chZXBW2PU5d9WNYQvxpJJcqaXKJ10AaGb6lTeBoLR0fZbZuEFZEzV3gypLN9hqP65fPc0iOJ0gJnTljytgocrxYFEywW96v4HjL8BlU/LuR7QfVcBup0YN0K7wtP8EOFeSVnkWfJBqo1rtFOqzdCsJH5u9LAT6vCfF2twEuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C60621CA6;
	Mon, 28 Sep 2026 21:32:13 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25D1C1340F;
	Mon, 28 Sep 2026 21:32:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tIQMN9zcumqcMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:13 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Hugh Dickins <hughd@google.com>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	linux-ext4@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] ext4: Expose the filesystem encoding through sysfs
Date: Mon, 28 Sep 2026 17:31:53 -0400
Message-ID: <20260928213155.2612039-3-krisman@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928213155.2612039-1-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9C60621CA6
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

Daniel Tang pointed out that shmem doesn't list casefold as a mount
option, even when it is mounted casefolded.  While fixing it, I noticed
f2fs actually already provides that information via sysfs, but ext4
doesn't.  This patch reproduces the same interface in ext4 to have
feature parity, so users don't need to rely on parsing dmesg or trying +F
on a temporary directory just to check for support.

Assisted-by: LLM
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Documentation/ABI/testing/sysfs-fs-ext4 | 21 ++++++++++++++++++
 fs/ext4/sysfs.c                         | 29 +++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
index 2edd0a6672d3..8abc5706f459 100644
--- a/Documentation/ABI/testing/sysfs-fs-ext4
+++ b/Documentation/ABI/testing/sysfs-fs-ext4
@@ -116,3 +116,24 @@ Contact:	"Theodore Ts'o" <tytso@mit.edu>
 Description:
 		This file is read-only and shows the pid of journal thread in
 		current pid-namespace or 0 if task is unreachable.
+
+What:		/sys/fs/ext4/<disk>/encoding
+Date:		September 2026
+Contact:	"Gabriel Krisman Bertazi" <krisman@suse.de>
+Description:
+		Displays name and version of the encoding set for the
+		filesystem.  If no encoding is set, displays (none)
+
+What:		/sys/fs/ext4/<disk>/encoding_flags
+Date:		September 2026
+Contact:	"Gabriel Krisman Bertazi" <krisman@suse.de>
+Description:
+		This is a read-only entry to show the value of
+		sb.s_encoding_flags, the value is hexadecimal.
+
+		============================     ==========
+		Flag_Name                        Flag_Value
+		============================     ==========
+		SB_ENC_STRICT_MODE_FL            0x00000001
+		SB_ENC_NO_COMPAT_FALLBACK_FL     0x00000002
+		============================     ==========
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..bc1c59d67eed 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -32,6 +32,8 @@ typedef enum {
 	attr_clusters_in_group,
 	attr_mb_order,
 	attr_feature,
+	attr_encoding,
+	attr_encoding_flags,
 	attr_pointer_pi,
 	attr_pointer_ui,
 	attr_pointer_ul,
@@ -161,6 +163,25 @@ static ssize_t err_report_sec_store(struct ext4_sb_info *sbi,
 	return count;
 }
 
+static ssize_t encoding_show(struct ext4_sb_info *sbi, char *buf)
+{
+#if IS_ENABLED(CONFIG_UNICODE)
+	struct super_block *sb = sbi->s_sb;
+
+	if (ext4_has_feature_casefold(sb))
+		return sysfs_emit(buf, "UTF-8 (%d.%d.%d)\n",
+				  unicode_major(sb->s_encoding->version),
+				  unicode_minor(sb->s_encoding->version),
+				  unicode_rev(sb->s_encoding->version));
+#endif
+	return sysfs_emit(buf, "(none)\n");
+}
+
+static ssize_t encoding_flags_show(struct ext4_sb_info *sbi, char *buf)
+{
+	return sysfs_emit(buf, "%x\n", le16_to_cpu(sbi->s_es->s_encoding_flags));
+}
+
 static ssize_t journal_task_show(struct ext4_sb_info *sbi, char *buf)
 {
 	if (!sbi->s_journal)
@@ -283,6 +304,8 @@ EXT4_RO_ATTR_ES_STRING(last_error_func, s_last_error_func, 32);
 EXT4_ATTR(first_error_time, 0444, first_error_time);
 EXT4_ATTR(last_error_time, 0444, last_error_time);
 EXT4_ATTR(journal_task, 0444, journal_task);
+EXT4_ATTR_FUNC(encoding, 0444);
+EXT4_ATTR_FUNC(encoding_flags, 0444);
 EXT4_RW_ATTR_SBI_UI(mb_prefetch, s_mb_prefetch);
 EXT4_RW_ATTR_SBI_UI(mb_prefetch_limit, s_mb_prefetch_limit);
 EXT4_RW_ATTR_SBI_UL(last_trim_minblks, s_last_trim_minblks);
@@ -333,6 +356,8 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(first_error_time),
 	ATTR_LIST(last_error_time),
 	ATTR_LIST(journal_task),
+	ATTR_LIST(encoding),
+	ATTR_LIST(encoding_flags),
 #ifdef CONFIG_EXT4_DEBUG
 	ATTR_LIST(simulate_fail),
 #endif
@@ -483,6 +508,10 @@ static ssize_t ext4_attr_show(struct kobject *kobj,
 		return print_tstamp(buf, sbi->s_es, s_last_error_time);
 	case attr_journal_task:
 		return journal_task_show(sbi, buf);
+	case attr_encoding:
+		return encoding_show(sbi, buf);
+	case attr_encoding_flags:
+		return encoding_flags_show(sbi, buf);
 	default:
 		return ext4_generic_attr_show(a, sbi, buf);
 	}
-- 
2.55.0

