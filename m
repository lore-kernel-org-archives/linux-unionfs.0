Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795160240;
	b=jHbJ8GArkpd1IOeT3l/jzRlI1WQ1uf91E4eZmeAuJx/hp/huZ6H3u2bfmQPuM+2fDPFv
	 A71mBe8TV1QE1oBkNJ5ucmAWVwaQ3pMSjeslkbhhw+dewa9bK/DTK7Fo6grEO2sjeeDjx
	 AB33tZepFC0hD3BsIw5UWoZOTBkPmkX52SzBs2C1KhynU3Y3TIUQNPQhU112L4a+PpAjz
	 AcmmgNsTJRrVW+oSPJyzGpAHsKLJNY4pm/v8wX19Rb2pkOLcPtbwHfUmuaCo26NaFRF0K
	 a1djznHghwOUlGrf4r7GuH0H6QlS+zMsA9WS+DKWqHFtbaMrgWKYL9E6kfueWvhUUtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795160240;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RoorVLMi62FuFQRrqrflAmA+uFRRnvjjHFtI7v/dMic=;
	b=xsHOxchDMG47993h21mYUZDYkiEec7B/FMnODTWbawfGQKdUFiZNdjYOjQLlWddseNSx
	 hqAOZ3RO1r78wPR0JeU3dx/KIJCAYsTkhRafklpmn7sRIC5HKDChW3k7LEhGiv9KEUdQ7
	 8IhASg+8cdSXbmw3KwyDy6Y+0vE9I1RF5sDXi0DDHELuNwH20xnW9Ej840UnQ/7GZlqXV
	 dsNJfiCBuo4J4DM68EjRZ2fzU6gyFvGl1nyf2Z+IKeyyTkL5LL10NA+MfJJH1CT8g5B+X
	 fLay0n3a5I2A+u30PSPvp+KYO1UUYeaZB6Eb2oPowL88TvQ49xrEDzr1qj7Cqbu2mkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hceukMgh;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2202E606A32C
	for <linux-unionfs@vger.kernel.org>; Fri, 20 Nov 2026 07:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2202E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hceukMgh
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so1063313a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Nov 2026 23:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795160238; x=1795765038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RoorVLMi62FuFQRrqrflAmA+uFRRnvjjHFtI7v/dMic=;
        b=hceukMghY7le6BIvmBla2eFNVCQIbmkpOBHR0Qmni9s9Tx5CJJVqMf3vpfilPmRW5G
         K5wgOLsqd9MAS1z6OmEN/CrYQRV9tFx2RXS6txqkQxbbd/dKWCfmrVKOilSn/zmap3b1
         YNsLVgq+Vm8OssuoTDaCUB7VlZ5YhvYFA+SIyOP0/6fykgUwThttvdaJNRdt+00yImGy
         +T4jsEnKlm3k7w4G0FPANL64WVx4J3DRwpm0UjGciS6HVC6q0moeniT6KYlLWLNDEAVd
         f5BhGFbkXk8GTLaKY51IysD3Ajx4lCQI120uvi9wU/CNygHwZmyVXAHogmXGeGP8PVSE
         HcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795160238; x=1795765038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RoorVLMi62FuFQRrqrflAmA+uFRRnvjjHFtI7v/dMic=;
        b=0N0lUZzp6k4H+7XVtPy9MFOxA/SmBrMlS+kj3V44qkmJfufWgVHOQqxnJdvwcKRdCK
         dj/lZnmmsPqED5yYZAtk49H3FIg4y+lGc4vO3ADpo/EwPUEtDPO6CWACzCNZ2nA/TdPy
         ZaqWaIsmbCZh+wEUaB/mP56abqjk2c9U3icaPeyqdFrzdKu7VI2bdINtPjeFiQ2XmeHo
         2iC/pglIAOT7fOQXUNX2VRShSvdk3dim0j+XFwRtPEvkag3BcSPTWcxV5Q8hQ5vRpAqB
         DxizbIwOjhhc8iViEYtqGZ2Ty2xXwfwYRXsKOW/Jgc2SfCstzb416NwTSYepM41Ki0zM
         tpxA==
X-Forwarded-Encrypted: i=1; AL+hErGPTqP5n/iaMuHCY73AojJED+G+k3LxV8BzWMx7tgf5yIWfzZXWuHaRXYtUB5DOreR7Ytl3EpfO8wa3lsN/@vger.kernel.org
X-Gm-Message-State: APuU4Z/6u2hunbd6piN5VHDdwooHA+yDYaaPb8CqT0X5Bo9jnpwwt1CW
	dxW5/c75hWwoCEe0sTdVI0uo5KZCtJnEq/NBHIrdzWfXbkHgaOzaovYe
X-Gm-Gg: AZFdTZcpLgaE+OeBQe55AxIm4qGjbouGcsLcxo2UR4OySPXVHHJCvc/IPaYe8hK55fp
	0tDxKxtE5PGeAKsVyNZ3zujVkN5CaCl44UEHNiWULMNRQ4fHEgnk14CEr8B2+C9GlaDLOc6tU7W
	B+racfZQAZw/JJP/1a8kFvis8n6cQZbzMfJMi5W78ONQaGIXDLOMwUlfZZTJWqKjM7sY1jfhysv
	7zysFYnLBTl5BTAvRIHLWKYoyd786igYZszXAq6TyCDDJbp2VaA9s7IDx2YdDxLfvGXtRUclndb
	nmZwPKojdLgtoHdefACKeKPnDVse4uwB8836aEnbXAslyvo0PSrDi/+Gw2PfG+hL7nUQAv3NlFn
	wlxAi+quj/dQHrZx9iM1ArUqAovphxH+zFJegxXoTpdnzHrKDXbl07hV4ltX2THS12ZbV+2A9CP
	inDiZnYg37yp0o8dKKrvxGLgsW8Kvj3uKDFFPFkOQYa1MLiVnMfujXfic0K/I6+3cW4WAdknDAP
	329a0gFSOKbKMwMFdpPcoJIrwQNwG88/nO1ETl++BX82ts4zrdZxlLndNuPZ1O9MTiMrjn4XnoQ
	WOXdDvLMZ2KcyK2+JhCX20CsaJhkYBvgTdXoLfeXGA66O45DLY/gUK9aeKT8FJO5GqoEZg37/y1
	nW6nbp39oGRI=
X-Received: by 2002:a05:6402:210a:b0:6ba:4bf3:4a7 with SMTP id 4fb4d7f45d1cf-6ba4bf3066fmr408910a12.23.1795160238249;
        Thu, 19 Nov 2026 23:37:18 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba370fc020sm841867a12.25.2026.11.19.23.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 23:37:17 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-security-module@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH RESEND] lsm: put the copy up creds when an LSM hook fails
Date: Fri, 20 Nov 2026 08:37:16 +0100
Message-ID: <20261120073717.1588080-1-amir73il@gmail.com>
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

From: Chris Mason <mason@kernel.org>

security_inode_copy_up() leaks a struct cred when one LSM allocates new
creds for an overlayfs copy up and a later LSM then denies the copy up.
One such pair is SELinux and a BPF LSM program that denies
inode_copy_up. Enabling both LSMs and loading the program requires
root. After that, each denied copy up leaks one struct cred, no matter
which user triggers it.

The hook calls each enabled LSM in turn. SELinux or Smack allocates the
creds and returns them through a pointer argument of the hook. A later
LSM can still return an error, and the hook then returns that error with
the creds still allocated. Its kernel-doc does not say that the caller
owns them on error, and the only caller, overlayfs, does not put them.

Reproduced with SELinux and such a BPF LSM program: 36000 failed opens
and chmods by an unprivileged user on an overlayfs mount left 36000
struct cred objects allocated, which kmemleak reported.

Fix this by putting the creds in security_inode_copy_up() when the hook
fails, so the caller gets either creds that it owns or none.

Fixes: d8ad8b496184 ("security, overlayfs: provide copy up security hook for unioned files")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: put the creds in security_inode_copy_up() instead of in overlayfs]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Paul,

Apologies for missed the LSM list and maintainers in first posting [1].
Resending with proper Cc list.

I think this LSM hook was introduced with confusing contact for chained
LSMs and this change makes the hook contract more sane in this case.

Thanks,
Amir.

[1] https://lore.kernel.org/r/20261104082128.3573690-1-amir73il@gmail.com/

 security/security.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/security.c b/security/security.c
index f6583d5073959..ad382afbff271 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2314,18 +2314,26 @@ void security_inode_getlsmprop(struct inode *inode, struct lsm_prop *prop)
 /**
  * security_inode_copy_up() - Create new creds for an overlayfs copy-up op
  * @src: union dentry of copy-up file
- * @new: newly created creds
+ * @new: newly created creds, must point to NULL on entry
  *
  * A file is about to be copied up from lower layer to upper layer of overlay
  * filesystem. Security module can prepare a set of new creds and modify as
  * need be and return new creds. Caller will switch to new creds temporarily to
  * create new file and release newly allocated creds.
  *
- * Return: Returns 0 on success or a negative error code on error.
+ * Return: Returns 0 on success or a negative error code on error, in which
+ *         case @new is left pointing to NULL.
  */
 int security_inode_copy_up(struct dentry *src, struct cred **new)
 {
-	return call_int_hook(inode_copy_up, src, new);
+	int rc = call_int_hook(inode_copy_up, src, new);
+
+	/* An earlier LSM may have prepared creds before a later one failed */
+	if (unlikely(rc < 0) && *new) {
+		put_cred(*new);
+		*new = NULL;
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_inode_copy_up);
 
-- 
2.55.0

