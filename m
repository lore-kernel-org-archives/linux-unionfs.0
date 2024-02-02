Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB25E17C70;
	Fri,  2 Feb 2024 06:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706856064; cv=none; b=rLd0V94MLVDeIfy0T3Yhh3+X0R2giU5BosF6AX4cuCO/2kG3Ey3GLiTs1+REuUjbyF7Dis7E6EecW9mewgAj8raN3Z4Yyov+qAvnGnlln+jWzd6zHXvAol9ZOzHRpuhP+Q5YjOYTZBmVygG6iNT8UqkH8GaqhPSX3A1IPe5E8UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706856064; c=relaxed/simple;
	bh=jFIsbtcawxtlkzBWmPk/7brBIP+Y0YV24DG22v1JgNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ikizMmAvT7LmebcRfNx5+YEAPNXsKTwysLM9HKPzjQqHBF6UbvRt61F12H5W/X8bQ+Y1G38Crzu8tRExuQw3g5myuzUbj/B1naUzU1Ohoc/fIB/sSGOd0ejqouX7kZGa63Z4QSXgajfakTgcnYYqF4VYMA6pL2zp0p2hw52gY5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RQx4f0dR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6q+PKRLx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RQx4f0dR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6q+PKRLx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RQx4f0dR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6q+PKRLx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RQx4f0dR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6q+PKRLx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BFEAD220B3;
	Fri,  2 Feb 2024 06:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706856060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rUhUytqgWjkLOMLTSjtzcsjDoAxzj+px7kQNNMHruqI=;
	b=RQx4f0dRNrv8jOE+Nosu8r3pXwc0Wmdq538Tp5hPc0R1k1cMmzbSXpc4xYI7aAXR/9lAiB
	bTNfoS1LcIL4ENMSROsXA3FH3LP5T4ZXGJc3lbPZpxzHbWCTjIhQv+ERRg9eB853AatZqv
	beKlcwC0HbgEcO6wOoLFfog2ZZh1o3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706856060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rUhUytqgWjkLOMLTSjtzcsjDoAxzj+px7kQNNMHruqI=;
	b=6q+PKRLxDUFzJVoAB9sW9IDitMxrT+2YjfbkybNmo02XJ2pjiHdGmTuR+DM81DE6lIDl9C
	8p2yhOevpeVtHTAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706856060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rUhUytqgWjkLOMLTSjtzcsjDoAxzj+px7kQNNMHruqI=;
	b=RQx4f0dRNrv8jOE+Nosu8r3pXwc0Wmdq538Tp5hPc0R1k1cMmzbSXpc4xYI7aAXR/9lAiB
	bTNfoS1LcIL4ENMSROsXA3FH3LP5T4ZXGJc3lbPZpxzHbWCTjIhQv+ERRg9eB853AatZqv
	beKlcwC0HbgEcO6wOoLFfog2ZZh1o3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706856060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rUhUytqgWjkLOMLTSjtzcsjDoAxzj+px7kQNNMHruqI=;
	b=6q+PKRLxDUFzJVoAB9sW9IDitMxrT+2YjfbkybNmo02XJ2pjiHdGmTuR+DM81DE6lIDl9C
	8p2yhOevpeVtHTAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2461E13A58;
	Fri,  2 Feb 2024 06:40:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 80ozMXqOvGU+YwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Fri, 02 Feb 2024 06:40:58 +0000
From: David Disseldorp <ddiss@suse.de>
To: selinux@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2] selinux: only filter copy-up xattrs following initialization
Date: Fri,  2 Feb 2024 17:40:48 +1100
Message-Id: <20240202064048.29881-1-ddiss@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RQx4f0dR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6q+PKRLx
X-Spamd-Result: default: False [4.69 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[24.28%]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: 4.69
X-Rspamd-Queue-Id: BFEAD220B3
X-Spam-Level: ****
X-Spam-Flag: NO
X-Spamd-Bar: ++++

Extended attribute copy-up functionality added via 19472b69d639d
("selinux: Implementation for inode_copy_up_xattr() hook") sees
"security.selinux" contexts dropped, instead relying on contexts
applied via the inode_copy_up() hook.

When copy-up takes place during early boot, prior to selinux
initialization / policy load, the context stripping can be unwanted
and unexpected.

With this change, filtering of "security.selinux" xattrs will only occur
after selinux initialization.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
Changes since v1:
- drop RFC
- slightly rework commit message and preceeding comment

 security/selinux/hooks.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a6bf90ace84c7..b17247d66b24f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3534,9 +3534,10 @@ static int selinux_inode_copy_up_xattr(const char *name)
 {
 	/* The copy_up hook above sets the initial context on an inode, but we
 	 * don't then want to overwrite it by blindly copying all the lower
-	 * xattrs up.  Instead, we have to filter out SELinux-related xattrs.
+	 * xattrs up.  Instead, filter out SELinux-related xattrs following
+	 * policy load.
 	 */
-	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
+	if (selinux_initialized() && strcmp(name, XATTR_NAME_SELINUX) == 0)
 		return 1; /* Discard */
 	/*
 	 * Any other attribute apart from SELINUX is not claimed, supported
-- 
2.43.0

