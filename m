Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87562288D5;
	Tue,  3 Jun 2025 10:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945281; cv=none; b=Z0S3+qJQ81gsWUeMaeBcToOnVQvlh49FsBWsi46K3O6V3+wGdhMtEWFbO6iaeu2/v5jkuLV0tpcjCg01FG603OKzj6b8iy5egVlh2mcxutTOsoJ9U8/BQyn8g6cJkm7/9QziBJxIulEgGWEerXk8R9sz0YmoSJPuCl4bKd6ZWTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945281; c=relaxed/simple;
	bh=kED8MuozkX0CG6L5Npp6pcP5W8jJUAtDd73XAKBUfyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXB+Cm3p/WrexDerBkdqrdTn5Lk4hlQT0hjDzKr3aqK1yFV2nHa7goJf0CIfWc015hjDdEF+DcO1Vqb6gdzC6E9KQ7V6KtanmnLgctfyDuVr4QW3KFSOM3s52+UhHhqR6u8nbJic35IKyk6GW6WK6RsIEusp47iD9BllFeEDkIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PwdsO06l; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwdsO06l"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a50956e5d3so1693730f8f.1;
        Tue, 03 Jun 2025 03:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748945276; x=1749550076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJMKSRLKMa5YCt+7AqT+Wg1Dq77KY4GJkgZwkY2T3xE=;
        b=PwdsO06lOQsm+RI8wBR7LSOpHOxfQCxkBWWVnxSiEJIx2pMpsT/GzPkd7cFWKRxkd+
         A1eUjsc0cFR7YtEk5pkmhTYjXCSeVCQbEtzKj6SfdwhK0ut1oJo/j9tMhE+fKHO0zG02
         Vt5HuSZ48HmS35hY1LoV1AtuQbGWudsgfeBLxvmtspwZ6z0HQBX3Jq1SF+zWDmb7AG+m
         ryHnFQ654cR8lhQxWw8jeQmfmQJduFtB5IpqDTTT/7C5MjJa784CDcM9phSsjCjtECbo
         MHralmizfme2/ZeUeHmWW605EYXMccJXCUgcTyjgNFKSwYV5AHZL0lwk8BuA+9OmjE/r
         cr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748945276; x=1749550076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oJMKSRLKMa5YCt+7AqT+Wg1Dq77KY4GJkgZwkY2T3xE=;
        b=vQplnhm6bJ9gdNE6MKsrEescwaG+H7OiUjA/5Zfd8+ky8otT+Ze4cmgErEfspRo1VK
         oGSiWdv6jX5rALjdH9Bt0vPlkDT/NklXmJ7XUOQp0sL00RE4e/kUYFYE6Fl9JjjheA/8
         48jTltau7ejJJ/PpVVOpad9jA4s1DNbmMLVDKFExvg9Vb5S1WuBPyux2wbzkaHQiggHp
         0LXDPa8gDSIvjv3FmB1H4sMuPlSP1RloQuPAdS6Dwny1f/A7k6i/Z+KnFKWd20tBxIGs
         oM1o74DKLOS/1qBQrPpLQcC+mKYPSiX6LNEgUvXL/32O0ES/Zm0RkmIcHb7Rquk5rLkr
         R1Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVojpy9XlYjpNLVev6Si0ZEWzMhcOholhgaoRHznTjMOXjVEttME22wE3QHW9PZf5554gHAM7HnsquSJxf68A==@vger.kernel.org, AJvYcCVwsVobYmAUL0CVfLyJcUgcpUbMP4sgk6W/f4YKK1uDVNVTbjwDzAR4g2pKXHTAplOlPQMlm2BI@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Z/2yW/RySyHECC5S0eWfzrfDHTV/2ENj3nTSa5gfDPkUKI6E
	sy9Pwlq64CsAn4cyBfQwQOnP8cR/PKPKZjDqobvCfw90Vtf/F+yyM/It
X-Gm-Gg: ASbGncvWIq3ZYHz7jj0W1RvL8VxWYfpAkjKI6QbQdmlW1th6RyppS03wM3FFZDAKPCD
	Ojluzve+dQc1q42uGgjd3LoPfiGoh4NZOLHly5ros9l4BQbwwrODnP9vYlKVpm7RmRkTINexsWH
	SIticHYY+qCRet1klNQq+WjFim9QPKnXzJJ0TniF59rHd1qGRzlqE49KCEaEhV8LDBNe5PA2xo3
	UcRomxPadyibzzMTNT+5n8drHAXRDat85h98ThQC9KBlyodWzaFO0z5SgTqgJ2xDrL1ammHlKVD
	R2TrZweNWuR5lU9/a+bYH55phb1Za2vnW4M3SGsbWcGhtAEs9qlT4r36yYrLRoAQO6zz4prz6CQ
	PmBuAVJ6NNUe+7V11QnvxBt5PHz3gR3UROHfRI0bXRV6b/r9wDKxfVpwZBFg=
X-Google-Smtp-Source: AGHT+IFkh+Dsusl7W0eZaZMeDrRwn+dS+RbgQkLCCUtH23wd4RV/h0puyQiwwz9U6vDWBLWzm6DZoA==
X-Received: by 2002:a05:6000:250d:b0:3a1:fe77:9e1d with SMTP id ffacd0b85a97d-3a4f7a4d55amr13099447f8f.16.1748945275715;
        Tue, 03 Jun 2025 03:07:55 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa24c6sm157191525e9.12.2025.06.03.03.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 03:07:55 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 4/6] generic/623: do not run with overlayfs
Date: Tue,  3 Jun 2025 12:07:43 +0200
Message-Id: <20250603100745.2022891-5-amir73il@gmail.com>
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

This test performs shutdown via xfs_io -c shutdown.

Overlayfs tests can use _scratch_shutdown, but they cannot use
"-c shutdown" xfs_io command without jumping through hoops, so by
default we do not support it.

Add this condition to _require_xfs_io_command and add the require
statement to test generic/623 so it wont run with overlayfs.

Reported-by: André Almeida <andrealmeid@igalia.com>
Tested-by: André Almeida <andrealmeid@igalia.com>
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

