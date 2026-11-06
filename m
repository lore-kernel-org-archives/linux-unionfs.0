Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938294;
	b=Y9CHVTz8joo7NUgvHX9vWZECTecEQ6c00XGnzIv7fsMjmjtVMrSxMJqi4cxnNReyEdYa
	 0qc/bziaZ0WV1O5Ve5JhByzel2sni6fffIww1pq3TTpgsEsVJVoLanwKwbFGgtBk28GpA
	 t9OELG8v9ccN2457kPpaE8zr1dYUH94/xkEUxdSoFdUPQX0EKc4D82ZWG27IrR9EevaMu
	 QcYPm8MSD5GFsPIYwBloICgTpcsf2EGzLPfNp619X3gcBkvyJqPMqwkp1xR6ccMm6Cwql
	 GvGwzVa8CV05zHNNnIPortFO2+fajThvyzXmF/wLkg6jNAKsNeE9/aB6Cj58+rpolMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938294;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UXv3DjTO2LLFBsmZPtGA7kNZEfxgdi2hpfVKVbn4VTA=;
	b=B++FAxSjJM7bOHyHVHy3Oux8neg66o803Tw0OxZbz7P2I5m//LN9TGSFaOJbZTwAPqeC
	 2sQuTG415GX3Ritrdx9Lgiaz42GiFaQcJ2Ag9YEyemuAblbUvx7BkqYnV5FRWpzRDcNVO
	 IhCpkkDaTWDa7h9ZqrguRFEXZlhTa9a0xwhgxNgl4xI0K3rYVeP+xWou8Src59jhl7PJs
	 +mrZ7euX+Jzpx8r2gMFjKlGDLYq2mKkA6040SZuzRvbe6zSs1N+UbtQ11E13r6Iu4KsDk
	 4uSa15NReH7YouqfxLf6oae7HR6XwU6vel0lA34t2xDiKT+XWoqnmxE4bVW/bTpfTRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U82msg5P;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3200B606A328
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3200B606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U82msg5P
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so28346866b.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938292; x=1794543092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UXv3DjTO2LLFBsmZPtGA7kNZEfxgdi2hpfVKVbn4VTA=;
        b=U82msg5Pm2cIK6BCX02AARih2EMsbfY6XvYbPdOLHr0RSCSzrrnErekTZo+k4llKOy
         bs4BiTkg4KeqCSKW2wSmwU6m0CCpIl4j182oSie3d3JjXqHyt33FskdHkPuhzkn5goHq
         fms+w8jpyWzEQfDF3nGAITCWR4ixnR0kOUc2bVJX9hk+bcPn0Yxgdh+WOo//Rhe8PWc5
         u4WZgPZ/7S4fS89QY++6FQd5hpYS3M/Y5OWBmaTI3CN+RYW/vbeKodIev1AZyrVv0ha3
         V2YcLF7ttNFPtvZ2Ik3+cngYCcip9QYXE5g8Qb8TQbXeW9IOpbqDXdP16nng/yLvf4o+
         HcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938292; x=1794543092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UXv3DjTO2LLFBsmZPtGA7kNZEfxgdi2hpfVKVbn4VTA=;
        b=ufT+jKCJUcWxKt5sDC4gZHglYtGtWvSv7AxGvQgjvKkDQh1OgauH5QZ0qqnD25mJok
         JpssZYq1X7ildqOc0SkuS6NRnwSNt8lEy0hxD0enii6AIHOGboBnHHrgf6HHRZiQmfNh
         RqRG9P/ExVYFsc8QSqZPz+JlhovViB1PTBjSUZgs1Bs9fjPbBe2dehXBMNNauZe8fCdM
         jWSFRegUDFz+/5FoN1ZURE3Fn6kAdx1dtR08sg7pV5dsI5F+LqB/l+/9Yufmb1al7nCK
         /9wbTC95kbf6ilnN/MahxoYDeNtqdjIPRZuX9MW94J/WZHOMuFecvpUQ9Qg5HmKcOl+H
         +qmQ==
X-Forwarded-Encrypted: i=1; AKwUvBxegs/uuru8WqjbbE6K5jB5hpSKDsQsKrSHRhnh/Iv9yvneHbTydMaqM0RKo01BeNjpAeI3ljLhsB++zLCG@vger.kernel.org
X-Gm-Message-State: APuU4Z9asuTTJpxL5bSKJnk35T+fruH3DleIQpHfxOQ0igIydNvPDCF3
	D9zrXuu9xu9RUv3b1IHfsSse2ZbFHiMg7Ct0qPjwPpDk8Dg5yYSb2gGe
X-Gm-Gg: AYBFou2MJs57avkFQYVJPrRsLBHCoe+i7t0mNK8ZlFAfrp1lbL5PnKsMqbXSesPgnM7
	81YPbMG65+F7nDBzNTEBpjrwzJcejyKHCF1UX1ocHPyM7mXsMRjNPpTvZC8rd0AUiXM0SvgjpDa
	pGRPiy/k5ldZa7NnxgSIJJF0RcqB4ERrgfOWtNliywcl7GXYIuGl/IDz9UXyRtQb6bJblvSBpKZ
	lEP41GAWn7Thsu1z9atiG4dtKv9YbPgTlQy9PvR9pnPRJUG38v9rDqjgk/UmumBMpwNnwQ86mcc
	hWfXPoSsl3LBQLkFqppl7GKMEn4eHe0NoTXJZeR6A97uVuIQmT7FzwTBBBx8ULFsg+EBsut8I4j
	WylbdCj0UKQSpEmZpSMcVj1B1qZp6Qj18KE1fRQFI9sxQGa5aXaXSHShsVpFPQfbDC+tnpZUwU+
	lgomy3oogRglFBR8QpoG17YaHIlEpMThWeSbsdEPWUjbkOpDxNabQNBubN0aZM7N+rffbFhhI/H
	s2h4j2qUTr9jsA8DE46MV4mZwh6xInyfYKWAae1X+TyzAYoi5JHprgyN2VlXCI04J0Zfvcm/mJ5
	kP9WkpWKebdD8DKTh+rmUnoBhujZ1IxnEAz+azXtzgJNHPj0NW1RjzLLymMSR6WFZeIePnDhODH
	K6/1Oy/QCl9/AojD86spGUDgV4KY0GwJy
X-Received: by 2002:a17:906:9c89:b0:c46:ca3a:10d5 with SMTP id a640c23a62f3a-c4d35429e22mr109924866b.45.1793938292114;
        Thu, 05 Nov 2026 20:11:32 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d35673731sm41209566b.44.2026.11.05.20.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:31 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.1 3/3] ovl: do not copy up a dentry that was removed
Date: Fri,  6 Nov 2026 05:11:22 +0100
Message-ID: <20261106041128.3797453-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261106041128.3797453-1-amir73il@gmail.com>
References: <20261106041128.3797453-1-amir73il@gmail.com>
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

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no start_renaming_dentry() and LOOKUP_EXCL, fail with -EEXIST if
 the target of ovl_lookup_upper() is positive]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -708,7 +708,14 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto cleanup;
 
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_positive(upper)) {
+		dput(upper);
+		goto cleanup;
+	}
+
 	err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
-- 
backport

