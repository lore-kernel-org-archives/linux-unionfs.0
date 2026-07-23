Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C990747606A
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 11:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807346; cv=none; b=HFCftHOWaJqCxZm9Ry+xa6QagMKe0hZGTSx+eKDp27fzoO1lg6zIpBsAQ2iKzGn/v9LugDDcu8ICk6DDvKhXqqGv/2xWBYeNvfO+1nl6KKRRsChKzTiXXX/rcQYPav9Nu8l7i2zTxqwyE/eaTxNdKtV+K8+lu0wa+zM8SKeGJ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807346; c=relaxed/simple;
	bh=rTDsSCOxbYmUkjcuwTKnRndv5Rs4BV8Vd4OBDKh1pVo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uGYTILGGLWWn9LhW2i1YJS7W4q0vIaa+Voq7ivsRBy6iHOEOVShyL1ZtBhKVwfFcgrvwwm5QkYVDhX9/xHyS03/CtaA0NX4N9unjBwwH/KWsRmY0omwTcdjTytD/LMFf+ZDe67xv2XHNgbNp0zEE2ybspxgX1Zbut5Nbwcmsk30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZRZ5w0W; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZRZ5w0W"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-698ab9aae16so834451a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784807330; x=1785412130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nfVwVKXLmD8/vzuRd7sH9V9P1HrMq7AUTPnYha57qbA=;
        b=CZRZ5w0WpVy/8wfkZdeHF79kspD3b4HlkV28HMVMTloR9jJyNi9Www5cPR3XKgGVXs
         yiTEBWdbpPDFRtPar3b+sjAcpQHolPDpB1me1mmzLevqD64OgXRxYEF91c22TPJESmP2
         XNs2Ao7rET977MNOxMR6obaMXlFAS7rtEkrMLIyc7Ws81d7rPsWFTHp7QzysX4p1cpn8
         eP52p1S6KVEHGglxTtpJmVRHN/ZvrOpHD1SLmdj1ZcJWTbwD6txiNZo+FlC2Pz5O/qwP
         coMa3gtakaiTTmwJsIlMsOloOe3bofIpJ843PDFN7epvgnCiXwJ3NIHhbMxkq5MIVoMA
         QuQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784807330; x=1785412130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nfVwVKXLmD8/vzuRd7sH9V9P1HrMq7AUTPnYha57qbA=;
        b=rC3KbTvRWSKa6NqTu3P2iB7jhIYiF1L+MREUqfPjmNbAq+SRT3W21EPNi/O9V8u7LG
         UZMkRFP+N6C6C1tQ/a7oXQQREnTwoy0xoO4q7mYZMiMZPWCZ9jEDpFaZkaCElGU0Zdq2
         DAelTOAQH/rntzbFIuQ9E6tb0GQfY5kOHqt1efQsiDOj/CdDT9MZdNph7LHoqQDXzFEj
         nYCWI9kneOlCWbQnmxIc5ZtqESq9oJqqff3q4+ligNTqROiX30QlrSdhgcJHyUhRLNp8
         JKl6NwpXhJdn88WbSQPGjj0KO3Bqr2MOVtldnUlo7j9BGqLatKcTzr/877PomQItz3Ta
         17aQ==
X-Forwarded-Encrypted: i=1; AHgh+RroGn2AprhEYnz8XA7I0Bn1t4kUt7ZKq7D0ZNjjIFJfKQoRKGbTLi7/WsgrIhgg6ecWwqAFQO1fXH/sd106@vger.kernel.org
X-Gm-Message-State: AOJu0Ywga+FIAdnvydb/evAIR5eWJ9H/MK7VS+dVPLTw5iIgiKd0ZClP
	PQoO6KwKLYr3O+ucpj6kV7FzZUj10efT8qCWy8Dq4obuf6Gp3KTmBZt93tDI0c2JYpA=
X-Gm-Gg: AR+sD11UxgRlkdIQypDKn+TTWElMuDI2yXjUa1s6FcuJje1bOhvLZD9NnC2Ayfqv8mF
	XoICdcZlXi+pEy7Ns3zmx1FqOAq6kuFjJ4ep5/CvQRShnyAExT40Fj5Mp2gbqKz+9q2hBgFiv+c
	XGV93U4Gqy49Usmg4sNRXCr+O/z0uyNTwhHApWZ5BlxQiFnlqu2+vrojCgPlr0HIMNLyiQZZ9kP
	8hiqNzZkqLVZbM3S0KqHuDZCq9RxX8bt6ZvjGK17YgbHc17Y70ZX2gXHX7zB7GHtvCyXAIbCoUm
	PgQsoS2gFgPjqT0BXkQAvjNxb6vq2IvUjfF53djrOIGFcf5DqJ6IxdLjrUXeWH42nlpCEe7zFcb
	M1CoHuly78SFdyrS7N4PSaL6mVuGxe+6PquSy3id6NmS2QVe/EGJ0FyZQil23ZY2RjQZ9VcpqWZ
	SIe767QYApxNyGLJ0sYtPh80UQV1PGCnpX761hpQ==
X-Received: by 2002:a17:907:a4d:b0:c16:2dc0:e1ed with SMTP id a640c23a62f3a-c1c5092a1e9mr143998366b.4.1784807329712;
        Thu, 23 Jul 2026 04:48:49 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a798a5sm223093066b.9.2026.07.23.04.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 04:48:49 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 0/5] Proposal for Cross-fs copy_file_range()
Date: Thu, 23 Jul 2026 13:48:43 +0200
Message-ID: <20260723114848.1212429-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Daan De Meyer requested a way to do copy_file_range() from overlayfs
to/from another fs, where if that fs is the base fs of overlayfs layer
the copy could be an efficient clone.

TBH, he also requested support also for cross-fs clone_file_range(),
but I am not happy about providing that.

copy_file_range() already supports cross-sb efficient copy (e.g. with
NFS/SMB server-side copy).

The current limitation of staying on the same fstype is mainly an
internal technical limitation (choosing the right f_op), which is
something that this RFC is trying to address.

The overlayfs implementation itself is pretty trivial.

Thanks,
Amir.


Amir Goldstein (5):
  fs: clarify cross-sb copy_file_range() code
  fs: add support for copy file range from another fs
  fs: add support for copy file range to another fs
  ovl: add support for copy file range from another fs
  ovl: add support for copy file range to another fs

 fs/overlayfs/file.c      |  35 ++++++++++++
 fs/overlayfs/ovl_entry.h |   7 ++-
 fs/read_write.c          | 119 ++++++++++++++++++++++++++++-----------
 include/linux/fs.h       |   2 +
 4 files changed, 130 insertions(+), 33 deletions(-)

-- 
2.54.0

