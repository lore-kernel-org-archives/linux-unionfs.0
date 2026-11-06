Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972229;
	b=Ptfop+4xZ5kjDIunCSQHm2KBlA4aUW9NmTXBK7T/YKB946AawhZlCUYPvfRkF4ttFwmz
	 AvJtQ76XA3sSoeXsLRsD6iZ70ykJORQGPwRDeYpugrwIgSmWACiVujnuD6G6NNL21/2Sg
	 YOZ+jnxiOyEdPIwnpVSFqCc/hxkMt/CVBFm6QKvlgL5nwB9DLTIs35Hi24HEZIZ4eqttx
	 Hkj4dVtwcLd3/c3x3pqIfOgffgvy2ueoeSqGVx9N/fmHcYDh4Dw5dhqNpP2bvlYeW19l9
	 oU55MxEiAAk+qs3OyAf0sZWLTYxu3QVBjyOi9mVGpLDi4JfaGZ9Hmcln+bav2r/qBMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972229;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=aoZSxD+M4Ix3Nzdinv/kkvM8PFIKv0qH9kj5OB/mLsY=;
	b=s/uw7uqXa/pNkqcepjbjR7mg0fdVmYJTJ9fwPnjsXyhWoUSLTGghzgAdtzx36/mUJv8a
	 2CVH0BcAAEGSPNPLkTlSrSCV0KwZMA6UX/l4jrwIzpChMYbBnpPOzSk6VZ9pmQ0VCiSCV
	 bflAbbQQVdtUBtJFPFdgFvVDDys0byalTwV776GDVsndjhSi9NWUNvtWflqzyHAsp8+wr
	 UWYgXMhGfoiePAodfxVlgRWR9CvuuiLVwCztTt4WMzN65xEBxVW3cmhpOnLkVo8+W0JAZ
	 oDzQG9NHk9AJCr5pTgCoCTsbNyK7clbxhLRMbFUehSNp2gDkUgqUrQxSvEHvhE2/7Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=EOIY1qX1;
	arc=none smtp.remote-ip=209.85.160.179
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A816F606A33C
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A816F606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=EOIY1qX1
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5364d86f7f0so7068641cf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972224; x=1794577024; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aoZSxD+M4Ix3Nzdinv/kkvM8PFIKv0qH9kj5OB/mLsY=;
        b=EOIY1qX11hRw/xhofNwHlde2BW/gZLNG3g5NViKPdF1DRopQ3uBRzoHHVhKT3WajUH
         KVYMTVmFKwzIz6G61stuPke7PQoM5t1gNsJwSAXv5UTdbxfaG2AO0hP4P1h43giIqeAo
         g0VjMJkPgi81+pBH+ASezpiosfKAmjNE/CsMfCc8JqOBZas4To0n5f9YPlgWTv4O4JZT
         43xq86Zqz6sY+2ca/UaZLXFkFdAFBpKeM5xKTanQ7exkblvfSz9cIvty7ZQB4vZSUPKZ
         CZ/5+0dRSgwbKPJ5UG9kL6wEW4m289TokPmy3P6rXypzzOuNYEmKa3VxcPF8lhaeFB4W
         l+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972224; x=1794577024;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aoZSxD+M4Ix3Nzdinv/kkvM8PFIKv0qH9kj5OB/mLsY=;
        b=k5aRAkXSNWf40PI324kkS3syEM5fdeWYz05l128zpFCzDYAp+Ik0IvfhKIDgZxxRhC
         9RL8M2L7xl2sk6JitFCcbUvQKw82WhMU8p1MfITAQbvcLErlcZdJ6iKobbcgAaP78s+K
         mM+d71L2+lkzQmDKo9kYeNoe/E8A7PYCCRa2tidCVvxqqY2gqH9kppnWSPtVLgwHDxEI
         9X3Y+dd/3ssHmwQPufwdXQeCpmef1tbqBXL3nXXs/mnuKMeK0Vt+wli9lslJFD2YQ68t
         xGPnvAkBoZy8FqaOkzUvAgVCGdxBuXyldUXZsKQ1yHWatzg+HIfETNIkEnf4UHILkcRl
         Peng==
X-Forwarded-Encrypted: i=1; AKwUvBy4kETjE+y3niBq5ON8ByAQpr6TeZSR4DMfiSY5nN1FOd8FDV6HdQeJirf+kz79r2JMrYrMbhEqIJ74F50Z@vger.kernel.org
X-Gm-Message-State: APuU4Z+kKcaQlkGpTb7anDJ1XqXWqLFTz0iWQEcaCaPd9ZAuIrhNvVPZ
	vSO6et3FDxomHDvU7QeXuwizVSt/XRXSKb+RoP7b/sxKr0+PGMN3mostt1xP3irKojQgESEJzvl
	M2kSfp7wEdw==
X-Gm-Gg: AYBFou0sPfl8o0V4Y1U3/ynJ0eNty/+jWPXrrX2iQW6W8c24dMHaW1F1eKwJcrsuAlU
	aNP8ww1MAWzi0sF+pCfDvwuRxuJKKg7acJnpwnSyq54X6niCB3v/BM60VW4Eh+dDjqmnFeCIVW+
	hpGbA65JhVaOC2bKVRkiBOSfHTymaD4dGtXXKWVCemT8L352OgRYociAoZ+zg9jRXOoLxWXes8h
	bbKzG+p7+9Ldr9qN+hzBSui2WFlcVe4dWMWycazP9mj4/9bz18pPigpPox7ZnEfam8LAdgOGIMs
	nuk8cYorJ5MI2eQlfa2tI3qYpj08IsjdA/rwcVhXPvE1KZBpLPqOZDSv9UuMON/G6JpCxvr6oGs
	l9JcflXmHfHFqghrXQQ4WhZOM+5iMUbEsYpIVvCia88VkOj+eToUKTFvvvEP/XqIzv/IvSrtWSF
	PwZ1UxtJg7LAKBBTsgiUYEb7wJlnLcx1bj6XsjPD0lj7OxjJ+jtC9SWjDt3gG6oW+Q00hCmzngO
	eO5SObgFhIF7fhBaY++q8yz8URS2jSeBUVhKGWoExE1aVirsEo+5jI/LroSOuCiHMrY5tCjxniD
	Og5/JYwUSte+sFqfEnPZ8TmSPB/L+P9i1ADldQpVqaz+Ow==
X-Received: by 2002:a05:622a:4117:b0:549:9438:8c47 with SMTP id d75a77b69052e-54e1309dec4mr38780521cf.23.1793972223702;
        Fri, 06 Nov 2026 05:37:03 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e270179f0sm20538911cf.26.2026.11.06.05.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:37:03 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 06 Nov 2026 13:36:45 +0000
Subject: [PATCH v4 3/8] ovl: make the root inode appear hashed
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
Message-Id: <20261106-b4-ovl-containerized-sync-v4-3-6ddde0b7dd8a@toxicpanda.com>
References: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
In-Reply-To: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=1088;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=b2F4eGdbpOMxJXXK78nupdaZI/TuEjSLWoRn4Q7cKAw=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHJ31XEy6WjwNNRqX2i98eblVslKDYOiu+4N9/wDk2vVO6TSNHfrhlaeuyrPUhIhqIPg1Ru4EWt
 FHgpEiohP2gA=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

__mark_inode_dirty() does not put an unhashed inode on a dirty list, and
the root inode of an overlay is never hashed.  Use inode_fake_hash() on it,
so that the following patches can track it like any other overlay inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 22a8d4eb3b7c..9eb6a5e485ee 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1371,6 +1371,11 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
+	/*
+	 * Nobody looks the root up by its hash, but __mark_inode_dirty() only
+	 * puts hashed inodes on a dirty list.
+	 */
+	inode_fake_hash(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
 	WARN_ON(!!IS_CASEFOLDED(d_inode(root)) != ofs->casefold);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);

-- 
2.55.0

