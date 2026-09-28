Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5004E9C16;
	Mon, 28 Sep 2026 21:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631140; cv=none; b=X+DEQ9xdBbbuDH3/4g+rDIh38e8yxZIXdJOm35sU5L0yztmAWaz2+kSY5xjqeD6MQFX5e3apJgrJXglNem7QXnedBkVTQgNKFC79fSTznbmrree33HHDFHP9YRwamKLzWu8qINAE2gxIy0xQtutwKlS1wE42/XCHTsDByVgQGS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631140; c=relaxed/simple;
	bh=dfQT7WImhTwj84rmJTrlnHI3PS/5LuaMfZj+m9vC+ks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AX0UgFVPq7r5+1py6P7YXpBJ/VI84qr+00BMBYOamSi9aeOO+5k4k4Mot2qP8bsqJkXFalJKaWRm22dxtUOGhCAh+0qmdwRQN3cSGHlGgEQrT+SoKBbvNXZ7rAq7YWeQCdY5f6FTEjaovbavy/1EcnIjW/jsw7+/R5kbVy9LaOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0w2fQHyA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oOmX6cu8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s0z9NEtt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TgOEQmUv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0w2fQHyA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oOmX6cu8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s0z9NEtt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TgOEQmUv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1530D1F399;
	Mon, 28 Sep 2026 21:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=0w2fQHyAcr8/hNkn1q6kWi4QHof21q5V//SgtFlybSbGAoS88w5Esn95j8d67fiqD/3/WD
	Dqo9UYVTDjpm0OXkIW7H+VKFvoX9sci6cDFFW2cJaHlI5p6YaqVDPZ52h63tBm+osuvG8I
	5nD39gaY3J4GN2w3ggFFsKAd9xMmDXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=oOmX6cu8PaeLUh2yFxZ7+uZQZcIHN3tJXZaJtGRFS4EjClr79oIZb35JEpNtb/DdFfpR4R
	PUCoshraaYNvYUCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=s0z9NEttE6n9iAaAuyBRYxWEFNScItaY0Nh+Gsc1J/WdhBkvSTh1OAZEa1F8i88+E2jFya
	EWteEDJBZQLif+w2jQ5f4aOrLVsDNNTZ1mBo8x/R28BApIrx97Jsnn3sG3Q72KjakWGXGD
	GASNm9lDhpjpRD1UdR1+W+TAtgspNgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=TgOEQmUvPyvvyilCHFezLEljruw2urh0b9a2Zfv9Vw0N/7ZD4UBi4uhzC6JQlDdp0h4DJ6
	s2bcXaydg8iz/WBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76A89133F1;
	Mon, 28 Sep 2026 21:32:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +DMZDtTcumqMMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:04 +0000
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
Subject: [PATCH 0/4] Expose encoding information of volumes
Date: Mon, 28 Sep 2026 17:31:51 -0400
Message-ID: <20260928213155.2612039-1-krisman@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Spamd-Result: default: False [-1.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.de,kernel.org,suse.cz,mit.edu,google.com,gmail.com,vger.kernel.org,szeredi.hu,kvack.org];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

Daniel Tang reported [1] some inconsistencies in detecting filesystem
casefold support on shmem.  The problem is that we don't expose the
casefold arguments in /proc/mounts for shmem, requiring you to probe the
the filesystem to discover it.  More interestingly, it can be a problem
for programs that use /proc/mounts to remount filesystems, making them
to remount "case-sensitively'.  This apparently is a real use case in
linux utils, according to my favorite LLM.  shmem is fixed by patch 1.

This made me go look at how other casefolding filesystems expose this
information and found it to be very inconsistent.  f2fs is the only one
doing it properly over /sys/fs/<vol>/encoding.  Ext4 and ovl don't have
nice ways to expose it, so the remaining patches replicate the f2fs
interface for them.

I considered a /sys/fs interface for shmem as wel. It makes sense.  But
since shmem is the only filesystem where casefolding is a mount option,
it also makes sense for it to appear in /proc/mounts.  Considering it
doesn't have /sys/fs at the moment, it does fell like overkill to add it
just for this file.

ovl also doesn't have a /sys/fs/ entry.  But in its case, casefold is
derived from the lower/upper directories, so it cannot not be set in
/proc/mounts.  For this reason, I ended up plumbling /sys/fs/overlay and
wiring the encoding file just like ext4 and f2fs.

[1] https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-desktop3/#

---
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Daniel Tang <danielzgtg.opensource@gmail.com>
Cc: linux-ext4@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
CC: linux-unionfs@vger.kernel.org
CC: linux-mm@kvack.org

Gabriel Krisman Bertazi (4):
  shmem: Report casefold setting in mount options
  ext4: Expose the filesystem encoding through sysfs
  ovl: Add /sys/fs/overlay plumbing
  ovl: Expose the filesystem encoding through sysfs

 Documentation/ABI/testing/sysfs-fs-ext4    |  21 ++++
 Documentation/ABI/testing/sysfs-fs-overlay |  13 +++
 MAINTAINERS                                |   1 +
 fs/ext4/sysfs.c                            |  29 ++++++
 fs/overlayfs/Makefile                      |   2 +-
 fs/overlayfs/overlayfs.h                   |   5 +
 fs/overlayfs/ovl_entry.h                   |   7 ++
 fs/overlayfs/super.c                       |  26 ++++-
 fs/overlayfs/sysfs.c                       | 116 +++++++++++++++++++++
 mm/shmem.c                                 |  11 ++
 10 files changed, 227 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-overlay
 create mode 100644 fs/overlayfs/sysfs.c

-- 
2.55.0

