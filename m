Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0013BC3F;
	Mon, 26 May 2025 08:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748247544; cv=none; b=YCaM4Yu9UBWXOnUt9x0OZ/Q24/UHlLlAGIx+slOQoCY8mtFIQpO8/IiqeVfgE+4WM/DjCsX0jn/UHwk2Lf2V7H/s/+HTgp7+6Xlx/I5XtgQZvchGRvTKyenwirtB62reCWZuuijqhzx8v5GuRBg7TriwadtwY5NzomRNCu0DcUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748247544; c=relaxed/simple;
	bh=6KTxZRORE24DMXRZ2mhrBBbbjoCdiqpQhlZQcRo440w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ExYHpkHVu6XB9pppDUGeuhINkhKJv73dcaT+ELlKGx0UFFNcz9DcmgmNwH+S1gZtHLJhDJM1FTRbWPHY0fl0Tc4hEeOKfMlGf4HswMHdBwurs2p2psfKY2S9IoiZJ4BKi1nhri3cpPmKKeIZ8qMnxAU4SHHzOw7v511Hah4nxCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8Ae8udc; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8Ae8udc"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so14497865e9.1;
        Mon, 26 May 2025 01:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748247541; x=1748852341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=co37T9iUcEpQffRWWYdWqPmRfHkxueVbD+wJOJxC0ss=;
        b=M8Ae8udcJ7r0Icuhq4YTSZ/D68mrzQSM4B/gsy36dHtRsZU7Envrt3Qr4FHlgOcKAF
         dqql6Cd4vt74Amw6iBTL6odwOLWyXlPA900EQESDYXfI11vtg+WJpR10Myvvc7WCM544
         tmj9XuvEje7fcmWLwGCfcLfon8Vd1E3ldBUsZhVS6LtkuZ5mXqNICXi3V1LKZwJBLZMz
         TqMtlQU1wzjybgUcJMMhhdCuMiINxo+rkiRnHLnbDG2pKUraS0U4ldeLqG1K51FexUMZ
         aUy0znw6PcdM51cgzeifJfiPglgwCGgHp7X+7wPhO6FNbyGsbU5zdb5PrF3J46VgH+2l
         1tUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748247541; x=1748852341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=co37T9iUcEpQffRWWYdWqPmRfHkxueVbD+wJOJxC0ss=;
        b=lTJNc13e+jhMpmjb8MNH3XZhipipg61f4MUt7IHWQeXvuoDqy944hQM4rHYl+e4atJ
         C6uXTeg+LufG+4XhJ/ePnew1RG2XFU2PRu1kKkatQa3qQkFYioHXOAFo0a3EDkcE14tD
         K3JgKvcYLUNpIX9NXOyeOl8p+n3JPYkaFwKrEv8Ho7ta9fqn1SDckE377j0Ds55qQsHH
         JaszgFwnPpSmrGGSAs93krEw25UFFexhMkhz8WbTdWFpstFwC9JBF1AIAFWOMYgi3Y+z
         MjTJz9VYJrKXPiT9J22S3DPSgHttmlgBJaeY+VLWRk6P1Ik9whr6R0Rnc+pQ/1sbp+7u
         6Udw==
X-Forwarded-Encrypted: i=1; AJvYcCVXZKf5RHsddhV/0VWzcKt7oOBaRK4khaZZYSe2rD6FOlvy84G/s4CtRT6NbCTiDisfSSvuobvA0VcuhCODnA==@vger.kernel.org, AJvYcCW6Tvohrmfx6Z33lkr7lb7FjnJveHNdeZsZwDoP+2UK4BTb5YzapN+fmy/nxwhC4qNX0/++m8t9@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvl8pJcesSn8q3BaB/zviRYzJYzogGHI7i9rZOyxWc3E5WF7O4
	lzZFQnwu7IVO2F1RBrKK5TJNrYJY6mQ0HFz8xiAoeBl4nzJFAvETNO4J
X-Gm-Gg: ASbGnct8RWQAjCwus9iwO9ZSrJPu6AX8wALYXGC7fVOb+QpbuCN32pkhDAeef5/pgd/
	vDQO+HkKUeWw4UJjDpuiiBdvdNJP6RnrSeoBw8044sSiNhEUTCLPeuP/ukIK7Oi1YZeNhA7uIWt
	m3ySmpCAnJfSAiGiRvoF+ya+eyV+uZkxUtvHnvBJThWAANfxSC/UlAIarog4AQ74U8d9vplBl+6
	iLzMpDkUcMj2UtotXoylP/QJGvbNxtH8O5h6O2Pbhrjjw6ISTA3rcClmrM8D5tNSw3FDcu6f6SQ
	UPg7/XOWP06Pep0zjRPDSjT5XL/6H3gx1Rx65ho7aZ+fgaRj+3whi6FENUKKaMDojMF9sGXj8Lb
	4XR85MbyX07/hzR6ZbtlOKN8InQEWOJl//GtAoxRvfUTKiE/xlxO5ONdP8Lo=
X-Google-Smtp-Source: AGHT+IHHcHUMKqSREDvK+0fOtEsu3GbT0wjd0OxUpuOA1nN0dfMHwpS4OJ6eGd4JbrX58jwFOJ/Mkg==
X-Received: by 2002:a05:600c:4189:b0:448:d54a:ca23 with SMTP id 5b1f17b1804b1-44b51f4c527mr75545185e9.8.1748247540648;
        Mon, 26 May 2025 01:19:00 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442ffaa75cfsm208122315e9.1.2025.05.26.01.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 01:19:00 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Karel Zak <kzak@redhat.com>
Subject: [PATCH] overlay: workaround libmount failure to remount,ro
Date: Mon, 26 May 2025 10:18:52 +0200
Message-Id: <20250526081852.1505232-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

libmount v1.41 calls several unneeded fsconfig() calls to reconfigure
lowerdir/upperdir when user requests only -o remount,ro.

Those calls fail because overlayfs does not allow making any config
changes with new mount api, besides MS_RDONLY.

force mount(8) to use mount(2) to remount ro/rw to workaround
this issue, by setting LIBMOUNT_FORCE_MOUNT2=always.

Reported-by: André Almeida <andrealmeid@igalia.com>
Cc: Karel Zak <kzak@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 4 +++-
 tests/overlay/035 | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/common/overlay b/common/overlay
index a6d37a93..5ee9f561 100644
--- a/common/overlay
+++ b/common/overlay
@@ -127,7 +127,9 @@ _overlay_base_scratch_mount()
 _overlay_scratch_mount()
 {
 	if echo "$*" | grep -q remount; then
-		$MOUNT_PROG $SCRATCH_MNT $*
+		# force mount(8) to use mount(2), to workaround libmount v1.41
+		# failed fsconfig() calls to reconfigure lowerdir/upperdir
+		LIBMOUNT_FORCE_MOUNT2=always $MOUNT_PROG $SCRATCH_MNT $*
 		return
 	fi
 
diff --git a/tests/overlay/035 b/tests/overlay/035
index 0b3257c4..2a4df99a 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -42,7 +42,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 # Verify that overlay is mounted read-only and that it cannot be remounted rw.
 _overlay_scratch_mount_opts -o"lowerdir=$lowerdir2:$lowerdir1"
 touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
-$MOUNT_PROG -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
+_scratch_remount rw 2>&1 | _filter_ro_mount
 $UMOUNT_PROG $SCRATCH_MNT
 
 # Make workdir immutable to prevent workdir re-create on mount
-- 
2.34.1

