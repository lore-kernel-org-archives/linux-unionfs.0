Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B65202963;
	Mon, 26 May 2025 14:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748270111; cv=none; b=KyjIZuYHkrHxE2wkmDem4+h9U6aOfr+uO47YZJsRDffYT1JG9K1zwB8KgMdL7SgWtOOW3Es0mG2qJCnNgyPFC+2Hx7LuUbsRqsXHkl+MrtrkJ4E0QZCtavHM956jf5RASXCXbMvN+zdoP9IiaDPhj9A5tQGThFqMiA3Rao8EdkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748270111; c=relaxed/simple;
	bh=Gc9IE++rCFZ5DGL2F8lhL+TVcaJdmHR6ZKu010M+fWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l9F0mDBl9f+Hu6gyjW2BwdFf+lP0+ovOjgv3ABOxC6NoS0DO/MadQgxraiOqTt3BsiuM475zwYx6mF5H2yq12apRXI5xYowYSIxSizyPIZ20gFbpx2SlIzeywqqHelXqc1eaCuWHFtbSDhvwwvE+eozDNbwuHDKf3rWXP+BX+ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DxQdlfPn; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DxQdlfPn"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a363d15c64so1657955f8f.3;
        Mon, 26 May 2025 07:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748270108; x=1748874908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vR5bUdiSmhX1URrwVgsxxS+HHRIyPs+GseYGYuEbtMI=;
        b=DxQdlfPnpRvj3EGUf/Io0e70NPwtVoXNuBzg+fziU3/MFhkUwWueZ24R6ZSlvChKFx
         Hb+fHSCteib8/8pFn4Xjss48dJ0xvb+v2iIIT4V/CE5ciHehoFL70J8TZpZFwm6hsyNw
         Exhcd95RHrlmAhP04v/mQVskGf/kF0hpXAv0wBXLIb89WS1TjKODOS4WqhsM82ECsQZ0
         LI7IFNo6M20kqx0iVEm7q9xMVRKJv+ezpNt6C9yikjeCeDG2TUAtQPKpDYShd7eNXiBE
         50udPqUZVvVMQ7liFvlaGhjYL077xOymEERneWQry5MhIm9JgDsLJFNCj8ji0MAdDpMv
         TvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748270108; x=1748874908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vR5bUdiSmhX1URrwVgsxxS+HHRIyPs+GseYGYuEbtMI=;
        b=C67mAPCEdjcHoPgVQWpl25qp+B2Eia060sNQJAV59NmFt4qVD5gC1s4eV700pniUxn
         eCtm5YkXW6hZknVYfmtfBKU0UCtbYHJfXhN0aa3GPnta2h+nxhyR4nba1fRT1UE6nXnz
         R6iJJ2LOEzl6WXf5Yl8og6uZ3f85WggeK7i5/nNzRWwDHu9e4rFxmRwcPC9BIPuar6cO
         rQGGz5QJGNqnmSoqc/BKeWGmq1ur9TUsYG+smLMR7g29N1RRaV1ECLRpggfv4NMZNMAt
         53DEzhR7VriLkxLLofLt6cMw4aNajYqbov4uuNhlG/NNu3ITbNjGUsQAZnSSjcVT9c/z
         B2oA==
X-Forwarded-Encrypted: i=1; AJvYcCU1XImYfomGAI9VdCOw6lZPF7dxuKtfFkO0qeufI+JIIWG8Iku5y1XXPKXVyQw4ISToNCD7fDPc5ArE6Uk4Ag==@vger.kernel.org, AJvYcCXR3fiv0gsxpiC640CfN+J+qgkjj6yJ4pQdrfxo2xywSnYuzCI15E6HeLXW2Dg1r88ogjYJNDKt@vger.kernel.org
X-Gm-Message-State: AOJu0YwQIQcq9qui/PYq6MDTsuYrkF6tVv7muGOrjPAC0h83FSWGm7BI
	wPjDJ8VvHdYR7awsf7PHDiC9ft6pM/T8c9J7NVbenDKgjMX+3g1lTLSwd9+84ipFy84=
X-Gm-Gg: ASbGnctZqzR+ebIHWKnqbNdHcxOEE62VkRzcL2Zl3MvaXJe8r3/5ZNkKTMy9otcCPXv
	WObysbLapNw6fuv5421Wd1v79cgc0mPH1JahBGnwVKH46SOJNd/OZroPcpTw0eLKRCbMQ+Y13A5
	oa4nn8hcuDEBOJZ0p0gMb2xD1EGlJo6nMkQZQCt/vxzjp71zXi3ljZ1OyC/TYiuTc/46wqMEOTA
	JTXTSlHLEtql3p89R1Oloda8vTXtHFpGoyCWKiInUnqvZlg9LoZiJO9X+BM9qDUbYXrKMODPJMA
	GvPGnZF7hhjfdeTY8Uiotvr/mK+AzScEiRB16iEaVYSP14IhGRI1UPV15D/DTELKrHExXk+MfIi
	5kpDXrMkzcOjV3B7UcKAy6+hvTM+BmpCAtAMMOlQySWU6QdO/
X-Google-Smtp-Source: AGHT+IGa3YWnOZtcwUah3fFT5nxPmgDc2b/vVSNN28TiDbQBsoZ1PVm4sDZVtxpPwFr+ww7BIrPe+A==
X-Received: by 2002:a05:6000:4284:b0:3a1:fcd9:f2ff with SMTP id ffacd0b85a97d-3a4cb432e41mr7537102f8f.12.1748270107728;
        Mon, 26 May 2025 07:35:07 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1ef032esm245264865e9.9.2025.05.26.07.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 07:35:07 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 3/4] generic/604: opt-out with overlayfs
Date: Mon, 26 May 2025 16:34:59 +0200
Message-Id: <20250526143500.1520660-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250526143500.1520660-1-amir73il@gmail.com>
References: <20250526143500.1520660-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Overlayfs does not allow mounting over again with the same layers
until umount is fully completed, so is not appropriate for this test
which tries to mount in parallel to umount.

This is manifested as the test failure below when overlayfs strict mount
checks are enabled by enabling the index feature:

$ echo Y > /sys/module/overlay/parameters/index
...
    +mount: /vdf/ovl-mnt: /vdf already mounted or mount point busy.
    +       dmesg(1) may have more information after failed mount system call.
    +mount /vdf /vdf/ovl-mnt failed

Opt-out of this test with overlayfs and remove the hacks that were placed
by commit 06cee932 ("generic/604: Fix for overlayfs") to make the test pass
with overlayfs in the first place.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/604 | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/generic/604 b/tests/generic/604
index 744d3456..481250fd 100755
--- a/tests/generic/604
+++ b/tests/generic/604
@@ -13,6 +13,9 @@ _begin_fstest auto quick mount
 # Import common functions.
 . ./common/filter
 
+# Overlayfs does not allow mounting over again with the same layers
+# until umount is fully completed, so is not appropriate for this test.
+_exclude_fs overlay
 
 # Modify as appropriate.
 _require_scratch
@@ -22,11 +25,9 @@ _scratch_mount
 for i in $(seq 0 500); do
 	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
 done
-# For overlayfs, avoid unmounting the base fs after _scratch_mount tries to
-# mount the base fs.  Delay the mount attempt by a small amount in the hope
-# that the mount() call will try to lock s_umount /after/ umount has already
-# taken it.
-_unmount $SCRATCH_MNT &
+# Delay the mount attempt by a small amount in the hope that the mount() call
+# will try to lock s_umount /after/ umount has already taken it.
+_scratch_unmount &
 sleep 0.01s ; _scratch_mount
 wait
 
-- 
2.34.1

