Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA36A211479;
	Mon, 26 May 2025 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748270112; cv=none; b=bb0DivBxjWqGmj844xvAocsuN99cuRlKm+noMlHOxTuD1iAXL6O/g9Ne8DW1+kH/3IirLAu2SDbJK5DBGwKnvMw9BwMkPQvdm2SgvNviltnp3/bOh5FwpjdlhUCrS7JX4rMdhbH8mqbniu7IjhZTYguJPaiFzz7coNSrqRo5dZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748270112; c=relaxed/simple;
	bh=q+flX8Yeuf/+ahD45ZjtglFwkCM3LcmYWg5GrhwSJMw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/WcHF6uFUoJ5uZn+NsscRJNX4D2jAWZXU39pgu+5K18f8JbRq5aEk7YC+38UOhjz7cK2XwNd3ebqNVLr/XKTYuLdtuPXyd2disD+XDahZ2oXuKpOxzEcuzlnRrIYGSJkVhRKen9U5WUbolNrIwCNkrNWrGkeTq2+q9AzMMJAR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OuTnkKGB; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OuTnkKGB"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso18374705e9.3;
        Mon, 26 May 2025 07:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748270109; x=1748874909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ocDOJ521VH+qPFeK/vIp6silfA0id84C5GBE4/qVFM=;
        b=OuTnkKGB+ojjRYNqwYj8F1Hx1RdhAnhNULbjFLXTOnaNR31AoEDmtVaZ18IAP9sjkk
         cVwL6q2EqtuYP7Qa7TbDpT905EJnWhEV4h9mnXFw8oFdXSSO8t7Xx9gsQr9KXNE1vilx
         JJa3DoBWWlTkWy/dlXiPUZFiboJhWmBzKc+wwWQNMFybLIdlAFh35wzn9ip3rRlMGz4x
         Mll7edy55BRuSBtXrihCI1MiV9tQMc8I4HKSUOc3zg+wqZWfVIYicjhVy8XdDLsXAGlu
         MloVwB8Uz1VKR64UIXLtsYW+/3z4TeqowAoigdqFh3Aw2tMh4/50GpiDrcLyDVso97GG
         VbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748270109; x=1748874909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ocDOJ521VH+qPFeK/vIp6silfA0id84C5GBE4/qVFM=;
        b=V1oCSzW9oVERYi/4VZPzrhG4WXKMD6ZCpLK99DLlkwmAQ12w7JPprxQ92hEv7zXt0l
         jnL0GElTsJAO/YmmmajOqiPeSVx256zZj23qtFl+W3Wp7zjohotK3kRjufuuhrBZ3EiF
         8CaMeE8gY7ZbtAwJwxSLwc0pADSa/aW+SlEk+lJGVat4dBoDFFysas0X7Hn6bcxkSlIN
         7VmwUgKA9+cbAFiIWIsyK8z49uHPLfzPaCM3NoNk4Wt1wkVnzysrhGiYNQLd4rVKexKU
         NUz0EkmAVSAFeGfrbLYRKBBP+WvEnpHTarA0J4ophSJ7UfuB/82BtrBwbhIYiFQ6/Ku2
         LRLw==
X-Forwarded-Encrypted: i=1; AJvYcCV1Fmix9UrIaHqwGnpDt6ZH84DLG29D4c5ezOOVDQIqrG2PrqSRKx5BPE37dG4Z7aMVh7Pqp1P+HHRq5qLTXQ==@vger.kernel.org, AJvYcCXEaiJKa7by/VZM0/RqDBCDj4vEMNHEYH/hVqPG2Yr+VSYnohdYp+x3E9Dyp93+aEW00JhDoYVB@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuy6myq7OMtCJpJzFH+dXvCq3Maxt2fpM1z98XhkSADYB4QPHb
	rmuYn/5Hes6Q6rAxgm0PGAT3BclOh/GYjnt8qu/Z3CYU5oGphmgClMbb
X-Gm-Gg: ASbGncvvr8YmK6trBB11EMtDu9my2XB28+9OqcYgKM0aezxji1FUM80ZVufD9A0yv43
	du2qLQOfV7IlzQFhTavG80IO/6pPKoJIA+9/cW5h08oLyGlzhV+WGMfVCysqyzOBovtd2E0Ufvb
	gRg0+LMPSs/eNQhnNNbksQaZqlVzkgSDmWoSK0SAbFHyi8oOjhEbNEo5NUw69WQH8mQ/1i55Ep9
	rd6o63bpiKApvsH0kU27BjuUi/+k0Vtjgy08I+HGgVHo2/Pil2UDNWU1dHi54x9R3Ji8G+GROeR
	Q9dPeQmWRUx3xbm61+SRKLZrn1REdsZ607fve+g6pvjmdX5Moot4qpdeDUBjPTDJ+xSqQlxCSfO
	ZlBg25Ujp7wHofRGOlPNmAF5VUk5dqm5qZeDnXni2pEN8Sbkr
X-Google-Smtp-Source: AGHT+IE9l/rZy1LD1+zh2cqUDF8nHUo35CgwfJSCNMHhlvcXXoLXwtzc0O95Lj6uYsHGK9ZsaXXtFg==
X-Received: by 2002:a05:600c:22c1:b0:442:dc6e:b9a6 with SMTP id 5b1f17b1804b1-44c91dcc104mr69037055e9.17.1748270108776;
        Mon, 26 May 2025 07:35:08 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1ef032esm245264865e9.9.2025.05.26.07.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 07:35:08 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH 4/4] generic/623: do not run with overlayfs
Date: Mon, 26 May 2025 16:35:00 +0200
Message-Id: <20250526143500.1520660-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250526143500.1520660-1-amir73il@gmail.com>
References: <20250526143500.1520660-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This test performs shutdown via xfs_io -c shutdown.

Overlayfs tests can use _scratch_shutdown, but they cannot use
"-c shutdown" xfs_io command without jumping through hoops, so by
default we do not support it.

Add this condition to _require_xfs_io_command and add the require
statement to test generic/623 so it wont run with overlayfs.

Reported-by: André Almeida <andrealmeid@igalia.com>
Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         | 8 ++++++++
 tests/generic/623 | 1 +
 2 files changed, 9 insertions(+)

diff --git a/common/rc b/common/rc
index d8ee8328..bffd576a 100644
--- a/common/rc
+++ b/common/rc
@@ -3033,6 +3033,14 @@ _require_xfs_io_command()
 		touch $testfile
 		testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
 		;;
+	"shutdown")
+		if [ $FSTYP = "overlay" ]; then
+			# Overlayfs tests can use _scratch_shutdown, but they
+			# cannot use "-c shutdown" xfs_io command without jumping
+			# through hoops, so by default we do not support it.
+			_notrun "xfs_io $command not supported on $FSTYP"
+		fi
+		;;
 	*)
 		testio=`$XFS_IO_PROG -c "help $command" 2>&1`
 	esac
diff --git a/tests/generic/623 b/tests/generic/623
index b97e2adb..4e36daaf 100755
--- a/tests/generic/623
+++ b/tests/generic/623
@@ -16,6 +16,7 @@ _begin_fstest auto quick shutdown mmap
 
 _require_scratch_nocheck
 _require_scratch_shutdown
+_require_xfs_io_command "shutdown"
 
 _scratch_mkfs &>> $seqres.full
 _scratch_mount
-- 
2.34.1

