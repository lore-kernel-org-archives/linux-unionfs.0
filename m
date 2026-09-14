Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5A64457D2
	for <linux-unionfs@vger.kernel.org>; Mon, 14 Sep 2026 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386177; cv=none; b=koc7uVOLcsOQf1wygyOIQUWcx17erqRxb7t7v9C9K1wtnec3XCHhGyiXyR/mo9zPXlmvFPEvKlIhYZP7D/A2EVjqg5MQmGXFRVDJmIw+aWEOpNh/I6kE2+z5a2DG3inZvEofZqOdTocrFyMvx8qbUF+nzlXQGjIzrT3md4Yumkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386177; c=relaxed/simple;
	bh=ytgr5qGXcmxK01M0r5Gvov3JBIsNN3OfRcD8se3NAJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oROcO2YW0D/JnXsEjdPZq82LVDSglubCj66QYz9nuhVKAeooOL93T0dn2IGTqyj9fscsdW/Ew8RgysGijy7t9Q3AsEKldnOV0OohwSAubSdn5TQMTeHG5CJswywLjH8pCZj6S7FiMI5ju705SeQdIChqmkVBJDMU3f0bJf1hiJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZE9fdXup; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZE9fdXup"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4c3304784so1693290a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Sep 2026 04:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789386175; x=1789990975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o4McCO5QA5RDLTkl/ISRPyM2FuR98SEf9b6QSmXRjYA=;
        b=ZE9fdXupoQy0hOTvodhBRlbLg/2BlsUCugkwserP71quKzflXEKfNS/2vibw8RVusO
         9VmLu4oAJmK/dl5ToN/ftXXBbl3wazGrIOdlLm5u0IycDuV0rDlQtPhx9TLcoq/nwLbq
         7da1yqteeSyN33mRF67ts2pQn3R53T2CcCEGhrYAhVbqb7MoONJalLkgW+MUB5HiU4X0
         Zc6omaPT1PoQaxo9uAQUxB9Ka6jXQEjrqgQ645N9nrRCmTaCn1tGndy6ihL/P+pHHNEd
         R+2DZRVApcxPpmqjYPFa2PLOtPuhlWiOscdt/g23HUnIdtzIYvL1cuwSjjWrfAl/RDKj
         5Cew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789386175; x=1789990975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o4McCO5QA5RDLTkl/ISRPyM2FuR98SEf9b6QSmXRjYA=;
        b=s3lcA86bQ6ozVJGxbSBQhkHSU6L0IG3S3t/WJVvZsBOBGjKGeTebVLqJ/kTKV2nGbe
         sDvGONxj3+RUzPJ2MKb20IAhdntRoFCIzciJwjom7mHAdrYZ9LPI/1wQBr3qYteXbNAz
         yWpXzEpNpBdgGBNfL6hUVxutXc1/+KhS1TeY2N1butTNPVSDM8nPIVcy7fY7xcuFKc8Y
         EeV4ol5aRynrBDsrBMdzqajEszfnK3buxoJkidqr5ueVA0BDoK42FMMRtWf8s4hBy6o3
         qPxxYJ0vMY/NH1ZnA70Ssan3wziuRVTKFMd/XWHAR5/HI7p/X60D1cBsVhn1ndS2d69B
         Ud+A==
X-Forwarded-Encrypted: i=1; AKwUvBzZ7dBQRg1sjJPgbv0N0QRix78lYNSyZv4RhmcEN781fGV0q25hMZ4DmBRQFVIoKdwH5N6gAaK0s7fCUNoC@vger.kernel.org
X-Gm-Message-State: AFuF++mSgIwkYl7HW1tKj9FcIpMDsF3NQQsBaGP2xtNLiyngEhYctoy4
	tpueFnz0Jlg8HWP/8XAL6Ds73SaXPPlhFb9mOqauhgx2XbosTKQBdQRB
X-Gm-Gg: AYBFou0BQ/Wj6R2H3tsed4lcphuTEFY2WxKgnTSF65Lc6mxb9x4+/eUamo2qqCrlUkr
	0XvroqiYs0zgBNid3C+JWUE+Ekyaf1qMIpsV5Q5NbWdDdT33h/NoVH+PMqbyTuGExSx3AXBcQRR
	9mxy91ryVQcEd1Yg77fbwQ+pxhpEm2YrqcbClIeDZR65YI9T8M7KTy3GquEBqqx0fzZZN1suWfH
	Mr7+G3A5+cvaYK60Dyt4rf4sJdiA3i3ZoJgmH67fIAJPAo+2Ly83jr/Z5wAfopG+OTER5ItzATQ
	dUVli2iy2PBFWgZGnyoV7s/iF2SeRyTJHLBzfWaZxqq0bNnPfbAkPPJM21t3uhjTKlXW16BAJpL
	Vf2kT7KAusStJrnTH6OAQFZUHWXAdCxPQvlXdYd3QQSx48t3e1xeShq/8rhsfup7743O40CjnOs
	KboVBz0avoE6J3Y/+fZv9tbD6pAe3TqC4mkD6TgMDfuVQiM2SliC7RQeOxnC6arvHcM6A2zs10T
	I+4/2vpwkFgUxfQ3D3WpzU6t6GhQVZ46MGGZ3tawM8Gse+D1zxwSx2wlVhuTw6djgilWSh7tGzy
	Epw2o8cPB2PtziHKvbQWZfbIDQ==
X-Received: by 2002:a17:903:240d:b0:2d8:d4cc:be68 with SMTP id d9443c01a7336-2dd6c75858dmr51731475ad.21.1789386175200;
        Mon, 14 Sep 2026 04:42:55 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (114-38-150-193.dynamic-ip.hinet.net. [114.38.150.193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd34c7f976sm44032275ad.81.2026.09.14.04.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 04:42:54 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Matthew Wilcox <willy@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
Date: Mon, 14 Sep 2026 19:42:49 +0800
Message-ID: <20260914114249.663-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAJfpeguhxCEs3pZuqAZ-gpG5gm7NV-TuzniSkCCrgAQ-TV6ZpA@mail.gmail.com>
References: <20260827170718.497-1-aa9736195201@gmail.com> <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com> <apGCDtf-gE1osJqE@casper.infradead.org> <CAJfpeguhxCEs3pZuqAZ-gpG5gm7NV-TuzniSkCCrgAQ-TV6ZpA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 at 16:18, Miklos Szeredi <miklos@szeredi.hu> wrote:
> There seems to be a logical fallacy in saying thp_get_unmapepd_area is
> the most suitable value, yet not making it the default for all
> filesystems.
>
> Saying this without any understanding of the subtle difference between
> setting .get_unmapepd_area to NULL and to thp_get_unmapepd_area.   All
> I can see that the difference is indeed subtle.
>
> Can you please explain?

I had a look at this.  thp_get_unmapped_area() aligns anything with
room for a whole PMD in it; nothing asks whether the file can use it.
NULL means no alignment at all, and 34d7cf637c43 kept files there to
avoid "unnecessary VMA fragmentation and potentially worse performance
on filesystems that do not actually support THPs".  The case where
that matters is a lower without large folios.  32 x 3M files,
mmap(NULL, ...):

                          ovl over ext4           ovl over squashfs
  NULL (today)          16/32 aligned, no gaps  16/32 aligned, no gaps
  delegate (v1)         32/32, 31744K of gaps   16/32, no gaps
  thp_get_unmapped_area 32/32, 31744K of gaps   32/32, 31744K of gaps

squashfs has no large folios, so the alignment buys nothing there
(fault counts were identical) and costs 1M of address space per
mapping.  v1 only avoids that by inheriting the lower's choice.  fuse
passthrough already pays the same, as Jann noted in the 2024 thread.

Hope this helps.

Thanks,
Yuan-Hao Hsu
