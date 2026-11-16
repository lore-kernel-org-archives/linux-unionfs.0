Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794857321;
	b=rt6YTGK8Pj82sNRMr9a0MyC1FgLbDSPcmtjMu948U4iJI+Y8tl+Rv9OXGujRO4rtKrPB
	 WHp9unE9Ngp/BWU6vfoQSt1xb1TipAiI9/S0gXOOkXhhBtx2S34C3Qexx26QLzyqBRF2f
	 JV0WgHCBuXWd6fSVxwY0lf9XUYOhdXt0WWm2u4+oE3p8gFntLre/gC67MZ/xVNyTIgwsM
	 Kod3sIcig2IS5UxKESRd4M+hSqNU/7f5XK0dGwmQPsgYELcse6/fjjzGADSnMDBc+JFk8
	 TxoJ8oG+VyxJCa1yIlobBnw/t+FmEoisIDOAWOSjK5dvP3aEFWNyi2rM21jHYvlB0ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794857321;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lTGurxI/Bgu5ZJqbmAvAIEQWhn+vjtZ691Mnb5crEUo=;
	b=naBVIhlyGQDhfrDA18ERXBDvUVQIeoJeaYJ23KZqBKAq0CHeJD09Bcz/8yHgQ7tr6Z/0
	 t1W+X2ESEWc2YmI4XLCD4ZDqSV6gYPemq0rSqUzuyL3a+HBEN56QLTKb0o7NsTcD6cTcX
	 f0lbye2VIzDUj54XVAlWrhAmtY2vV95BHrSFB57a+3ysh9ZuUPd2VcQtcZelfB6hy4n2Q
	 u9S0mb9NP91DJTZ7zfDsnaPCD5anaGVyzz9ChP0WTsmPaKjJ9lZY61NPpgZIeyb+3aJVi
	 Ykl8G/I7+F0oWLtnnkRfYV44NiFV3iGuJxsHWPeKGQh1k0mkXN3druiB1cg0lDYqQog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IWS+vIYN;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CB0606A31C
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2026 19:28:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52CB0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IWS+vIYN
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b467581b98so34020905e9.0
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2026 11:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794857320; x=1795462120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lTGurxI/Bgu5ZJqbmAvAIEQWhn+vjtZ691Mnb5crEUo=;
        b=IWS+vIYNTdhfojIsC97vmpuRmjoqNqaaD6dn7mB9xk5io9JNRFmzZghkuwUnVpqQQ0
         WfeOmKu2DY+luQqUS0yj1HuneQrBma3nmlMpAXgyXs8XQVh5ub7kXZFpxDmPCd1pO876
         0N0YqA64VlXu5TdlNugP8LAU0gUxWzfGHFqP5YxeDDjCuoaPIeYVdLJSAyewCrNZYbmR
         fmnL4UKq6YQds7/Ced+7TaG7ugcVIO3YJs/ZsuNQQoLFnwVtzHHPiriR5RCKi7BsO/FB
         1/w6xhVDPsl+qlPiphNEZVFdXUnyu2ISr7eVX8V4LEwYTOgCLK7o5HEUmsMZ1/uPjoTG
         B2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794857320; x=1795462120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTGurxI/Bgu5ZJqbmAvAIEQWhn+vjtZ691Mnb5crEUo=;
        b=nUYRO276/7Ns+q6O6s6zFeX9Q4Jirpewyd4JV7vE4QJVtnKIO0vkHxcPHU4FirqyOs
         JGCzQiTjnwHF9RK9pIONgjHbEkLCJ0dw9nh/QdX3NS38N1cHejss0R0fsEhc5YyPJ3sC
         JEQOUxFjZBYPPV8bMMsv7d3rShE/NbpykZ7a2JvL7NCdpqr0c5+b+l3gHu8Fr/JyZibh
         rcV+0jhonVs1trxi4yz5HedBXIsDuk8W9M9NL4MUBXJ3JnmlS4QUgwRUADh7bX1G/qow
         sav1G/361AmBX4AgVsXF0YUytFNBFMO0xHcxQR2w86QphAlNnp7prPCr1Fn9y7aiZifb
         HTsw==
X-Forwarded-Encrypted: i=1; AL+hErGXHhWNiJjv1SMv2q0N0WiJHAM8txX8lLNb3EkixNJj42DsxDhWDIinjzTEfJUzgR+rGkdrq0PGfggH+0T2@vger.kernel.org
X-Gm-Message-State: APuU4Z9nhZ+Uy/2JUCIUwLQkTvml5oGPXVXUTwvQnXnukM8V68z84LhW
	bv63VU0k94I45URJFjSq+ONkbL6nrdN8icsvDJ2ZKA8qFZFODN5Reb6p
X-Gm-Gg: AYBFou052ewkevrbNctPXRv+bYCOk9eYXnffTDGzIOTnOCSEOiwguAaklh6OKnIGzFW
	qrJkmFkfrVjQmgK3dZOg7Hqg4U5IsmS6sw+edxBThKMu9zBzu2AjeYWCzaQ9NZcezRNvleNfmG3
	XdpHo8qaKdfgvL3YNyEmB16/xpGTcd9/YwKnL7Cp9lGvH7MP1WJAtNNX7AlwEus0vFKxsDOrwCT
	YeKLxYcyJnTnGvni/jSmbEBwuT8dBQlj7PYX5HGiVEe0yS/Ne/7sGj/JoEsEtRLaOkWyemEreNf
	AzzA08qlNese3FiH/Bp4cKTLnJg2M9Lm2AcpWmq31HNcYwUTo0lyxe+olqH2PefGuELJS3RrIpk
	MKoIYMEhq9n71nIZ71UrN0Im8ctvrpyFdqFLBV3PZeUYQEwgt6pfHyLFPzbP43GUtIAqPKzb3ev
	Hllp+5mkeHpFlV3O2j6uSxfZqzbNICwozczbesATsXdmmsPVQ23Efk+aDoxHrdD7y9WCStmwKIE
	0x7ynTnsZgXdR2WiVPI8oI4tYQDMrj83EjlzHAfdh8aKqGAmqB66XbiYH2HkJGVONbS3digqwUc
	Q7bIqwGk6ZomxRjYSoQFK9AileQJrcaWjyG+AoDo3iOxLIQJ1CNWq7CVnUgMcy33iqny+ylNb7+
	0IFgUxq/UT7U9
X-Received: by 2002:a05:600c:8b65:b0:4bb:6a5a:783d with SMTP id 5b1f17b1804b1-4bb6a5a795dmr112896865e9.18.1794857319492;
        Mon, 16 Nov 2026 11:28:39 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb783965c8sm9641515e9.9.2026.11.16.11.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 11:28:39 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] ovl: refuse pseudo filesystem layers in some setups
Date: Mon, 16 Nov 2026 20:28:37 +0100
Message-ID: <20261116192837.937852-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

Using pseudo filesystems as overlayfs layers is a questionable practice.
Copy up requires that the size of the lower file correctly represents
the expected data size, which is not always the case with pseudo
filesystems.

None of the pseudo filesystems can act as a functional upper layer.
Most of them fail to create the work dir and the overlayfs mount falls
back to read-only (e.g. sysfs, cgroup, debugfs). Others (bpffs, configfs,
tracefs) create the work dir, but fail the mount later on. So let's stop
pretending and explicitly deny pseudo fs as upper layer. Setups that
used to fall back to a read-only mount now fail to mount.

Pseudo filesystems should have probably been classified as
ovl_dentry_weird() and disallowed as any overlayfs layer, but until the
introduction of the SB_I_PSEUDO flag, there was no way to identify them,
so we do not know if existing setups are using them as overlayfs layers.

Data-only layers were introduced to facilitate the setup of images
built with the composefs tool.  The data-only layer is expected to
be a filesystem backed by real storage and the lower layers are
expected to be loop mounted read-only images, typically erofs.

In a composefs setup, pseudo filesystems do not make sense and there
is no reason at all that those setups would exist in the wild.
So let's refuse overlayfs mount with data-only layers if any of the
lower layers are pseudo filesystems.

Data-only layers can be added via the "::" separator in "lowerdir=" and
via "datadir+" by path or by file descriptor. All of them end up at the
end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
of them.

Note that regular lower layers on pseudo filesystems are left alone.
Stacking overlayfs on top of sysfs without data-only layers keeps working
(for now).

Co-developed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---

Christian,

This patch applies on top of your patch to ban pseudo datadir [1]
and expands the ban to more setups.

I got carried away and did a survey of the pseudo fs as upper fs and
found that it is worth banning a pseudo upper fs early on, regardless
of datadir.

Note that the selftest will now fail for some setups that used to
be acceptable (e.g. pseudo_lower::datadir in lowerdir_sysfs) and it
does not test for rejection of a pseudo upperdir.

I will send you a patch for the test shortly.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org/

 fs/overlayfs/params.c | 3 ++-
 fs/overlayfs/super.c  | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index d1ca4a9094f28..496f4daa7f750 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -347,7 +347,8 @@ static int ovl_mount_dir_check(struct fs_context *fc, const struct path *path,
 	 * as the mount attributes could change.
 	 */
 	if (upper) {
-		if (path->dentry->d_flags & DCACHE_OP_REAL)
+		if ((path->dentry->d_flags & DCACHE_OP_REAL) ||
+		    (path->dentry->d_sb->s_iflags & SB_I_PSEUDO))
 			return invalfc(fc, "filesystem on %s not supported as upperdir", name);
 		if (__mnt_is_readonly(path->mnt))
 			return invalfc(fc, "filesystem on %s is read-only", name);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 990a470112c5c..f2c484b45b509 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1259,10 +1259,10 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];
 
-		/* Pseudo filesystems don't hold data for metacopy files. */
-		if (i >= ctx->nr - ctx->nr_data &&
+		/* Pseudo filesystems don't belong in composefs setup */
+		if (ctx->nr_data &&
 		    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
-			pr_err("filesystem on %s not supported as data-only layer\n",
+			pr_err("pseudo filesystem on %s not supported along with data-only layers\n",
 			       l->name);
 			return ERR_PTR(-EINVAL);
 		}
-- 
2.56.1

