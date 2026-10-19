Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792452747;
	b=txOlVJI/sSIy6+PtM5uC/uK+dE7mVvLc1BDLEcOvFyr8LTCgS4AYn3oTI3+BNczzgkyU
	 koHKvaYVHMVNXy0q1eSjUorxyB2G70zmdttGQcoz6UBeFYryJQ5l3es6qPadGbSlGql+a
	 1PK4hsGg9pWLl6bqFoy5GFyJZYf1bLGJPWobGr+DfUGHfkBoDbWO4qjjw7i+bQBJPlqIl
	 pCWQ68dKngJl76jGSPs0T1GsC62xPS+yL4bjWLz0eFSxOCLg63xj+1REWjaaxbO1myGsY
	 k2wjVMJ8ZUrmKRbvUcXkIjCdTH70EPOJ5N5FqliP/Yt7A7wCR+4OTdI2XFxGxi7oHZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792452747;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=e/4/nuHPVA5Rc7pcd7JGJCfAuSVxHB+gr6Y1QG32cPA=;
	b=Y9CucIjKI0OOREB4LDuryifm29FEr3J7P9KO34JkygAKmI0u25hD8OWzbFyE4/zRKk5J
	 SSpDlEUryw3+b6rQJXK8hyWPQFwryx43AuWpa7YlC7EDtla/+/GL4RXQ67uO87X/oNzR3
	 dWfpjWhjTwVQM8HmS37wQjtBK6Wo6gHL2VUdcQlCvqiZweMX4ZimZ99lTiSSkFTtRl0Us
	 UzsXQQAyHdFhZqlZQIipvIvnTX5wZSFhxN9kHfC/tFOITnovFILbA29Cs1GR7vi04f7uY
	 hvZ+fA59lFzru9I+BIyd0RO49u1MRa8PJBux/XQBV6x2DSg/IjvwS7HQ0JkiDz6HYpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bq6ruBC3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4586C606A33D;
	Mon, 19 Oct 2026 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bq6ruBC3
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792452746;
	b=zMnm7lVB4s8ITeTM3pv0KQ+fM53/r7SdkqrUDH7YSWPCOH1sK3lu/ZoWz20rbq1TNXZ9
	 z4tCw6jpNIaC2Uoa/OesH47bZpjG9bEYHHBlA2UHmhw/KO3AzfnbJbTHKZrZ17HMNhpEf
	 dQ6KOz649NtYNKyBmTYdWYzILE+LHqkiylaKBI7DMZy3LF0nMqgKKszZoLMP3Cj7chkmj
	 s314XJAA5qAC26rdm5WmbVAa/P5Fz6QMsHa/dNk8jJH/gMJv9a+vFMkm8NCWn/AJQxB9Y
	 f3GIQECB7TiZYFCpbV1Aub1LeV32fO/MSUnYn8i7yT0zXiUrKsaxhtbKXCXLxr8S71A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792452746;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=e/4/nuHPVA5Rc7pcd7JGJCfAuSVxHB+gr6Y1QG32cPA=;
	b=hSTtYNkFBIa1npBfBCwnsjWEBzBIep+l8bSES4qyJbh2Mz6H2zApFyTGiZ4umExU4/p/
	 HIiEf4QqD1gaEBvibC03H3l/DhN0c4OPmePTZPtQ9zswwcYMmy3tisgI1Y9JBFL2P/RLx
	 7rIRTEog1mJgAD9iBZuQ9BnDa4Sr1sPUhJiTAlAd7b49OHOPD2/yLq6icJNhtRDaUZQSt
	 E0wLsdAQ1oY5yPzN68ooUnu2fc3sSEAKSNTxYXIJnwT9xLXxsKWSWkG5f9C4he8c4cAFK
	 S/ZxzUbo31G2b1+aSwFYteaAH5wYCMDKOcRMFfA0ixfkmcfni95tdYvZy+XKH2va8Ww==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5017A1F000C5;
	Mon, 19 Oct 2026 23:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792452746;
	bh=e/4/nuHPVA5Rc7pcd7JGJCfAuSVxHB+gr6Y1QG32cPA=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=bq6ruBC36jORNLeQfWC9Z0LMq/v5AgDhhm68ejXSxMTNGeKGPDMO4K9j0/qPcSvp5
	 dkPYgR1pdlW1NDwpsXwwL0J/AyBHQEq9f01wk4Q50nbAlz0wc/0iPmiTIIzONSr+C0
	 GaSwsYEWnMh1hygzJQfolwC6z8zBglsiy8x59Qgj0T5pYlxjLvI2yJuyr1ejFykIjc
	 baNzwl7WUZ+7B9CIyn3t6Re7T1FsdKX0s4GZtgGY4f+Yq36Fv9Kw+FtSx/YGbiMxu6
	 /gLOu+d7Q4x2goT6lpZPP7tYQMbGJBjGmBjvrBxPpfHNrgnoaVSDcZx1/voczqztc5
	 XK8x0YdwOYjdA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D1DD1400AB;
	Mon, 19 Oct 2026 23:32:25 +0000 (UTC)
From: =?utf-8?q?Cl=C3=A1udio_Fernando_Pinto_via_B4_Relay?= <devnull+claudio.studiomoob.com@kernel.org>
Date: Mon, 19 Oct 2026 23:32:26 +0000
Subject: [PATCH] ovl: say that only the capability to use reserved space is
 dropped
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261019-ovl-comment-v1-1-499b532b69de@studiomoob.com>
X-B4-Tracking: v=1; b=H4sIAImo1moC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA0NL3fyyHN3k/Nzc1LwSXWNTC5NUM+PExFQjUyWgjoKi1LTMCrBp0bE
 QfnFpUlZqcgnICKXaWgB7XG2abwAAAA==
X-Change-ID: 20261019-ovl-comment-3584e63aae25
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792452745; l=1558;
 i=claudio@studiomoob.com; s=20261019; h=from:subject:message-id;
 bh=KXvEZ5G4Kj83Jeh1CpWL8I93iCpOGNPJqUtMEL2j73A=;
 b=k1RpYgvbOWFTm33t5Hs8KNeba/OwD1daCjGvJuC3aPSimW7C/7BwDDHxoa/zF+WWTutjcP4z8
 Eu7JfEPEMB9A4Mi/zx1/fzX6Po+YM/bt6ExG3DtsgoYs7dCPGTNOMPe
X-Developer-Key: i=claudio@studiomoob.com; a=ed25519;
 pk=cJXPz68Qvj2c2L6TWJsYP1yNYCU+KA1USyC+oykJv6A=
X-Endpoint-Received: by B4 Relay for claudio@studiomoob.com/20261019 with
 auth_id=1246
X-Original-From: =?utf-8?q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Reply-To: claudio@studiomoob.com
Content-Transfer-Encoding: 8bit

From: Cláudio Fernando Pinto <claudio@studiomoob.com>

The comment above cap_lower(CAP_SYS_RESOURCE) in
ovl_fill_super_creds(), added by commit 51f8f3c4e225 ("ovl: drop
CAP_SYS_RESOURCE from saved mounter's credentials"), says overlayfs
never uses reserved space. Lowering the capability does not stop ext4
from granting its reserved blocks by fsuid: with the default reserve
owner and a root mounter, a write through overlayfs still spends them.
Say what the code does, without going further.

Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh0g1MtgCO7Q2f4yJP5vq5rLEiiXHbVfeCxwXB5ff4-VQ@mail.gmail.com/
Assisted-by: LLM
Signed-off-by: Cláudio Fernando Pinto <claudio@studiomoob.com>
---
Follow-up to the reserve report after Amir's reply: comment only.
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bd0a3f9039..21d0cb8719 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1508,7 +1508,7 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 	else if (!ofs->nofh)
 		sb->s_export_op = &ovl_export_fid_operations;
 
-	/* Never override disk quota limits or use reserved space */
+	/* Never override disk quota limits or use reserved space by capability */
 	cap_lower(creator_cred->cap_effective, CAP_SYS_RESOURCE);
 
 	sb->s_magic = OVERLAYFS_SUPER_MAGIC;

---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261019-ovl-comment-3584e63aae25

Best regards,
--  
Cláudio Fernando Pinto <claudio@studiomoob.com>


