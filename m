Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236186;
	b=YC28FeBr6GEf3kGIVkm8BH3V71DOMoJXf3/DGYoWsdApxc0XyoElWVGYwFenC1fc+DTS
	 6IJC1FtiTomzIpwGtwh3ZRRew6NTXiYIQ1ALkmjHrnQBLltWAAdBbHlUeASLWVCXlgSsR
	 KfY07Z6fs1ZPlp3LI33nC4KiaTN7ASo/fgrHNZXOqK471+o8gmjbuR2/E8zBC8gbF4IUg
	 CEnYXhxKSw/xNqyiCHeTaPRB2AInbAU3SCb3zZ8hd8J7w7xR1R1EOHRnvOwJ/L2sb05kZ
	 SzCq6NbLs7nfoD9J/Woy+F/n8tXL9Z97iuZ0iJY+RcdrMk68fDQximj7Hjkrwg+yimg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236186;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=BiXk3LnzLtcIKZ+RZXwhxER6LjCnGDowXDanueGKs/U=;
	b=Zd3zC2bMF5lb8pJu8VISvkqqPPWYAPlihoMagKGfX3EspyWzcn5xqFOeMlMjfwGWLtJ9
	 4geIVLKVfO52+nqWpS4QKkPYaBTHvngOrdpU+asI/4dSw7dMfmfTVIXpPrYyC9Rn/s9vJ
	 7TfXK7+Z+dPS3ICn0ejsa4mB+t/CBurXVrl/3PfSIm0ih+7lp2femyUvSC4jXksqEFbmH
	 5T2zW+ugpE4c2oV3rYplpbT3CbeTrDv2bI+tTb9Rr1eGrWceQalv12PAHSuYuAdcYtAsw
	 XX7helkoaFE+AyKGUKzKx7V0mrk794QLPfIvyjyvcLrfdKp8XEoKr0hsBxoBwblC+qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=k6POx+Vw;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE3660A261C
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AE3660A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=k6POx+Vw
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c79a9a739so21023156d6.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236185; x=1793840985; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BiXk3LnzLtcIKZ+RZXwhxER6LjCnGDowXDanueGKs/U=;
        b=k6POx+VwXLuS454Rk3RAfevv5Rbq9wlQ9A1Hq01ZklXUQj3dZym1TOKwDFnVB/Qdf5
         l+FWo37Mxpduis8Co7XeDKm4cklUUanpXLPfec5gZ9UDu2TC90yzhu4BCUfe3EhfmMJi
         CTuTtmoS0hpdzcm9YS3RP9zN7tNV9E2Glvi6QjDjAnVZ83uVJfK0GrmuPyBYKElQ0fdV
         g0UskdWXxyu9IZ9ocSwFu5vTSBlVobRQFItoe+ZLI1yeIw8Bui63Pi/GvoYmSUXX2YPp
         3iXLqMFBW1jQJtTKOWrCOehxjMd7EJTKaBPRqaYaZFLfxiUa/c8bArsTkFyh13csNAu/
         DTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236185; x=1793840985;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BiXk3LnzLtcIKZ+RZXwhxER6LjCnGDowXDanueGKs/U=;
        b=i3sA8SHyQDThNGsUN7k/wSvxCFu7CHQ9TSxIE8dP3sGgec6Cbh24oqidT1XwgeEQfq
         BuJSxX7brdiWAaTOr/0lipZrRY+otPRHkcUKYv/oSU2MgwkvZWcUkW86dxsugkxCxx7J
         Oe8UvPg6DiS6A/29JJNjdqCEEiwQsHvzlzqcQMXLdxdD4SRajiI2YzqGV9JCW00yTTsA
         MDQv4fECZmKl1E5eum6EUJut+6EIEhQ07gBHxdlzINS9diRwKKS0YEXme8Cnj7tNYnmk
         c8Q9o/G4QvARi1HedMBe2bM10uamt/3wUFJ84xdkNzBArAzZmZDHLOUEiafpTmWcUQSO
         sjpw==
X-Forwarded-Encrypted: i=1; AKwUvBycc5oKVvxLEe684rbCCO0IqykI5pu68cCr2WjewvkjTjda1QZLWw1DnqzCjYPaZPgPfg+P0Mqp5csagWaU@vger.kernel.org
X-Gm-Message-State: AFq9FYJkyjBIgEISBWGD3Erz/snyC/vYk6gWO0Nh+l7X06EuXrwm1OGR
	hXzJVyKlZ8mb7i02QW746E5vvnOeNXv5wK/j1Ic1NP/XHA0FOm33+Hcp+c7e+Qpf8Ks=
X-Gm-Gg: AYBFou2kDs8bI+ujSIqDdwIJWFOLO3k/3p0PHbSoGsZjNDR73ww5c5XFZvA7Dh7mtYs
	nnNGh7NmrnKBJ/BUzvEYdSsc78lAoe7koasZafurL32XQALIA06WhJFyoJnFT845lUGG0H8isWn
	S2gYJqDAQ+OMVY+4yjnKHbO9RUc661pqO2iaL/GaJYhklHjLDyUfO2qRjSNxqKTWU5MeOBGXv7W
	fkV5XBV5TcnDBbhDCdTIklxBtuWLlU7Y+bwhY8wJuOU/esGfygbSsxBtUUTbTGOa/+ZvzvcwDE8
	vOehJd/X5pGosHrhF/SLKd91ZcxRtgX2FSSTsUfKlmo6sxBzWpwSJfN09A0709xDYTSfHaBY40w
	yDkv2sVo5yolyq9oE/sMK2riK9elSyEtJCFzCf0ILv+RUOSaWXd1XdBrLM+1tlDVwHGCWZgIvN8
	n1t0iFCLw2SKx6A+BjbxsCf3eUmEv1EoHMYnebU4TMozbAIDNwxSztKPJqlho1nrlTPnAZwlHLY
	iUrewy8CQWakSEyaw+GPMyCR/FTxnJr57leZaaDNOFhPe1cLvMc5SBb805PIylFXqEcbkxYOqMD
	58MPR7DCGQ1c4z7uoPjsIsBgiR6U1Te3mJCX/RVEqgx5E0jK8DpmhbamMAHDSF/e0EM=
X-Received: by 2002:a05:6214:29ec:b0:91b:5d39:e12a with SMTP id 6a1803df08f44-91c7d22de42mr64701606d6.51.1793236185031;
        Wed, 28 Oct 2026 18:09:45 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.244])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c944casm145482086d6.32.2026.10.28.18.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:44 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Oct 2026 01:09:21 +0000
Subject: [PATCH v2 07/10] ovl: look up overlay inodes with a key structure
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-b4-ovl-containerized-sync-v2-7-4e9f08e4a052@toxicpanda.com>
References: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
In-Reply-To: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236166; l=4274;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=43+Lm/Ais7eqXSWDLdD6bjwW5pngZaUXCbET4re2J68=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLiynhSHkVt6Pf5rMela6oglTCjXKZlOYkIz1IHWlaK8xQYb36CdTGfwdwJO576Efcyy49sV5hN
 KyrUmOfjWSAk=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

A following patch adds fake overlay inodes, which are hashed by the same
real inode as an overlay inode or a trap inode.  Pass a key with the real
inode and the kind of inode to ovl_inode_test() and ovl_inode_set(), so
that all lookups share one test function.

No functional change intended.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/inode.c     | 57 ++++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/overlayfs.h |  5 +++++
 2 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5895ee5aa771..88cec47d0bc8 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1069,17 +1069,50 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 	return inode;
 }
 
+/*
+ * An overlay inode is hashed by a real inode.  A real inode can have a fake
+ * overlay inode next to its overlay inode or its trap inode.
+ */
+struct ovl_inode_key {
+	struct inode *real;
+	bool fake;
+};
+
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return inode->i_private == data;
+	struct ovl_inode_key *key = data;
+
+	return inode->i_private == key->real &&
+	       ovl_test_flag(OVL_FAKE, inode) == key->fake;
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	inode->i_private = data;
+	struct ovl_inode_key *key = data;
+
+	inode->i_private = key->real;
+	if (key->fake)
+		ovl_set_flag(OVL_FAKE, inode);
 	return 0;
 }
 
+static struct inode *ovl_ilookup(struct super_block *sb, struct inode *real,
+				 bool fake)
+{
+	struct ovl_inode_key key = { .real = real, .fake = fake };
+
+	return ilookup5(sb, (unsigned long)real, ovl_inode_test, &key);
+}
+
+static struct inode *ovl_iget_locked(struct super_block *sb, struct inode *real,
+				     bool fake)
+{
+	struct ovl_inode_key key = { .real = real, .fake = fake };
+
+	return iget5_locked(sb, (unsigned long)real, ovl_inode_test,
+			    ovl_inode_set, &key);
+}
+
 static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 			     struct dentry *upperdentry, bool strict)
 {
@@ -1123,7 +1156,7 @@ struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 {
 	struct inode *inode, *key = d_inode(real);
 
-	inode = ilookup5(sb, (unsigned long) key, ovl_inode_test, key);
+	inode = ovl_ilookup(sb, key, false);
 	if (!inode)
 		return NULL;
 
@@ -1142,7 +1175,7 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir)
 	struct inode *trap;
 	bool res;
 
-	trap = ilookup5(sb, (unsigned long) key, ovl_inode_test, key);
+	trap = ovl_ilookup(sb, key, false);
 	if (!trap)
 		return false;
 
@@ -1166,8 +1199,7 @@ struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir)
 	if (!d_is_dir(dir))
 		return ERR_PTR(-ENOTDIR);
 
-	trap = iget5_locked(sb, (unsigned long) key, ovl_inode_test,
-			    ovl_inode_set, key);
+	trap = ovl_iget_locked(sb, key, false);
 	if (!trap)
 		return ERR_PTR(-ENOMEM);
 
@@ -1218,12 +1250,15 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 }
 
 static struct inode *ovl_iget5(struct super_block *sb, struct inode *newinode,
-			       struct inode *key)
+			       struct inode *real)
 {
-	return newinode ? inode_insert5(newinode, (unsigned long) key,
-					 ovl_inode_test, ovl_inode_set, key) :
-			  iget5_locked(sb, (unsigned long) key,
-				       ovl_inode_test, ovl_inode_set, key);
+	struct ovl_inode_key key = { .real = real };
+
+	if (!newinode)
+		return ovl_iget_locked(sb, real, false);
+
+	return inode_insert5(newinode, (unsigned long)real, ovl_inode_test,
+			     ovl_inode_set, &key);
 }
 
 struct inode *ovl_get_inode(struct super_block *sb,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d3a897e46ccb..f884e6695d2c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -66,6 +66,11 @@ enum ovl_inode_flag {
 	OVL_CONST_INO,
 	OVL_HAS_DIGEST,
 	OVL_VERIFIED_DIGEST,
+	/*
+	 * A fake inode: not the overlay inode or the trap inode of the real
+	 * inode that it is hashed by.
+	 */
+	OVL_FAKE,
 };
 
 enum ovl_entry_flag {

-- 
2.55.0

