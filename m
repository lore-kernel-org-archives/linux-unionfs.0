Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817963;
	b=3pSKReyAUjtysPc3bIhum3EJxF56Lf0DB1A5aDXZi52+W39tP6Uz58l7d1/S37o2580T
	 E+RsApYHq1xFPq/QqJwSgu7DPAKDpwzj/B3uZOUWIPbIQk2VkuKOQDDwz3kFqY57asFwq
	 esBektB3DgNwbDJCIi5B5olsTUdM29ZNhbB0Tq51oMKv8cn09pYaeNybgiGBUlNNqQ2v1
	 b1jnehiNJaLP/Ex/28gH4eKUCZ53K5TRfnY0LwHF1eC3SZ8v9IfddVd+zd0JI1WnyM5yW
	 EW5kb3+FYsjfnd8GQMZ524nqnCvp/6jIvzTkjXT70ZaQBmEdwc0yY5WddtDJfHFrPuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nqWygjB4JG7NSBHpOz713BnlMKlP4sfn/CuveiDDwh8=;
	b=nszjxBhHIN0zrmelsfNH8Qu1EY+0pYbbrYvD8Elcnxj8gtp75wuBqNproai2yyHN/uVn
	 IOPl61H8ggzysJTkBG/xfgcpgn83OR10fwqcjseEN+3K4o41oBFEdYGp+/khHuHdT06QO
	 p/o3TR8j6/hFQqcB+oK37sh7RJwY4PVKiBaWeaTlFGrIMlqJCrR8t3WUse1NHxKdCqeVK
	 mk6YtNk0yprM5wDsgX4w6h+3XtGwpjyMF5FprOyXH/EJVNj8MwOnookbw72fNeAA2d2TL
	 thLPGwSRRgfP1sf4DaQGsFPZjfWClSgXfJjLEdEO8VNWwcWDrsuhIOM+RE4mjnjCm0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PyNF8nNd;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC390606A329
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC390606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PyNF8nNd
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso8452275e9.0
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817961; x=1794422761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nqWygjB4JG7NSBHpOz713BnlMKlP4sfn/CuveiDDwh8=;
        b=PyNF8nNd39XownyPdNwIKIUCUGOPxzGbsjTctjyXhGR2i4UGM25iCo3E9Ne8a08AfL
         QeTvblDtWqmAfM4rz8Gd/mGl9/BZ22yI5fPc4fyqHBoySSs2zY51Mx6f/kMqABgYYk0m
         Rh4ni1wWjQlfqE4pKmLFkXnpqLa1/b7EgFpExrQ083RUam3BYabWNW8O6Ejqh9tOAAJU
         eWjm/dI3GRLkIn4LTDZ2RDnPI2cmuNuP8Q9RlCjK2+gPXs73w9UaSh+RD99xggPnjgSL
         GTkCln7N/ej4HVG3cmpixClwdCCU8JEgLJX2gTH9Rx0aEqi8I7EOoSWQ7JCE9eU2ThlT
         O/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817961; x=1794422761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nqWygjB4JG7NSBHpOz713BnlMKlP4sfn/CuveiDDwh8=;
        b=ve/W6kKVaWzniPRqnWDj/6uFCLDKd3Qp2F/Vj/sIO/H3uwhvU+0Y4nh2R0ORn0o1be
         ozyzpNRPqCMRmoKnk7MfOaA1WDYihuekQlahirhE9XoTSwQMljFUTeudNsv3Xwb+5uXT
         XKisGMNpTBT5k4Ak7FF6xjqDbaqjT2aPGgInIpup4pJqW4/g1ilgi3MCGDzMTDzHqvdw
         aK2okIjfNp5lIrWra3d3/vIC1JbEkXBo87tA9qNz9iKG5S4bGhW2SdeyoJmVVKt1Niz8
         NL9sIvXG6S0Aeed2LNRMhw9pd+OSHqft5gAnYXM0yZl30lR17O0ll3DR2Hs+QKxK/JBU
         3r1A==
X-Forwarded-Encrypted: i=1; AKwUvBzFKyfhC3m4H9E7/nAQ7aW6UzZtaHuc3Ytg/P4BEbRn6qlEL2apMOM6xuzCFhtsOoD6MM6nKXHXeqb/+GYK@vger.kernel.org
X-Gm-Message-State: APuU4Z/gzd0W4JydMDM0961OA0m77aSfE2l8QXoonpQSi2ezPCKNW8PJ
	czv68i1dyPAA936Xn5snFbmpFIlNhRtUuyhv0G6eCf8eH3nRLMgH810V
X-Gm-Gg: AYBFou1F095G0q77ObWTcQjeu35+v/BAEhbt7W3/mknmTRFHJBwHb2tHGUa+ue/MHvY
	a9zwCHp+IOt71n/29bRGwjQHRFTJJRK1+8katnZtRqXvD+/0Be/tWFpBB9nGENM0PGOAoKTJWJ/
	e0YciFSqx56Zt88Se2L9dSJW0A8KTNlusK8u9A54DSdqtbSMl2S4+JUqfuMr9KADDGXZk5grE67
	1rs0Pt8Kr6wEa6W1gT4FtJDqnfgjFA09DeBKVeroI+S+qDWVZ4Gh815RkjiuzZRF6TubBCF4F68
	vJwe1k3WnvqUnu/qj5LsatEwolxI11w8rPaa7trQ3TIYDVRN+pioEnB+prGI+pK7CwKwapT6g0g
	Qy34ORePKjXvmomOa3JcWtA5jTfAjFItflhlXD1fhVqQ0FaHGBYhwW4N6YaML18q7DxxgihUggT
	HnROWtUKUBgw+VMxdAqgJTGxEFGRB6UV4IWdVMoqfZwYmjHpDGRzGFmStlE8lGANT6A8sCNrqX5
	6wmrX/YeCSKzRx17AkLQiMJT2XvbOxow9kCUAE52CFRFyvn40YWgMqn6BEMMYvkRKp2bWR/hBnS
	BqAOddItfEQNcU2z7GsEAwhDwMh7FdI0o4koiXLgXiUrVBU510qKZRzJQYSFhEPU6gM/rEa9VtO
	SB0JYwNZEJdExMQ==
X-Received: by 2002:a05:600c:3f14:b0:4a3:59ee:86b with SMTP id 5b1f17b1804b1-4ac14ec873emr370310855e9.4.1793817960966;
        Wed, 04 Nov 2026 10:46:00 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b572bba0f3sm3126655e9.9.2026.11.04.10.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:46:00 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 6.6 0/2] ovl: backports of fixes that failed to apply
Date: Wed,  4 Nov 2026 19:45:57 +0100
Message-ID: <20261104184559.3630145-1-amir73il@gmail.com>
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

Greg,

These are backports of two overlayfs fixes from ovl-fixes-7.3 that
failed to apply to the 6.6 and 6.1 stable trees:

  65bf000962a3 ("ovl: take a snapshot of the name for copy up")
  4f61ff2ebfb3 ("ovl: use the pinned upper dir in ovl_fix_origin()")

The same backports are expected to apply cleanly to 6.6 and 6.1, so
please apply this series to both trees. The upstream commits are
already queued for 6.18 and 6.12.

The patches do not depend on each other and can be applied in any order.

Thanks,
Amir.

Chris Mason (2):
  ovl: take a snapshot of the name for copy up
  ovl: use the pinned upper dir in ovl_fix_origin()

 fs/overlayfs/copy_up.c   | 16 ++++++++++++++--
 fs/overlayfs/namei.c     |  6 ++++--
 fs/overlayfs/overlayfs.h |  6 ++++++
 3 files changed, 24 insertions(+), 4 deletions(-)

-- 
backport
