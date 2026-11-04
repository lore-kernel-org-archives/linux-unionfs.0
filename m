Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818540;
	b=h3wLydqX50iwJNUA17BmZNFhNR0VQMlhN0LwREi8XfJih8bhIoxcQcJNczzxEj1I4IvG
	 G/VNLkkMqMSFKsMsekfGphZWXEvyxZoqhd7Y9Aq/phenrXk/s0X7/9ytMj0/kQ9mE5+iS
	 niHFuJXlSJvtMHXQfNpw0ehuNS9/Aj/t7f474MiqGgDd01DZEsDPLIOLnvrK265mxAAFl
	 qXd0pp+g72mtLU+BhQeArm7QNDXgYmRiQ+Di5ruBeCl45esDCiEAekkq8qLy4FZuhRA8D
	 7uZy3ShyFhVWHDl4ZVWf7NMzONAkOP82MQ/7qknVFxzjqmkOoog4kgmzf+S4S6wor9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818540;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lJ9oFY2f4SSxHAugcTyJowGx3KfjwtaAECBMXqE4R2o=;
	b=LJQyRWfOf0sbF03l89ET7w/3zkzg4czVV3PJYlNssNwREl6Yst4xxT6Ao33L2Z2G5oWL
	 Gb0hZ34EPIFdWWE+yEdgqsG1KMPPaI4Bl+AUvA7QIMhSuizcYvt2+5odlwE/f+KvP8AwV
	 SzADpRojwXFkfrtcA0OvvZz4UO22gnY2mWXMpUjOsUOiHCDfDsnrdIX/1HQQeB1KtRfov
	 ahZExTf98Rwb8BttFKXkbUrNCl6fcb5emmCYtEq/+d8zd7MOj1BjwtmX+DsYdIYo+CjcH
	 k6AS0cyQS/7OzjqylBahV4pfWmKWgVgdSVEBm8c02jjKvOUv7Bcliuwz4rXF0geyR3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m8BXgpez;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E0B606D809
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8E0B606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m8BXgpez
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a208d93758so11821955e9.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818538; x=1794423338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lJ9oFY2f4SSxHAugcTyJowGx3KfjwtaAECBMXqE4R2o=;
        b=m8BXgpezTv3Wd1N0PQZlR95qtaN6nSFi4sYXFhljOYLto4MiT5wuHpPnUHdxtUYYp2
         n9Ob1kQsyslCDkr1MonzSRLtMVd3SuaTGdBe9lK/AAz5czYcI0Vl/OAbmBK8kx/To8ZN
         j0hrpFSMeY/u4azd5DkFs7U35AXXwM1bSsI1CWKrowIaezSc0E+RmEpw4F5WlM4YEEkG
         SpWxbLGZvee8KrcH/ZRyM7qPIIIJpshy5H2+boSxIJeV2dyju20tvlUz+MWCS59fxkNE
         UgbXfS4FUAHS8C+NtrS/iLvC/yH3CRyiqnrvt9dEa0xpyL0pg+D/zL/cqwAn4dzB4F9l
         LrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818538; x=1794423338;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJ9oFY2f4SSxHAugcTyJowGx3KfjwtaAECBMXqE4R2o=;
        b=Hj1pI/G2xKNpcFCu4o0REPuarzKPghs2DL6OygrV6+M+/16gBQno7OKkJSoEQkYE9S
         SyTQydeQWlzb6A4BpbK/o71JQSfyEBqVKVNe8F/iRrY9XumtADy+B0G3yfWScObGqQz4
         q7B8DlxBv0CpRuS7KrHW+YolP1Bd8/NbRdsWIQHx+DVQT36S76MsLZo/cxO8cEIlwXYA
         /no5Pv8923awnKNEy4ix7Q1pxoo11mG1ZOJUfh/vNCAuFdYpF35iIvy3+Vca2HhKlMDj
         Vw2Ut5/AJGQ03jDgThhsw6GQeKGbqZ2tDD8wkf467Ari2kEZVVWXq2JkKmHd0jbW5m0f
         1oUA==
X-Forwarded-Encrypted: i=1; AKwUvBwZnyJssOawXrDIVBIqmzKkc6t6ep4pSHIjiAlTtsq9jTt6k+Ng8kblZ0f0/yIHJElnkhsEA9Utq22z4185@vger.kernel.org
X-Gm-Message-State: APuU4Z/t47WY0uWxcW+K3UMHN3lxXqMyhzGOYum5bAf+GtKNkCmWi6Rd
	V8ZjO0qWAL24wcnvXXvRS3x0GrVyr8Zq6S+W8gdHX4arQqGpkBES0qQt
X-Gm-Gg: AYBFou0MZEbzHTygz9zc20oRR1N8mY5ae3NXt/YII7l6rH+Rup0TqJnlyTCBbZ2lSEQ
	weFZe03ERtoBRxH3t+Hlj9PBlBeEZ9a491P5cljOCpQ8QKMnC4k3leSpsNmHIVdCaHfi49t8f12
	B1yA5Ed8ycnpkbxGGm2kKyvD5w+H8u5USL9mpnOoHkTAiGuPkzqxNVKo1voqXHlnqQRyTxy7EZo
	47EyeAbyGeQs617UlHCCFeDJt3vjBczQGj4U50nsNAm12baOYyekYGD3ExDK1nLGnLQF+RWxMgl
	oc6o9g+k1TSZTyx305/T2yZ0GV7MJtm9ofhmAKzkK4gfmfIvoKAyJir/svhsJ5cSTKrkSg5xJum
	OUjrV45s6uPJUiozJ/8qOsqi3KxGHVJTHaqxAdHt2AOYUWQW1RWU7487tMtHWx0OqljyyULoF0n
	coL1a2AREgTRENDdpxqId+PPeQe/O0YA59h+12nwgUU/EMRbbi/wnlE3Nxx+ATF4NW0HQFefX8Q
	a52Mezd1jSAv/jeFKkib64rakdzkqkBRpggQAuxOEsctlNIyFHWu0kwMaktHRyScwFPC2TAvmbG
	pDYnoQN0bMTjvB+ZS0OIG6Um2n+hs30MQz6Cu5SAcCFg5/NlL2+c/6oo2QvxFHPHM19bLwtIYSi
	7Lv06HV2jA0Zi
X-Received: by 2002:a05:600c:8b5c:b0:4a1:fe55:88ef with SMTP id 5b1f17b1804b1-4ac1889c4b9mr405197805e9.20.1793818537981;
        Wed, 04 Nov 2026 10:55:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b57317cb8esm3831625e9.13.2026.11.04.10.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:55:37 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.1 2/3] ovl: skip copy up of empty security.capability
Date: Wed,  4 Nov 2026 19:55:35 +0100
Message-ID: <20261104185536.3631167-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
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

commit 50912a1715b8a7c614b654011a0db750e372b43e upstream.

ovl_copy_xattr() gives up if it can't read an attribute that
listxattr() has named.  An empty security.capability, which anybody has
been able to store on any file for a long time, is such a case: it is
listed, and getxattr() has nothing to return for it.  A file in a lower
layer that carries one can't be copied up: it can't be written to,
renamed or have its mode changed.

There is nothing to copy if there are no data.  Go on with the next
one.

Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: treat -EINVAL as no capability too, and do the same in
 ovl_copy_up_meta_inode_data()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
[ backport: context: no blank line before the ovl_getxattr_value() call;
  depends on e6b9117076fb ("ovl: fortify ovl_copy_xattr() against
  underlying layer modifications") ]

 fs/overlayfs/copy_up.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -47,6 +47,15 @@ static bool ovl_must_copy_xattr(const char *name)
 static ssize_t ovl_getxattr_value(const struct path *path, char *name,
 				  char **value, ssize_t *value_size);
 
+/*
+ * Any user can store an empty security.capability, which fails to read with
+ * -EINVAL.  It grants no capability, so treat it as none, like no xattr.
+ */
+static bool ovl_no_fscap(ssize_t err)
+{
+	return err == -ENODATA || err == -EOPNOTSUPP || err == -EINVAL;
+}
+
 int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct dentry *new)
 {
 	struct dentry *old = oldpath->dentry;
@@ -98,6 +107,10 @@ int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct de
 		}
 		size = ovl_getxattr_value(oldpath, name, &value, &value_size);
 		if (size < 0) {
+			if (!strcmp(name, XATTR_NAME_CAPS) && ovl_no_fscap(size)) {
+				error = 0;
+				continue;
+			}
 			error = size;
 			break;
 		}
@@ -947,9 +960,9 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	if (c->stat.size) {
 		err = cap_size = ovl_getxattr_value(&upperpath, XATTR_NAME_CAPS,
 						    &capability, &cap_size);
-		if (cap_size == -ENODATA || cap_size == -EOPNOTSUPP)
+		if (ovl_no_fscap(cap_size))
 			cap_size = 0;
-		if (cap_size < 0)
+		else if (cap_size < 0)
 			goto out;
 	}
 
-- 
backport
