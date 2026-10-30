Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793359928;
	b=GfM7pBYt0U/tnLZBE2oh707Hu9QG8OvuaoMhDliTOHBluWrEXuG9tFzC3PBBinqpEBeM
	 C4KHlQ9+Q5Vv4WyG8WxY1bFStWHh9tLte40Zu+ishChgYqSITvn6q3xTgvmG50gDhNjtm
	 GKrnI7nr28G3bhZ6aUhXoArHC6of14XqO0CTLNBtUaeLjveaFfFy7knQyk7xTcCJpzC/a
	 wwk6U6iFm7w3wIaf13cCg//G9SwdWgcPNnbP8yFMgx8CEMDGO5oPXploZlQJixGDUX/Yn
	 Lfb/Oxv996lgQeC2kEmfM9kDstzAxxgi3hlgS4iKAY6kWWGZecgIpUPlYEGqWHLzzlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793359928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cnrRz73SYKEZ4qoaWJL9gqpOklZcWfVKHKWX7WhjJh4=;
	b=VNGZpC65uxIP18pqCTXv8NeN2qZbtVBmjVq0YKAfg6UT33jn0b4GICXS/12CCOCZbWL3
	 vmZBpVvyJ1w3zPMwHg3amwxUY9eA9w4UISpWtJV2rOpbrNz83PqX5w16YR8HjT80iNNOd
	 uqO2JgfHUYDdb8LFMQjJc4/d3XU7h5PyA8jJ/TXIFPoRCA4fXE/yNzQOQgJ2TweTa84DF
	 zndSkipxrqhrLBCHNRFVAv3Eu8/2CZPHPYTnC9nZ1nuPzvl7f/TVEtA2LMS3jBk04u42W
	 ix5T+oxabbrC3Q7yywVYShGNGNXkCvAJthS2xW1uAWhbp+5xEed5PhOEBHUBAMMqRAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="I/N8n4zJ";
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CBF606A323
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 11:32:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92CBF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I/N8n4zJ
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e6eb21a8fso235455f8f.1
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 04:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793359926; x=1793964726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cnrRz73SYKEZ4qoaWJL9gqpOklZcWfVKHKWX7WhjJh4=;
        b=I/N8n4zJ0pVbzD40Z94Q2ezmntxchgRlk4DXCua+1wNeZIVA04dhL8D5347VPjCzDC
         9/ken7Rvq+kD491Mg9zZOGL5RCh5Ry/G33EV52jr3ZdDcMP/Sm2UVhH79gqawm56GS9v
         jvECGs3fqgIWpUrSVNEJXWC1/oc9cfxGtd3FTvLYWJjinx1uF7dlzqUa4/2har6i+whg
         1M76PaPA6ywJVXV3SkU7XoD/fqZjsfkJwMpTIJ5J+5DEUVzAW3EN2Tox6hx4IwlQcNmU
         7pdfOGnFi2ceQJJ3E+EdR3qWd0SUivOykTNcpRsqqIwsUCn5vJCjX7f9CKQaVe7tdyqC
         wkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793359926; x=1793964726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cnrRz73SYKEZ4qoaWJL9gqpOklZcWfVKHKWX7WhjJh4=;
        b=cVsP1ab6AZQngxdE1s9g/XRGjPQbhK3gZRs1O30L3esmadf/j6lRvhdXP2NGiSFgCQ
         VIZGGWTMXseboxp0E5tNzWMJoaTOxKpUL91fzWf4qcySJ3LBeEnUSp0An/62h9K9Byjv
         95MgxZQRUSc75HKRj2qSjl/877kO3LRHPE/lutob6pz7S5u0smxQowV+P+qNcudELWv3
         zbQy8oEh3veMleYUXblX0Ni8GR2fs27Rh+fBLCZ0QTCYIpjTqMGPY648PB8jMaib83jF
         HpDGoQ2CNSBpKrLB8UtSUihtmx1p5aK4tcAvOEyuxaquxkhX55Rb1xytRR4qVIBLcLoO
         9Yxw==
X-Forwarded-Encrypted: i=1; AKwUvBwq9PHdjMPCJAFHxSdssqvXtXRJg2Pt2RIhdkwz1NHomggQleU7QWXhcG9tkmzBNbBXbCadaFcFzDtiUyGx@vger.kernel.org
X-Gm-Message-State: AFq9FYJSvYWozKdbk8jeYVJnLuC0JVGDSbShBJGw+0fTbKyy4m0njLj7
	5axynLLZmEsHpI+1/suZqfI6vmX2347gvNe4ro/103M/GyVnYLtnHMGD
X-Gm-Gg: AYBFou0MtelZAQMBR5V/NfPbBddLHrNEhkMsDQMmzpp7SyV+HA2NYWEAx+us7bkpL7N
	KSN/DxwtO4ClHTf+1ILePEBEtak9X/ELNkcdIa4QR9iLQpcwny1OB2Rme+7UO405BV7orPasw0A
	Gv2iVcNlwSmFbEDbZjTtaqiCR5Po+qI9VLby8/dLhPb9ZF8sZNzAIA0lITYWf7UNu1Hq9WAMYWA
	15FBaYu6RixSlCpaNWmONZf7fete7ccyXS+eXjFd+sVCeT814/DzhFftJu3r5wme8MdPKUEWJxa
	b5cYqkOvfacCvA6DAxF3lAgsOsCvKVdynR4WW8IhN9NssdBn0G3EdtktPt+d6ApGQXhxaCmsKGp
	eqveS5as6GB8Fg/gK328w6tEXHTiqKCuC/1Qaw3bIvUD51wJf7QhW+flI5DZrnXInvA21gdM73p
	Rxy6vA3Hipste0BQuG+orQX2mt/5fj4TPdBxXXyqXXn01UxwH5NG4YFbDSPpI6APfe9ZzKKi3kA
	8iTzhICttk6YAwVXJZlsTPN9V3Xv/3vc934sbp3aRDGjgUVeWVmFVXs5w7ZgN49Iu0+y7+PZbFz
	KXFttWoKhCGLOojlTbfDhqR6y2vwMseXH8ajv63KufWOC3dNVGL+oE4lJWoe4mWJMZLmEUzGRL/
	YoIFtjsK+C84=
X-Received: by 2002:a5d:4c8e:0:b0:48e:1c2:55a1 with SMTP id ffacd0b85a97d-48e6e500505mr3857722f8f.52.1793359925697;
        Fri, 30 Oct 2026 04:32:05 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8c6e9sm2708834f8f.43.2026.10.30.04.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 04:32:05 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/3] ovl: fail the mount if the casefold flag has changed
Date: Fri, 30 Oct 2026 12:31:59 +0100
Message-ID: <20261030113201.2921633-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261030113201.2921633-1-amir73il@gmail.com>
References: <20261030113201.2921633-1-amir73il@gmail.com>
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

From: Chris Mason <mason@kernel.org>

An unprivileged user in a user namespace can repeatedly trigger a kernel
warning with their own overlay mounts. They do so by changing the
casefold flag of the topmost layer's empty root, the top directory of
that layer, after the layers are set and before the mount is created.

The casefold flag of a directory makes name lookups in that directory
case-insensitive. All layers of an overlay must agree on casefolding.

ovl_mount_dir_check() reads the casefold flag of a layer root when
fsconfig() sets that layer, and saves the result in ofs->casefold. The
mount is created later, by another fsconfig() call with
FSCONFIG_CMD_CREATE.

The casefold flag of an empty directory can be changed.

The casefold flag of the overlay root must match ofs->casefold.
ovl_get_root() copies the flag from the topmost layer root, as it is
when the mount is created. On a mismatch, ovl_get_root() only does a
WARN_ON(), and the mount continues. The check is not a WARN_ON_ONCE(),
so each such mount warns again.

An unprivileged user needs CONFIG_UNICODE, and a tmpfs mounted with the
casefold option in their namespace.

Reproduced by changing the casefold flag of the empty upper directory
after the layers were set and before FSCONFIG_CMD_CREATE, with tmpfs and
ext4 layers, and as uid 1000 in a user namespace.

Fix this by replacing the WARN_ON() with a check that fails the mount
with -EINVAL.

Fixes: f9377faaeae0 ("ovl: Add S_CASEFOLD as part of the inode flag to be copied")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b452b8c5f6417..af13585709cfc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1372,7 +1372,6 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
-	WARN_ON(!!IS_CASEFOLDED(d_inode(root)) != ofs->casefold);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);
 	/* root keeps a reference of upperdentry */
 	dget(upperdentry);
@@ -1556,6 +1555,17 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 	if (!sb->s_root)
 		goto out_free_oe;
 
+	/*
+	 * The casefold flag of an empty layer root may have changed since the
+	 * mount options were parsed.  The root inode owns oe by now.
+	 */
+	if (!!IS_CASEFOLDED(d_inode(sb->s_root)) != ofs->casefold) {
+		pr_err("casefold flag of the root directory has changed\n");
+		dput(sb->s_root);
+		sb->s_root = NULL;
+		return -EINVAL;
+	}
+
 	return 0;
 
 out_free_oe:
-- 
2.55.0

