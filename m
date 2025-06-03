Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF25E1B0F2C;
	Tue,  3 Jun 2025 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945277; cv=none; b=B1w/ElwtyRaub5l7Q3EAXek8P/sryxWYEZrgJJU4yJhIR6wYbRAuceeIRQbgvc6VoUUi9q+25mJ6qIna3cAt6g94q8o0NBQ5h/OIhPRG2jMVGsb1sO159we5kzuIMoJQ+MOz1/Ed1Oe9pAVVJZPHmfHNl31XLbaMV3vKyzp1FaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945277; c=relaxed/simple;
	bh=lpI+nGiqstqAkp+R9IL0atVvb1pkhKWgco/Ng7+7E9o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mfd7ybTr8H1Olink5IFAxprTY3VjKYnJFRrLuk18/qjN4wvi4kOn8esn8FwlcBxDFfY8SKbAXIGOGKZdOpMkCSeG8e+8nK9e9SqxeAYbNA4OOTzCjmbYELMZWENrC0XxfaRPbnzZhNiyLsfM1qX1/AGwg+t2LFPXhmrMNf3QKuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e250nVE0; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e250nVE0"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-451d54214adso20530025e9.3;
        Tue, 03 Jun 2025 03:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748945274; x=1749550074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65emWPQRgyKXGuedtpDHxYL90KUbo/Zao1b9lumyG5g=;
        b=e250nVE0XfnHVKdFIwMtp7UJvMmW1FX0y3ro2MJkxLd7wIXylvkklykSQWl+WoKGQo
         Skka5ZNWcfEsfL5a0+eXg7XLAz30iCQMCprXVZnT4Yrf/DNnk5ErUradOGFSdzjwtHdg
         6ASjuA7qiomTE+HspaW626RTpYFCM0lYtCuTJE+dnfdYEaMPrlbij+fhsPm592C7ogv2
         iaoYSfo5KwLDuOvoFpQC2GxDYuwe6gRNOFEwrRZjirflZ8EBisd3C51T99IH3P+XbSTj
         KZ/TMIAiJPIhAaIJIRoGwN4noMNE7qwOMHQnSTnFrbqeOMVOA7V0qvLlff0atcKout4g
         /0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748945274; x=1749550074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=65emWPQRgyKXGuedtpDHxYL90KUbo/Zao1b9lumyG5g=;
        b=aizU0cVoTWQwgfNcy6wfq+fkH2bODLkALcfQPl4V7pM8uzhyzvDNPeMVozpmnloLAf
         08FKjND/mk0n5dZy7K6eLs3yiK8KB6JA1UauCAj3VXY1heZvpLzgPf+VdWKj8uB0N19K
         UMxCG8oZYWNYa3pbC6jCMmknCWGTDyywHuVI7WQiAz0kHOPb1ukOi7S8RxZxcMgPaMMx
         Rw2IVWPKfrZY45cq9lU6WGJ0E5vgGorFa9Av9hGORUkAB+fUtISrQ+YsMqPzjs+sveOy
         wTd1EGQyWIaNk52kmuV2uak+2paQsRVqmD+EPbQTRHoFGqn01Yw60mjaGJI3Jl9oROFt
         n4cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw9e6sogWhJptEcwNXcBF/HV0FeSAx/1/NQd4cRZ5DMQOYIeGqDZBgTVQxkVddRqtjc8jLqila@vger.kernel.org, AJvYcCXOU/sR7k7S57h6hC9n8vIxrlmTSjOo/3wn4UoK/7Y360X5ShcRnZusXw9F1tC1+NBx0LEopJKDTUxoODCW0g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgaV6RhFOMyvsXCV1/wtV9as9Cu3SkkvP0LWrjh3576vCMUpiI
	bvbcBh4GIaZhAmW1Mk2X/BHKBOS2ATD7VtVy15S8CGhhNMQs/LSWT5CfIJcaDqKggCY=
X-Gm-Gg: ASbGnct4LQku8ie7AtqnwbUS+fMTY82f37QIQSKDXN6JOWFLEmnQXHa1NNFcUXZ2I+g
	lnWzBz2G7mBiVaaIIEp0hzjUfpyCGbyRgt6MVVt2qpt3JrhIrA6+iofPVelvLL+0qf5WATadqiG
	tHWD0oFVHOGeHKdCXk5K5W/Rec8u7j3ISGfmQJZEr8LFxaTGRZcvpedWGKqmQyZ0rGsizCBAM5k
	MmEC/qjhY9aN8z0lCTMW7eWqrtAJBOmprXRI5ueF3g1jG8nh0Bf2NhcBTI6j+n73PNTgOgVgNpA
	rBu0FbS5bajOphaRRTPAkDar69VQB1jvrVL7v6TQPUETOy6zHu5ETFbGx/O8dS4qzEdiXMszRjH
	6yr5kNyJE0DxqPw1IT0H+U60OExtkyEcAc5oDVuiQ7KcJZkz3
X-Google-Smtp-Source: AGHT+IHF14Hl/zuQKBef1PbkHm/sQIM5VIhlA60O3CUVdXXQ9sBIVZf6z+DegG5bxDyC+2kUO58kfQ==
X-Received: by 2002:a05:600c:1c96:b0:450:d386:1afb with SMTP id 5b1f17b1804b1-450d64d63d1mr159731955e9.9.1748945273493;
        Tue, 03 Jun 2025 03:07:53 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa24c6sm157191525e9.12.2025.06.03.03.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 03:07:53 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	Karel Zak <kzak@redhat.com>
Subject: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
Date: Tue,  3 Jun 2025 12:07:40 +0200
Message-Id: <20250603100745.2022891-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250603100745.2022891-1-amir73il@gmail.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

libmount >= v1.39 calls several unneeded fsconfig() calls to reconfigure
lowerdir/upperdir when user requests only -o remount,ro.

Those calls fail because overlayfs does not allow making any config
changes with new mount api, besides MS_RDONLY.

We workaround this problem with --options-mode ignore.

Reported-by: André Almeida <andrealmeid@igalia.com>
Suggested-by: Karel Zak <kzak@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes since v1 [1]:
- Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=ignore

[1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73il@gmail.com/

 common/overlay    | 5 ++++-
 tests/overlay/035 | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/common/overlay b/common/overlay
index 01b6622f..0fad6e70 100644
--- a/common/overlay
+++ b/common/overlay
@@ -127,7 +127,10 @@ _overlay_base_scratch_mount()
 _overlay_scratch_mount()
 {
 	if echo "$*" | grep -q remount; then
-		$MOUNT_PROG $SCRATCH_MNT $*
+		# By default, libmount merges remount options with old mount options.
+		# overlayfs does not support re-configuring the same mount options.
+		# We workaround this problem with --options-mode ignore.
+		$MOUNT_PROG $SCRATCH_MNT --options-mode ignore $*
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

