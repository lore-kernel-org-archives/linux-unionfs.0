Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987071;
	b=u30LxZtgbkA0yWztCyDwEWgWqeN0KeD9+F9wRCbpvahX+FtKTbmRQ7NJxF2c5JexrCGw
	 DGPRmWkzpiwG4ap7bthg2YQddENKt+LA84yTz+po8HPnaUvUVBvnJoID13mLnxTsw85xD
	 TiWvg37oBItWr7GmMe1wqfy7vvEpvTQUXarloqqZCrP/gVXJeMS+eZ5ASQkUHTPSy3a62
	 herOgkLGP5u7eODrsG4eFzIEjtW65wMw/xmT3ZCktLxUVNzTTzy8R5RF9Mi5/vvRCyhg9
	 IZl7SXvaL6iG1xvmmtq/vdKF5WhhMvrFQzvxc2JBpRZX6Q3Io8LrkIjzgAMsS5g3O5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987071;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6lKW0ujd9UDNY4TAMk4udtdbjVtWDIVBiqP1Qlq7+s8=;
	b=R/FaFv9hRzVaxVK9A/eZGdI4MfPQ6LPcEkV8zY6j7SAMe+9PiF5/Gnvz+2CIZ8lCVnXu
	 8X2aKp3LtD5YeQbHhxYXVZDaa3MQ3zkU8TOgyeRn0uzJvxPNZr3apjATV03wl8mH30ZgZ
	 f5BcufCyx7Jt914ZBBoS6d9RR65JHkjIfBd/l2Q15AynpCupY1E5VbQRDExb5NA3x1Usa
	 m77m/xtPZmwstNPd1ql7PfXqvedhjdLb0jIlw960I3hkT0bIhujFJ7qR6tXminG1HgVQ2
	 snOXJOaywAF0bsfBlyiraTsyJbDAgWSlVY4Rf6ZsirVILB+VMQ125ZHIPQXpCpY62bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h6xHoLeX;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F0E606A332
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 07:31:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40F0E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h6xHoLeX
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b7a488a0a4so794807a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2026 23:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987069; x=1795591869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6lKW0ujd9UDNY4TAMk4udtdbjVtWDIVBiqP1Qlq7+s8=;
        b=h6xHoLeXt9A8vEZbPQ5YuZL5To3B9EpkJ8W1rInMtmUeDY0Skxf/A9EvEULifDTBEN
         k0brlUFnuN5puX1eiFIttTE5rvlvvs8ZrretRqBSAoaojIvRydefArfImBo3WRSxckjH
         bdP7Wp0TxMQLRv29NJmh1/7vAiEF3aFeZPOpsykGS4ggP0aGhJYpFOsQP6tyFiamnhE1
         tnbvbgdmKP/zMcLyU9HbxGul6jqC85KANfBsaY2pZhV2dt0aUHLloQ/lX0cajlILVjnd
         v0QUoRDlo2J33Jm8Ve4CbLysbM6GV3rptU6DBoyl8KtigVykWBA4PLvw5TTAOBvv8cBN
         N7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987069; x=1795591869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6lKW0ujd9UDNY4TAMk4udtdbjVtWDIVBiqP1Qlq7+s8=;
        b=d0VXfyQlbl6jbzJVyjbyqZN3Uno8PK3IIl0rc1RuINEuF5WgIrI7zBq3S7fxHA314+
         8n/xyFsTbyD/uGB3omTL7SaAoLnV/xpmKlUwlyQ/ckGkc+gwDLf/VclMBrjBE+eNU7Tq
         khm2KwrZvmgT3EuCn1/T6skO0Rf33ULahP3SPEylVGwaYPPK3JbiDzA3Mu+6J63SbciJ
         C+yVJv48FDqPTjWqMcPVtMFKCKrk+nKqcDBKrXlEt8bZVe8Ucnpj/f9nxgp4pMFhG+gO
         vb1raJIrlqFxk3dc4vSxrUWXEmwvu4QlVmZD+shR29w3N3lb/ToTwr7Chjv2Fa7UWxgZ
         PQow==
X-Forwarded-Encrypted: i=1; AL+hErEV8fHEmxzFbtVdey4avtjteJcnDKIzTClfUus/GcZ9EDlhsXKBVlXEofCBeYWy/xWbZSdisvA36GJXJ16z@vger.kernel.org
X-Gm-Message-State: APuU4Z+Pf6DDYrm7Kx/CQ08aaIX+65qc+WWpAOmNAeRgEWIuprtp2DYE
	g9MgZ0jEmJL7oExW7a4/h2wiOQSMl2wR1y9a7prTnFedZwbIh+XfkrpS
X-Gm-Gg: AYBFou1R3CU/j3IgTI0a7+tl2Uz1h5mdJcfmtHAwgc9VP/RduE42AoqMp1cjP25w+Kn
	oNv3oGPNPjeESTQNCigDPuyKLFRbd2cpsRiio3zBuMPJQ7NQq04144rW7l8pW3OeAIVQ+p5ORgj
	wvB6iZ+1g4/TRkq1fqmXPsbnR40tw8/WEUuxRt/+mVj6DFn7nQYP6i+PQ3UoBaOCCx32hOCyJYC
	T3EXGl/iR+5rxtWCI+VyikYGYgWVl2MCKjIKYrKsZ9VhdqHIS1OUrAlnrh0+kKdncL82WHcax1H
	PO20agtCxB8oNjsbbrEmxMO9+KU94wMJkGuMuy2WDYOuQhNdU4ePHh4XSBAQSBdYIc2GdpyMnTe
	B0m0XYm8hKOBoP3fy6TvGYSNnULdv736N5NptmNvGY/f+MhzuKZgvnlfuw6tkx52+CZ91/CthjX
	5s4w1gU7oJijbWpkUeNgDZoBnCXM1k2CCaSgprCiPFtRZS6YENx095qo7qKzBFs6ogWKOSIJJ4n
	N1ATX1iy9RG4A+LnTpC62c3+SSN4yhjdgB57MBYDMh+1t3S0I12XYB0AEBdjeWb4aYBj/cn5uq9
	Ey5b8wLzr7mjLvEyGIupjaJaw95b017vI/+2bE/JHuRthRujc9QWEByBqcUQHAGogynAtNOcftq
	fhG9vjnrYxtM=
X-Received: by 2002:a05:6402:693:b0:6b5:6ba3:5860 with SMTP id 4fb4d7f45d1cf-6b887e9a474mr896151a12.17.1794987069209;
        Tue, 17 Nov 2026 23:31:09 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b88993e76bsm691684a12.12.2026.11.17.23.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:31:08 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 6/6] selftests/ovl: use legacy setups for pseudo lower layer tests
Date: Wed, 18 Nov 2026 08:31:02 +0100
Message-ID: <20261118073102.1216568-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118073102.1216568-1-amir73il@gmail.com>
References: <20261118073102.1216568-1-amir73il@gmail.com>
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

Pseudo filesystems are only allowed as overlayfs lower layers in legacy
setups, where offline changes to the lower layers are allowed.

Kernel config defaults such as CONFIG_OVERLAY_FS_REDIRECT_DIR=y or
CONFIG_OVERLAY_FS_METACOPY=y turn a lower-only mount into a non-legacy
setup, so mounts of sysfs or debugfs lower layers that are expected to
succeed would fail on such kernels.

Explicitly set redirect_dir=off,metacopy=off in the lowerdir_sysfs test
and in the automount_in_layer fixture, to make them independent of the
kernel config.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../selftests/filesystems/overlayfs/automount_in_layer.c  | 6 ++++--
 .../selftests/filesystems/overlayfs/pseudo_datadir.c      | 8 +++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/automount_in_layer.c b/tools/testing/selftests/filesystems/overlayfs/automount_in_layer.c
index 0476c4582bdfc..c5bb12d524e5a 100644
--- a/tools/testing/selftests/filesystems/overlayfs/automount_in_layer.c
+++ b/tools/testing/selftests/filesystems/overlayfs/automount_in_layer.c
@@ -82,7 +82,7 @@ FIXTURE(layer) {
 
 FIXTURE_SETUP(layer)
 {
-	char lower[PATH_LEN], other[PATH_LEN], ovl[PATH_LEN], opts[2 * PATH_LEN + 16];
+	char lower[PATH_LEN], other[PATH_LEN], ovl[PATH_LEN], opts[2 * PATH_LEN + 64];
 	struct fanotify_event_metadata *ev;
 	struct pollfd pfd;
 	char buf[4096];
@@ -111,7 +111,9 @@ FIXTURE_SETUP(layer)
 	ASSERT_EQ(mkdir(other, 0755), 0);
 	ASSERT_EQ(mkdir(ovl, 0755), 0);
 	ASSERT_EQ(mount("debugfs", lower, "debugfs", 0, NULL), 0);
-	snprintf(opts, sizeof(opts), "lowerdir=%s:%s", lower, other);
+	/* Pseudo lower layers are only allowed in legacy setups */
+	snprintf(opts, sizeof(opts),
+		 "lowerdir=%s:%s,redirect_dir=off,metacopy=off", lower, other);
 	ASSERT_EQ(mount("overlay", ovl, "overlay", MS_RDONLY, opts), 0);
 
 	self->fan = fanotify_init(FAN_CLASS_NOTIF | FAN_NONBLOCK | FAN_CLOEXEC,
diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
index 954a9f25cd1c5..fbf32c3ea88c1 100644
--- a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
+++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
@@ -173,11 +173,17 @@ TEST(datadir_tmpfs)
 	EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", true), 0);
 }
 
+/*
+ * Pseudo lower layers are only allowed in legacy setups.  Explicitly turn off
+ * the features that may be enabled by kernel config defaults.
+ */
+#define LEGACY_OPTS "redirect_dir=off,metacopy=off"
+
 TEST(lowerdir_sysfs)
 {
 	ASSERT_EQ(setup_tmp(), 0);
 
-	EXPECT_EQ(mount_lowerdir("/sys/kernel:/tmp/lower"), 0);
+	EXPECT_EQ(mount_lowerdir_opts("/sys/kernel:/tmp/lower", LEGACY_OPTS), 0);
 }
 
 TEST(lowerdir_sysfs_redirect_dir_on)
-- 
2.56.1

