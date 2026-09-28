Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F934BD34A;
	Mon, 28 Sep 2026 21:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631139; cv=none; b=mtJE95NeRkynVxO8711ae0jE/8K2mY8+dK1HSm4fd357wQczmlMtTxHhQJYP66Hvs4N9yNESfvARdC8Wh1X8JfSFvEZTU2kjO5KTkwuIWFsRDkoEq1e5hRGsXGq5Oq/ACXpmdAutS/5g7fIxwG8qsLIzghf4adKCc/sT7RAPxN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631139; c=relaxed/simple;
	bh=kTq7D01mZfVLBs9GZqHKcvD26t1F3rdqaNq9+M1lUBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9y6B8pMvolgswGJpA8zaJoP9pxNuQgaCxbL35cq8ap5LOz/t++ZpAmvFZ5vnbLVclR8DUMM0hOkaOu0lcJ6Mv2fV6y3iP0pSdf8nin1vva2PP/WeQSOIQnbWFLRc460dVMGIfVKn1ktUqISVKaE8JawSzbajE2La6Ivh8snwgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rEU0ai8L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dVKd4DNZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rEU0ai8L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dVKd4DNZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rEU0ai8L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dVKd4DNZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rEU0ai8L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dVKd4DNZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D6961F7B8;
	Mon, 28 Sep 2026 21:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=rEU0ai8LGFM25EG+Y+s1TttWWZGb17L+bIKt5K9DuZXFB26heWLS/VnzsNKyyLMcj6rILD
	jZ6/sj7whA2vf5A5DszizPhpkx5QyNu1V4CrQ6MEVy2VV/dWbXpfIPbqJIfTI2KwbSy/xr
	n4Y4VDspksNKAGczDTgw50bcbpTM/Gc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=dVKd4DNZkFZJnQtj7/2O/bgaM9Jexu4l9O8/19TecRXs0WVhJZfVUBxyqaNby2K6/04rpF
	JRxg7t7/wdwwtuBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=rEU0ai8LGFM25EG+Y+s1TttWWZGb17L+bIKt5K9DuZXFB26heWLS/VnzsNKyyLMcj6rILD
	jZ6/sj7whA2vf5A5DszizPhpkx5QyNu1V4CrQ6MEVy2VV/dWbXpfIPbqJIfTI2KwbSy/xr
	n4Y4VDspksNKAGczDTgw50bcbpTM/Gc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpV5kne6nJmEIw7EQKGVoptq5OaJEMiFIgo7cnXo60c=;
	b=dVKd4DNZkFZJnQtj7/2O/bgaM9Jexu4l9O8/19TecRXs0WVhJZfVUBxyqaNby2K6/04rpF
	JRxg7t7/wdwwtuBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C98141340F;
	Mon, 28 Sep 2026 21:32:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e7PoHtbcumqWMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:06 +0000
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
Subject: [PATCH 1/4] shmem: Report casefold setting in mount options
Date: Mon, 28 Sep 2026 17:31:52 -0400
Message-ID: <20260928213155.2612039-2-krisman@suse.de>
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
X-Spam-Level: 
X-Spam-Score: -1.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.de,kernel.org,suse.cz,mit.edu,google.com,gmail.com,vger.kernel.org,szeredi.hu,kvack.org];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

For shmem, casefolding is a mount option.  Report the current encoding
and casefolding flags in /proc/mounts, so userspace can easily check if
casefolding is supported withour relying on parsing dmesg or trying to
set +F.

Reported-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Link: https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-desktop3/#R
Assisted-by: LLM
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 mm/shmem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..2b93fcbf5127 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4916,6 +4916,17 @@ static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbinfo->qlimits.grpquota_ihardlimit)
 		seq_printf(seq, ",grpquota_inode_hardlimit=%lld",
 			   sbinfo->qlimits.grpquota_ihardlimit);
+#endif
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (root->d_sb->s_encoding) {
+		unsigned int version = root->d_sb->s_encoding->version;
+
+		seq_printf(seq, ",casefold=utf8-%u.%u.%u",
+			   unicode_major(version), unicode_minor(version),
+			   unicode_rev(version));
+		if (sb_has_strict_encoding(root->d_sb))
+			seq_puts(seq, ",strict_encoding");
+	}
 #endif
 	return 0;
 }
-- 
2.55.0

