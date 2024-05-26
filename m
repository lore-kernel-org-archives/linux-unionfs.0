Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E7B13048F
	for <linux-unionfs@vger.kernel.org>; Sun, 26 May 2024 21:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716758500; cv=none; b=bXU9R3aX7nsQHcqBb2yKeoF5We8DfTrhxJS5QqWP6OiJk8QSdGMJHK0PZ1T6HzL0VabqfEGa2dYsm+xnREAocrGaMZV/2MwtqwdrFdbyXyNTjAlk1U8mrBeLzckf7rhMpJsX0q+4Gj16K78XZ1WEuGZglHzKF6b230/JuOepkGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716758500; c=relaxed/simple;
	bh=h07742SfbAhVzUh56nb4wWh/jm6ZTEc0nPN1Utkt790=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJ9Fh6MTj8S+PqBEqrb+kAjhg0YKnM/o6dZs4WdhJ1H9uprYFdNBI70VUOEWUrSK0TMp8mO8lNzAvqaLvlxCTH6wCxk2N5jOmhmkrlb+eCRBZIoRWjxe18Bd3rc/U4YO4jE9+2y99pLf06DJiZPphZWNqI2j0Os5KNeP0/bGELc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=eeZcNRTZ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="eeZcNRTZ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4210c9d1df6so13522655e9.2
        for <linux-unionfs@vger.kernel.org>; Sun, 26 May 2024 14:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1716758497; x=1717363297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FrZS6a+2WmF7PbI/Eek9PooMML2FIBwy4rVSyH7zOdU=;
        b=eeZcNRTZMjJO4YnNQC5LsnYWgEIEkaUK7VRrH2kgUN57tFqpRYGi9DVEihP4of3sIX
         XFLo842CUd6TJFClqdCyoxKP0te2StP2BYj3h/ptB/PiBi9jpAkMBsippgKK0J3pqEJH
         R14zp2THbaJYl+KsKidRXo48qgeBJSPBPU2hqy/3bbtB9NsymtlzzatQfU+XMQB80FWK
         fKwxkoD0LmjeF/WNL4zIpQ5zpgY3svmyFyA4Mtz/1t2NmqyXjVHkFc1PTyPBT6rmZxJD
         i4AnJKVe3Y9UYTMYyxOeYGa0jgZvR3PGL+gswoKY26xIXD/VVS5lI4rh73iRdFUK8Wcf
         10yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716758497; x=1717363297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FrZS6a+2WmF7PbI/Eek9PooMML2FIBwy4rVSyH7zOdU=;
        b=ZaQ5NL9hYkHUhXS4JbitvMlOKyQC3kteF3nidxt5G5Gqux6wv26Rd7ffjwxyeWvoTN
         JWevXX+CXqrT5hwrRXyyt3C+/ddTJ2njXNNgP5+rUuJchuQa4W5pJg3Q5xsSRZgHCj2L
         wYk40QuT6xhim8r/eKvwMCIMPQgPeWi674M5iRvjwArbOfPoEFHkzux3q8XuRWsBpYEZ
         HjbsonJfA6nIZG/6kLFVRh8RcXDLhawCu1OI3jPA28S/SNoIl2NVD+3P64ut9ziUNLfy
         6sDTjEwfDnqyb+Dm/6ZpZMbbj1kMMPry8PJIAf0UxElzBuhxX1808naLRX79F22MZzOI
         YZvg==
X-Forwarded-Encrypted: i=1; AJvYcCUbBXksQwggk9M9j8hgSCGEShgQ8rYQvy7D5PNfcwLyXj1mmaZai24E9O5WxFpdT0bCK8W3GUYY0Oa1IiZa8vIEAas7Lzshq9dDL7bLwg==
X-Gm-Message-State: AOJu0Yw3br3rsYiAhJh+xiff4Km8+vgznylfISmKBGa69Bj8u7TUb9cq
	q665OcRdsIIyfdPQJnHBfB7p4d+x9O0+r5co9c7iJNiIpvXym5lYBsVdJKttaqY=
X-Google-Smtp-Source: AGHT+IHW4ae7lxNWn2WaLCNzfX0cTLfvfU9RcG3UisSM/eMD5CFFw81oCKu+GmqWICgbek/bKosQUg==
X-Received: by 2002:a05:600c:6a93:b0:41b:f359:2b53 with SMTP id 5b1f17b1804b1-42108a14eaemr57525155e9.37.1716758497510;
        Sun, 26 May 2024 14:21:37 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-100.dynamic.mnet-online.de. [62.216.208.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421089ccf32sm87534245e9.48.2024.05.26.14.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 May 2024 14:21:37 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: thorsten.blum@toblux.com
Cc: amir73il@gmail.com,
	bhe@redhat.com,
	clm@fb.com,
	dhowells@redhat.com,
	dsterba@suse.com,
	dyoung@redhat.com,
	jlayton@kernel.org,
	josef@toxicpanda.com,
	kexec@lists.infradead.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	netfs@lists.linux.dev,
	vgoyal@redhat.com
Subject: [RESEND PATCH 2/4] fscache: Remove duplicate included header
Date: Sun, 26 May 2024 23:21:09 +0200
Message-ID: <20240526212108.1462-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240502212631.110175-2-thorsten.blum@toblux.com>
References: <20240502212631.110175-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicate included header file linux/uio.h

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/netfs/fscache_io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/netfs/fscache_io.c b/fs/netfs/fscache_io.c
index 38637e5c9b57..b1722a82c03d 100644
--- a/fs/netfs/fscache_io.c
+++ b/fs/netfs/fscache_io.c
@@ -9,7 +9,6 @@
 #include <linux/uio.h>
 #include <linux/bvec.h>
 #include <linux/slab.h>
-#include <linux/uio.h>
 #include "internal.h"
 
 /**
-- 
2.45.1

