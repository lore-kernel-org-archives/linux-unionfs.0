Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E959732255A
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Sep 2025 10:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758624457; cv=none; b=iVGMD6HNuyUyyQ1cIo6GfRfeyQyB9W+PWI25nbE2iT3PYa94waxW95Z7/9v+ZNOQ8F/QaTKvxoxtQQOFOViRnBQdMfKzW/xTWeX7xHloQsUUqGEr6n+xHcA8w+Lu80lThqoK8ut0QWrwGCP0jKlNCIKApDcA0W3LKhd31zYP0YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758624457; c=relaxed/simple;
	bh=ouMLdiYXJEV/tbThHG/kXZjFoWBywpLKJo/Paio0wwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZMI0ZGMtVABbJozoMwcljYQDVLJhzNaNiSKY0VViJXWU4lwgEylpwKJckVDsLz9/HlpUt4uO7wGq4KQzv4xiBsoATA9Z3WfZfJ1dC2CSNEy/mrJJ8otKBq1rsNGS6VnSKeDc8mw1whs3vS+aiESenEK6bf6CkVULho8gHg4oXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhZGN+uX; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhZGN+uX"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46c889b310dso24389075e9.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Sep 2025 03:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758624452; x=1759229252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjQhtecysAf2+Tm/SiAxvWYNu2I/ZUKX2kulTrssyjQ=;
        b=LhZGN+uXvnRcZp/BkNSZYpY3HLnrF3MIXUHwRe5694SHPoiXPSjIF5o1Cx+hffoY2D
         wLQnIdbqbp35ju7NMkMmutMG6NxIK8kC9I0PKqjPRo3MlN6mwCJzofAiR4aChInAl7Dv
         uaazvsOcIgmaXfy/dWRVf/OhqHPCYnw40d9hV0nqJHuGnrYlHFvc4aKobLXWjPH/DEGO
         5oFXfC+bDh/jOq/E0hzacTXcCu3dhKCjCeiUmPNy1FWresmWjR9SPuCx7AQWtSGJxaGZ
         jYjbsboNrycDe21fu6Ip2tQufSoGiGGCcxId78Js5h4L5suYrY2HneCBlUZX9HB6XZjW
         d+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758624452; x=1759229252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UjQhtecysAf2+Tm/SiAxvWYNu2I/ZUKX2kulTrssyjQ=;
        b=jctzrwCGc0FRnHsKQSv7PCP/GqQBkkm7NsqDTNKJgQ5ZEtIbzXody1p48NuknB4c4P
         3QVMqBdcp7N/2Wx69OH+9M0pLbPrsjQeqeHEMdYyk5Qnd9HIA2LgH1jiEFowoEnFr6nR
         RIuaf8ga9Cryg+vk+TugAoG0tmDvsGStuiIZedYFc06GusO5cJtMaSBnI3S2IgSSGf8l
         tbAi/xmj8kV7FR7mkmBSJRSeTwFURHWgiyQrMdXKWWq3aIxIv2jQyKJdNUsQX/NUeuSo
         wqJZ1FpLe8mK9qNlp8xRlZT3j5vZrq2lye8yr+TEtPLlBqEjep9CWxu19yf7Vcwlhcyb
         YFYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVepykfFSANRJeaDq4F8u3FY54hywfUQvFq/2rGFKzCLK79nPav7vhPRP6gknyCZPF1JFVg8mzGmuzaoTNy@vger.kernel.org
X-Gm-Message-State: AOJu0YwHQPsItG4+boY0ET2ysSn/XIm9hPUbmWjQZ2SqMofVKyUdpdTn
	htLokCsWclMoSRQI7pJRsRnMhfUxqgfnLHLLEk9DTV1RMU6F5LVW8+41TwHf6BDU
X-Gm-Gg: ASbGnctkviZofDaOI/lTgL2efbKFWByIC8UTJviPvOuVsgyXkt9mNdZ51oJ7QfEDBdc
	uOc44qAFs+emwiqrMfIc3CZ4jrtooiESrj+f8KkYJ9xHskiKdUKnCvoBjfzjxTMtU7ZWogL8F/6
	t9wUmYnjJsB4iaskMPT5vXA62xeP/fJQzCatUgPwvKNXDYAk//5irWnGc83pRcujPT+JLwf5qs6
	Cu+camhOXr0FYDYY8W8wtquJ63IeiN6RGMRVYCYx8Bk0jUgH21iXxs1a/rgDjQZFG4uXKW8ydC2
	pBHN8p+itWmhqNd2+NjdLFZ3YbpCsZqVVC23nAL0+MJ70R63C/V/zPedJguxG/s058CviaTixJh
	DLjLqJwgOAuz4N8QU2/aCM23yYsSkiUdAIRosL4h7LSuXG2I+v595c57iIem2zlH9GZBjZ+4TS7
	RmCnvp
X-Google-Smtp-Source: AGHT+IEVb9i92+ZMOauFSkmxexkNVrc4dNm4CbgsPp4IcZSL124eR4borVyarFVwdram0vM+rxqviA==
X-Received: by 2002:a05:600c:4685:b0:45c:b6d3:a11d with SMTP id 5b1f17b1804b1-46e1e1121edmr21348615e9.1.1758624451919;
        Tue, 23 Sep 2025 03:47:31 -0700 (PDT)
Received: from f.. (cst-prg-21-74.cust.vodafone.cz. [46.135.21.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e23adce1bsm9710525e9.24.2025.09.23.03.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 03:47:31 -0700 (PDT)
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
Subject: [PATCH v6 4/4] fs: make plain ->i_state access fail to compile
Date: Tue, 23 Sep 2025 12:47:10 +0200
Message-ID: <20250923104710.2973493-5-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923104710.2973493-1-mjguzik@gmail.com>
References: <20250923104710.2973493-1-mjguzik@gmail.com>
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
 include/linux/fs.h | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73f3ce5add6b..caf438d56f88 100644
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
 
@@ -906,26 +913,26 @@ struct inode {
  */
 static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
 {
-	return READ_ONCE(inode->i_state);
+	return READ_ONCE(inode->i_state.__state);
 }
 
 static inline void inode_state_set(struct inode *inode,
 				   enum inode_state_flags_enum flags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state | flags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state | flags);
 }
 
 static inline void inode_state_clear(struct inode *inode,
 				     enum inode_state_flags_enum flags)
 {
-	WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
+	WRITE_ONCE(inode->i_state.__state, inode->i_state.__state & ~flags);
 
 }
 
 static inline void inode_state_assign(struct inode *inode,
 				      enum inode_state_flags_enum flags)
 {
-	WRITE_ONCE(inode->i_state, flags);
+	WRITE_ONCE(inode->i_state.__state, flags);
 }
 
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
-- 
2.43.0

