Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17E831691E
	for <linux-unionfs@vger.kernel.org>; Tue, 16 Sep 2025 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031217; cv=none; b=Szt9rxmkgzaHwaY8FlaMlRbuyUtsPM0reg83N4SNlWP0i/6kuU710wEhCbj+2RmIpbShJNb2Zs6FitRBNAr5uZ7+UaTOWai9Gmudian3fYmjJzBIxo4HJLcQcq+Bvh4FagYPWjAU6I44ZHSb8flClFpRL3Hnmf380FN92dB/JXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031217; c=relaxed/simple;
	bh=QCGFM/cnMeWMX3htX5p6eryZx4ChTW6raUZie6Xkq4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIJ1osxKS+AnMq9ADaFbdq/wCLaxUDueXn02lDv++PzLwfhDLxjXynA4tJAIPDs1gQ6jh67Clr24WJJLYr56HmxiQGE0LgeM8DqU3Nsu+bjc6+rwKsZvDjYN3324EDpfXa10s9XmLhyseD6zgReTWw1JsWUGfQvjpPbquAUMeXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1QYzu5t; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1QYzu5t"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dd5e24d16so52704585e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Sep 2025 07:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031213; x=1758636013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3p/HZf12MlzeyzMfr2O5f/PDaT3y6+eiNIS1WtKNH8=;
        b=C1QYzu5tm+ZBCcgLDTLM9p7Jfo0KfGcUDDuVxxxAiYaUvdNGeVC3ALIRml15nIs1X5
         dXkkLWEbOAnsZlL1muEI1Q7w5nNaXOR4hnG/iAhH0kxFLXL8MjO2UMjCZy8OXXg9OpR5
         0a08/yhcdGfqSM7dVi9KHc1e4ae3lRzP7umS0ovlx1y1T1juv1S7uD6ZXoCUSeCuBvUe
         HC7r8bdO8uLYXUSRVyyoDnxDvpSDr2aAkaJGBtauJceDjQ+AEGcO/vxDzbzqTNIqB+nt
         1pT/NwMsjuj6Q1YjbYS6v6HKm7DDGtGH9VM18mUZ5UusvVl3CCsPG1md8I3DnA+ZDwrF
         5Vqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031213; x=1758636013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3p/HZf12MlzeyzMfr2O5f/PDaT3y6+eiNIS1WtKNH8=;
        b=PR/Ssq21ZAtmU+02TyKqXFRdJSlHYOeYF+S0+Fw8VN7PAK7fI9n4JNfT3zSC/rOlpG
         BYH5GOG0P84qil7zN4bXcUjqmdqEcltgABcQsXIlec6VpSHjjxWSpI763wwAL0J1lAIf
         ayH3bP+h3dn3jPFn56zrhG3lqOB5HB3WxdooSJeNhJHutIcDLOK1DsULwNZo86XCVrKu
         QEV67vqDU9JSh6S1cQuxCZlQNzUYGfle2AmUtmQ0/aQGUoq6HgYwn7Jt4qwvYFAf6Hw0
         EF97L9iybPWq0eEwEnTw29wJTpWwYF5rXhwUIqp0/XVp7bLUF68izahR90tIfptOl8Ks
         H7dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ7wEFk2Em1/9y++KBq6EuXsJftGvVkGZ4+xDY33S5aCd8a41RjK+J8w5/aIZQye/Rihhvv5WHpK35sx72@vger.kernel.org
X-Gm-Message-State: AOJu0Yydyj0qOe9zChO8ol+AbY+fPhIfDZ42wCnQR5HucCH8ZeCTq8Cs
	gVkawKUNKzSe12RPTMHjaY7nWkb38P3raMcMzXlaO62V66gqHPOATICR
X-Gm-Gg: ASbGncvL0QIyEICnj7PC2coiq80eRW/+UQQGqkzpjHmmKB8L7YSOt83MEsuX9TJQd11
	+vHxQEbwjRr+xruAZfqlFs3hn7BCmzBr1ZFnSC5nnd0oCp3tkpfuIgHc8X3WfqG3du/DeDt7qWv
	JeCPE1Z5kTg9Y/SkeC90z9ZDLXVcZSXME+5qte0fpB+d9zAVfYuspsiwsWo4+Xz1+Sk+NuIu40j
	YMYATpbbDRn6hRHEPhIRWlhcpuw2NDaBHlX71HTX4fPZt51Epa7MvaQ71dpZl4pnTnIB5dCHKc6
	/vqFKsY/tFGJc4tHktiNhTwWWz3AE4MbJZ1jHz8oceW78JD6ZrIot+bKBOwTQYoog0YvsLJAzCP
	bfLujiP+eegi4XZTx0DrwUlZExPHLFSelt1OK1QcigCr4jCNBJOy2Qau+Ntnbc84VtqAHj6pl
X-Google-Smtp-Source: AGHT+IG3ojTnTVy1hdNr03FmdV6E3sTeXWaDybJz1f1E1nvEGmI8CA+2Pel84ZsC9/O7zHxZywZmtw==
X-Received: by 2002:a05:600c:5246:b0:459:e025:8c40 with SMTP id 5b1f17b1804b1-45f211c8aa9mr181401305e9.10.1758031208380;
        Tue, 16 Sep 2025 07:00:08 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.07.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:00:07 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v4 12/12] fs: make plain ->i_state access fail to compile
Date: Tue, 16 Sep 2025 15:59:00 +0200
Message-ID: <20250916135900.2170346-13-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916135900.2170346-1-mjguzik@gmail.com>
References: <20250916135900.2170346-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... to make sure all accesses are properly validated.

Merely renaming the var to __i_state still lets the compiler make the
following suggestion:
error: 'struct inode' has no member named 'i_state'; did you mean '__i_state'?

Unfortunately some people will add the __'s and call it a day.

In order to make it harder to mess up in this way, hide it behind a
struct. The resulting error message should be convincing in terms of
checking what to do:
error: invalid operands to binary & (have 'struct inode_state_flags' and 'int')

Of course people determined to do a plain access can still do it, but
nothing can be done for that case.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11eef4ef5ace..80c53af7bc5a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -782,6 +782,13 @@ enum inode_state_flags_enum {
 #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
 
+/*
+ * Use inode_state_read() & friends to access.
+ */
+struct inode_state_flags {
+	enum inode_state_flags_enum __state;
+};
+
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -840,7 +847,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_enum i_state;
+	struct inode_state_flags i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -906,19 +913,19 @@ struct inode {
  */
 static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
 {
-	return READ_ONCE(inode->i_state);
+	return READ_ONCE(inode->i_state.__state);
 }
 
 static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
 {
 	lockdep_assert_held(&inode->i_lock);
-	return inode->i_state;
+	return inode->i_state.__state;
 }
 
 static inline void inode_state_add_raw(struct inode *inode,
 				       enum inode_state_flags_enum addflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state | addflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | addflags);
 }
 
 static inline void inode_state_add(struct inode *inode,
@@ -931,7 +938,7 @@ static inline void inode_state_add(struct inode *inode,
 static inline void inode_state_del_raw(struct inode *inode,
 				       enum inode_state_flags_enum delflags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state & ~delflags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~delflags);
 }
 
 static inline void inode_state_del(struct inode *inode,
@@ -944,7 +951,7 @@ static inline void inode_state_del(struct inode *inode,
 static inline void inode_state_set_raw(struct inode *inode,
 				       enum inode_state_flags_enum setflags)
 {
-	WRITE_ONCE(inode->i_state, setflags);
+	WRITE_ONCE(inode->i_state.__state, setflags);
 }
 
 static inline void inode_state_set(struct inode *inode,
-- 
2.43.0

