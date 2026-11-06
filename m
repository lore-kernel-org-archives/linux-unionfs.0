Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980716;
	b=ZlQDYCCKF+E5ahYpliAQZpYbw5Y4YIwSJv894hgl6p1yL/FO5yXqsXM639P5hev90/yP
	 XE/01bGfSaPmqR78vkVP7jMRDumTauuQFyrg0fcuAMNlxR1jqIfIVf/fKjaUI1oXkWBEN
	 lrpLYo4Xkfg5GjBh5ePkY8sYNugiFVafE7M3jwNgVUCvi8pagWdDaxubL6bROzObSS41z
	 3xNQ2abIR9JEcvZDAiTzJ1/c+EcXsP7oJcui5aGuW0KP6vS8A7QXyPQtQc7kJ4mZeY3sb
	 9pQHISFeN70SkzrVX/rCNdxH3ES8ZlJuulfuQzPZj5VzhytG4vS57T8imI+L+LNefhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980716;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cnSzx+qXkdANiqDPEgHBYZwvlAI4prsezrDn8DaI04c=;
	b=zjuweXD6EXxaGWMX3yE6k6NFFo4kCA4UkuTOQ8STwTJ//u10XhJeWCMYCnP5j89ScrGY
	 RMdO+IKCqPR+rmUS9Xe8875bZ/LT2djyMTVntlncY+ky9RPkscAVMiMBzBnGFRTX6Cxd/
	 e9dQnRrB7t5fIHkEnF0NXpYLWKPQyumnQkL0EICDQmeHkKTL/6Cp81wvMXe5HsKno30lh
	 XRRHbyEOLv4Ct6p4eup06evsjJzB/lSf3/fila967ykR/zJGYc/Dn7YCxPrdakCpA+ItD
	 fNrXcGqwH8BX4hWnSX8O6lT8xcqX8dyt+bofQcfxBlWmVZiMV1JFRyDNSGR+BWJBQIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="tNra/hYB";
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FBF606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 15:58:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9FBF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tNra/hYB
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b203527bceso1119780a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 07:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793980714; x=1794585514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cnSzx+qXkdANiqDPEgHBYZwvlAI4prsezrDn8DaI04c=;
        b=tNra/hYBuobepJ6sCsGZKHB/Qx1EC2/iWfLLdQp79AS0zJyM/o0+8H2r4d/d5HsYhU
         57TueAzyxgQBHIpWSX7Pi/ZVWkxoseLhJ+vuGw3mQSMRMgV+JBztK46AHmrNCW2v11XG
         xFtXtKu40VN122xkLLAHk7eA7Dfo4S2/jv/XpLHu9dL/el/EL1xncp/XjpM3QIBAteTo
         c1BFDk4vYDCblwR59SrwMPlSoPijcE3lLM+ZPZPAQS6U5I4e//cDPAdRYJlJvTr1962E
         Gm0DwlVt2stik08VVsHNsFkx0ezd1bDxCADXp/W8oyayNwYOe7PtOo4liKSMZ9ivBDWg
         5pTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793980714; x=1794585514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cnSzx+qXkdANiqDPEgHBYZwvlAI4prsezrDn8DaI04c=;
        b=QbQ8+e4YmMAQ9QUm7si+A6gbyXLuYdYQbZy+oOx9eHsE0rnzfDGzcCtMK2kLuxq+T+
         SLoYRg6xrjA34r7R6bxSKk8nUaRrf/VZTmbeY4qoRM4UOfUTNskEBDg4lw+9zum+m0XR
         RwSzJCGdDciZpLlpSAmwVGUHqQ9j6cXgbu41wvFB+JnrFxTJQGz2M9yIe5fTu9qqjMHZ
         UNb6Tc/qhnZMYracGFbkPy7tQiEzkA7QPa338S+hrVUdWzLaUtSpkyRJeyqPnu0XnLUn
         xvpvlkHRVwq7v9zAwbguvyx1W0mmrdLSqyuuw4Ts0bbFcaRSkURxogjVBb7RCAYXMAgJ
         k2pg==
X-Forwarded-Encrypted: i=1; AL+hErGGWd8kxEfOKXkEILXYXRzeGdxwfc1DE3S9Nxc42hT+rzwo+RHYct7c9L1EbcS1Fa/xlRmPt5cTUxqSLrWS@vger.kernel.org
X-Gm-Message-State: APuU4Z/Xy37irKTdvgY6lUBxVZncCgStkz0000Ig4necjE8LHhf0x5+l
	RXEnc25Frm+90zMDW6HmiksXPzBWEPHfixjwnCr2qY2AbI1ADlrCcARB
X-Gm-Gg: AYBFou2l6GsFk2/YFJzZw/MzO+fkSKf6sw3VZghtsFJ3p07n/p/ep+T/KGJmmv2f4zk
	phu/5yarpysyILfSk2/wmf7U+H7ytjMXq3oBOiFH32zFnBDf80Rar0SvtCv4PCBNgFSAjseb2sA
	ewSgeiPGgVGVjqIiNmzukk4TcyKhmDnp/8Q6rWaZrfSF8+IMm55Jn0k8tt8JcDhMH5zLbkx13F3
	8wTmzc/XtSZga4Ye4Y/wd2ZYllKaFpVL7WbIJAjBCma9eP2lM7QAxpEKyZ2G3BjSU8PocWuSvZp
	9bIBAc8eU+wXHoXhsUAdnSwT6curMaEVVGjAs+yO2Y3cpYY+fKgt+zIW2BhU4Z8hcjr81vXIv3N
	iWyVZghr8mlGIVsPoOR6kyDYD6j954LnIvUE8CTEmtWfOrkA68mhxEWr+TvsXmwbqDR3uRqaGyf
	opCAOPMtEYHMTYmNF4WTASxSw42GsiHJhiVICyxczeHyrsup5LlJyehZc5sISnPpAOkSHwXkg8D
	/vbZJgghoaUAPbMauwq27RdP701keG277P0Lh876iHqeN9OpVLIE5lYTR3duGNhWSIBeMmMsG5k
	5Q5fr/0iT3htHqP8FRjJicptvJTcBrRpRviW39IXlBqSN+eY3LJp1ek8HFvxcrvH4U6+or9BwzL
	/Gi2aYUVdnFE=
X-Received: by 2002:a05:6402:2111:b0:6b3:dd6e:3dca with SMTP id 4fb4d7f45d1cf-6b5977e51e2mr2276657a12.28.1793980713953;
        Fri, 06 Nov 2026 07:58:33 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b669c4c240sm852689a12.36.2026.11.06.07.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 07:58:33 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Subject: [PATCH] common/overlay: fix _check_overlay_feature for default-on param-less options
Date: Fri,  6 Nov 2026 16:58:31 +0100
Message-ID: <20261106155832.3867017-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
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

Overlayfs only displays a mount option if it differs from the default.
Commit 73a018cb treated a feature without a module parameter of the same
name (e.g. xino) as default off and required "${feature}=on" in the mount
options.  On a samefs xfs setup xino is on by default and is not displayed,
so tests requiring xino (e.g. overlay/041, 043, 044, 067, 070, 071) were
wrongly skipped.

For features without a boolean module parameter, assume the feature may
be on by default and only verify that the mount options do not show it
with a value other than "on", same as for features that default to Y.

Fixes: 73a018cbf57b ("common/overlay: let _check_overlay_feature handle param-less options")
Cc: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/common/overlay b/common/overlay
index 132b2bf7..0cf6db2d 100644
--- a/common/overlay
+++ b/common/overlay
@@ -172,24 +172,20 @@ _check_overlay_feature()
 	# parameter (the system default) and per mount by mount
 	# option ${feature}=[on|off].
 	local default=`_get_fs_module_param ${feature}`
-	if [ "$default" != Y ] && [ "$default" != N ]; then
-		# Some mount options (e.g. uuid, xino, verity) have no
-		# on/off module parameter of the same name.  For those,
-		# a missing (or non-boolean) parameter means that the
-		# feature defaults to off rather than that it is
-		# unsupported.  Unsupported options are rejected by the
-		# probe mount in _require_scratch_overlay_features.
-		default=N
-	fi
+	local value=`_fs_options $dev | tr ',' '\n' | grep "^${feature}=" | cut -d= -f2`
 
 	# Check options to be sure. For example, Overlayfs will fallback to
 	# index=off if underlying fs does not support file handles.
 	# Overlayfs only displays mount option if it differs from the default.
+	# Without a module param of the same name (e.g. xino), the feature
+	# may be on by default, so only require it is not shown as non-on.
 	# Overlayfs may enable the feature, but fallback to read-only mount.
-	((( [ "$default" = N ] && _fs_options $dev | grep -q "${feature}=on" ) || \
-	  ( [ "$default" = Y ] && ! _fs_options $dev | grep -q "${feature}=off" )) && \
-	    touch $mnt/foo 2>/dev/null ) || \
-	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${dev}"
+	if [ "$default" = N ]; then
+		[ "$value" = on ]
+	else
+		[ -z "$value" -o "$value" = on ]
+	fi && touch $mnt/foo 2>/dev/null || \
+		_notrun "${FSTYP} feature '${feature}' cannot be enabled on ${dev}"
 }
 
 # Require a set of overlayfs features
-- 
2.55.0

