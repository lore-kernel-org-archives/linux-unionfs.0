Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A620619F11E;
	Mon,  9 Jun 2025 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749482366; cv=none; b=Oq808JB7dxZn9GfDwxyohYzrQJmRXqWwIuaEkR5OsRKvOPj3+0bkU3UZAORJCSnd7x82vC4tNLAN90bRbrlpw/2GAxZE8Hgysw3MkfTDWi4yZCsAm1AKwn3tOugZe42B1evQR7+qUtYAgtWEK0rd/3r+HfbeQfyw+1eMJMYThWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749482366; c=relaxed/simple;
	bh=neKeZhC0RbD92/OjxR8I+NLp4XI3n3UMXKf6jXnX+KQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IdAOnR20oSzuJgN7iCez5eCZnxSGMIU+pZm48BgG1fGcaL7qg/08VbA8eZEOSPe/m267M3OUe7li18cmaNnEnpOdsUbRuclir2F+3tvMwQEESnf0IUGFlh2FO4MNjd+0ONctykzrFzl69ePc+FYfdhroXj37Inp3gk7XMWmrjPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mq3P+ctx; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mq3P+ctx"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a4fd1ba177so2978546f8f.0;
        Mon, 09 Jun 2025 08:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749482362; x=1750087162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdlnGSpd0xomAMUK0RFWK+C+pbdwX7e0/VINOXCiTIg=;
        b=mq3P+ctx42qZd0CZ0zm2U+MENjfgqyb4diqmTFJOhGdAqQ0fkmxD9ruFvFwCQcgzuw
         3ipjiGtfW85ZFBClEYOInTt6Yb6tQGKNpGbWBpFu8+iGx5p9k72Q+OtS04+FLz2rjYWz
         C47bwuZ5YBML+SCrXWNrikX8O6neKCQKKxX3HzmX0Mq6+3UEUVOsmNHVJi3a82Hs+JbU
         clu+VJqXs2LjxttCDgNa/Q/TvMdPAKI3e2bXKN/Ux/gSKrMyzxQhxmBZVjljvqSKY7j8
         EPBvJ9rRrpqm+vpk2UkpJv655yJ8EIeyQ+bgxPQARSeomoJXbZo8mryl2oGHkVeHJtZw
         72tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749482362; x=1750087162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BdlnGSpd0xomAMUK0RFWK+C+pbdwX7e0/VINOXCiTIg=;
        b=mK8r3Y0FffvSE6JH4qzGPPjfuQVDKFpRLRcBFnyPYQE6LpGO90IGwGSGlEsovm06JQ
         5Scv41GjPqy/GAXnsWjUqmnfVcNrEeSjZHO6wN0K5j5dUNxjLKq1rqTMaGuxbdzeQxX3
         Tm0Jxz5ho5yOmiUqm6ONXMDNsld/eaVES3t8243DKlRAmcFLdXqEL8S684IE5nXgD2m9
         D9+Y4B5xlmMzZZjE3Zlzsduc725pYEmRUSD3jNouzTCRMviZb1u9qQlrw4VoNxV7HZ+D
         aBZ+Gi7HHhQPq76xUa08vrW2o4bcE770njczOtPyLIobEJPqTo1DijTc+5tluvxxtG3G
         D/dA==
X-Forwarded-Encrypted: i=1; AJvYcCU/P2fkM88hx5otQvbO1rh5PxALg0x05zBoFSEC7UrikcBUmR34DwJ1ymvkzsJt18bymnk5nKoNgrj0hWxWlg==@vger.kernel.org, AJvYcCXucjzA7brUJasMn6Xv+VMTmibIwnMCynFB6eMymlMG8+EuG2L2usuIplNW4Pk7s4Ro6pg0BlKd@vger.kernel.org
X-Gm-Message-State: AOJu0YwafLqFq7rCMms2NKJhMthA4eduxbkHdvt3xwuzJy0dt5qPScat
	t/nQBBSwNdt3jk1dCLjSRRaZkbvXjDqPzWS51cOggrJmhWWQF6okwTyt
X-Gm-Gg: ASbGncs2yZADFsGZAu9SMuSnaXqUOSPHcKxjBTpYVy9XgU1drM/INeQO87daFetn3CJ
	AHzLeyZ7k2urddlMRTXQrS829FiGcNcXSo4am1IWBHs8QZuGpW/YwYqz8m/5c8dw7Y0qUNDqK+W
	CoyKuFZGwHKYJ49nFnshV+Hy8HhVgqdNJgzpgWJQMw8lxJ87VE2nopYwli6niZ9hDwBBZ3yvpOJ
	RTg28je2UPZBaXAyeUZd7BVfoJGBPp/E5olK09Cye4ni+5dwxMhbzA42tRfPovqqvzbgofkK3Xd
	rJDCfB/p0+IrhJqka76CmCkhRr96UEklQpAMZdmKqxtIjg+BIrKx0+YaQ9Qi+pE7dJl7VpYZgj7
	3I48PrbdCKWGQFmTcnO3w1oTS0BGoJBAQaZf1h9IKoLdn15Nm
X-Google-Smtp-Source: AGHT+IEEzlVFE5bVX9WYYll8qYKHoz+SDn2F2QhKD0TTzSBaQk55MJ0xqM0NCIjXnrzWh4Bx0pM9Mw==
X-Received: by 2002:a05:6000:3109:b0:3a3:6478:e08 with SMTP id ffacd0b85a97d-3a55118dcd6mr224419f8f.23.1749482361396;
        Mon, 09 Jun 2025 08:19:21 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a532461211sm9622278f8f.86.2025.06.09.08.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 08:19:21 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 2/3] fstests: add helper _require_xfs_io_shutdown
Date: Mon,  9 Jun 2025 17:19:14 +0200
Message-Id: <20250609151915.2638057-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250609151915.2638057-1-amir73il@gmail.com>
References: <20250609151915.2638057-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Requirements for tests that shutdown fs using "xfs_io -c shutdown".
The requirements are stricter than the requirement for tests that
shutdown fs using _scratch_shutdown helper.

Generally, with overlay fs, tests can do _scratch_shutdown, but not
xfs_io -c shutdown.

Encode this stricter requirement in helper _require_xfs_io_shutdown
and use it in test generic/623, to express that it cannot run on
overalyfs.

Reported-by: André Almeida <andrealmeid@igalia.com>
Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         | 21 +++++++++++++++++++++
 tests/generic/623 |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index d9a8b52e..21899a4a 100644
--- a/common/rc
+++ b/common/rc
@@ -616,6 +616,27 @@ _scratch_shutdown_and_syncfs()
 	fi
 }
 
+# Requirements for tests that shutdown fs using "xfs_io -c shutdown".
+# The requirements are stricter than the requirement for tests that
+# shutdown fs using _scratch_shutdown helper.
+# Generally, with overlay fs, test can do _scratch_shutdown, but not
+# xfs_io -c shutdown.
+# It is possible, but not trivial, to execute "xfs_io -c shutdown" as part
+# of a command sequence when shutdown ioctl is to be performed on the base fs
+# (i.e. on an alternative _scratch_shutdown_handle path) as the example code
+# in _scratch_shutdown_and_syncfs() does.
+# A test that open codes this pattern can relax the _require_xfs_io_shutdown
+# requirement down to _require_scratch_shutdown.
+_require_xfs_io_shutdown()
+{
+	if [ _scratch_shutdown_handle != $SCRATCH_MNT ]; then
+		# Most likely overlayfs
+		_notrun "xfs_io -c shutdown not supported on $FSTYP"
+	fi
+	_require_xfs_io_command "shutdown"
+	_require_scratch_shutdown
+}
+
 _move_mount()
 {
 	local mnt=$1
diff --git a/tests/generic/623 b/tests/generic/623
index b97e2adb..f546d529 100755
--- a/tests/generic/623
+++ b/tests/generic/623
@@ -15,7 +15,7 @@ _begin_fstest auto quick shutdown mmap
 	"xfs: restore shutdown check in mapped write fault path"
 
 _require_scratch_nocheck
-_require_scratch_shutdown
+_require_xfs_io_shutdown
 
 _scratch_mkfs &>> $seqres.full
 _scratch_mount
-- 
2.34.1

