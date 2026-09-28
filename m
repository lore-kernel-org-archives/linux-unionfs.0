Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146924E9C16;
	Mon, 28 Sep 2026 21:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631148; cv=none; b=G/+rHFzcICPZlTgN394CQ/prFSbx307pCKiLFkjQ+AtmsxxbFvBOp/JQzbo0aCwEdzTBd86Pn58e2nD0lD1174RwtpZDohM+uZmgmZvC3sYg1vaM3LmjfK5LofpIq3GP5vfAYlqMhdV2XXKA6jSSvvbUvaH7KLnQ4G+YHRMrCys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631148; c=relaxed/simple;
	bh=1Fyfk0g9lSYGHNXSGDZ36Re3tqLELZTlXFUeAhmRxgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs+oeBEumLmAhRHzomvlE6oYE5yZcV3YCl3n03k0CYnH25Zh59aF0tPx5dBsvClAdlsx2OEi6EABl3ESssqQI6762NOvr0ZyFKpjBDu5Zc4kxw3Z1LK2nJoyN7DQkDg4cKr2nNFI51+Xq8hA0XTJYdQ1ae3CFjzJ21NUB1lUj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 538B01F828;
	Mon, 28 Sep 2026 21:32:22 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E09E1133F1;
	Mon, 28 Sep 2026 21:32:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pF8PG+XcumqkMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:21 +0000
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
Subject: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
Date: Mon, 28 Sep 2026 17:31:55 -0400
Message-ID: <20260928213155.2612039-5-krisman@suse.de>
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
X-Rspamd-Queue-Id: 538B01F828
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

This patch reproduces the same interface from ext4/f2fs to have feature
parity, so users don't need to rely on parsing dmesg or trying +F on a
temporary directory just to check for support.  Note there is no
encoding_flags file, as none are supported by ovl.

Assisted-by: LLM
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Documentation/ABI/testing/sysfs-fs-overlay |  7 +++++++
 fs/overlayfs/sysfs.c                       | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-overlay b/Documentation/ABI/testing/sysfs-fs-overlay
index 9060c39679ae..7f3c6403c4f8 100644
--- a/Documentation/ABI/testing/sysfs-fs-overlay
+++ b/Documentation/ABI/testing/sysfs-fs-overlay
@@ -4,3 +4,10 @@ Contact:	linux-unionfs@vger.kernel.org
 Description:
 		A directory is created for every mounted overlayfs instance.
 		<volume> is set to the device major:minor.
+
+What:		/sys/fs/overlay/<volume>/encoding
+Date:		September 2026
+Contact:	linux-unionfs@vger.kernel.org
+Description:
+		Displays name and version of the encoding set for the
+		overlay.  If no encoding is set, displays (none)
diff --git a/fs/overlayfs/sysfs.c b/fs/overlayfs/sysfs.c
index be83b57f637c..2144cbb418bc 100644
--- a/fs/overlayfs/sysfs.c
+++ b/fs/overlayfs/sysfs.c
@@ -22,7 +22,22 @@ struct ovl_sysfs_attr {
 		.show	= ovl_##_name##_show,				\
 	}
 
+static ssize_t ovl_encoding_show(struct ovl_fs *ofs, char *buf)
+{
+	struct unicode_map *um = sb_encoding(ofs->sb);
+
+	if (!um)
+		return sysfs_emit(buf, "(none)\n");
+
+	return sysfs_emit(buf, "UTF-8 (%d.%d.%d)\n",
+			  unicode_major(um->version),
+			  unicode_minor(um->version),
+			  unicode_rev(um->version));
+}
+OVL_SYSFS_ATTR_RO(encoding);
+
 static struct attribute *ovl_sysfs_attrs[] = {
+	&ovl_sysfs_attr_encoding.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(ovl_sysfs);
-- 
2.55.0

