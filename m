Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D254E26ACD
	for <linux-unionfs@vger.kernel.org>; Sun,  8 Jun 2025 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749394716; cv=none; b=mn1HvY7y3LddvDA0rFNQel1No0B63voTIPYQsgRuZ/CkNXXWJtOm5Y6aFgVhIniZyHMHgC4Kw79647rvp19JLBDZWrUIAPSrhksWgL7SvVf0D2MI0Bv7bGQ6h5vwN+tV+vfeQeIMkP8MeJmHwSJoWDXYiiOo3lh7ZgtJpo7CkI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749394716; c=relaxed/simple;
	bh=5Z1pYM3g097do58ZrkE9xezPcVfwaTQeCdF+KsiLtEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rilkTt2oLWBe6YGIPGQPJ171ruMvAlLgdfyuYItxO086hZ9VFdZXUtl/BLNhdhZlHClOmV3qCpNBG6K8TiQl3sDlkusCJfqOlluXBra7y3BWZO2gt5rFwQIX78ms2oTZQTS+eszgA7LqdlnIuzzKn0OcZn6efdlum60oF6M2f8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qpel3aX2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qpel3aX2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749394713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=1MHolxAo5E7JZonvdA9Y3lwdbEbD6V98FiPVx/5z218=;
	b=Qpel3aX2j97b4enRcec+Y2JrsizDNKee/ZZAWpqHvV2UUiLg+SDb/N0CSa7pG2s0NE7InQ
	L8nraU113n/w6KnnHNl4SImY2G45JeE8nYgIuZoAdFJEQ2OcrfWO6D5oepHDHAgznXV2JB
	bEm5YJMDodeLBfGgCvL/7hsvpC4v4+s=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-cU9HSrSdM0Kp-Z1G3PaNtw-1; Sun, 08 Jun 2025 10:58:31 -0400
X-MC-Unique: cU9HSrSdM0Kp-Z1G3PaNtw-1
X-Mimecast-MFC-AGG-ID: cU9HSrSdM0Kp-Z1G3PaNtw_1749394711
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-22aa75e6653so27629425ad.0
        for <linux-unionfs@vger.kernel.org>; Sun, 08 Jun 2025 07:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749394711; x=1749999511;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1MHolxAo5E7JZonvdA9Y3lwdbEbD6V98FiPVx/5z218=;
        b=oEH3n7lTWtRLLxhXL/JB67p4wPrD9lP5flaOzgDXl7MmiBDuffShC4aaJRrrw2C+3G
         uSIz7cCBTJ7h3kWiL6X0/YviFIMHwJp/QseKUpbt825e4ZsvEfmDxLtQfK9NETWgCmTv
         J2bXLCTUKhgXoOeM6r+vizjCcaIrasEBYPnOZaUmNiFM6pbmF7kbo6YqtRHKoysu9v+g
         UM18QSNhRbXudlFfhnEwkrUw+H38zYB4xYmRzSm/FQ2yhU8yZjpUNqYSaAzLPfsMEG4c
         cGHo4cQ3Xyp0TyWHwyg8Y9m6pcI5tJRfO5x93Yn5/ebLchYy2P2heUVpktd8gXp2ddcq
         kAtQ==
X-Gm-Message-State: AOJu0YzNG3KQk/V/SxG+JDQN0+/niVyIIIrOSuoDWoh+SE5klvxVhSsv
	wz5RVeMxgbf5ABtIIRGtz3wVFBWvGZhb2PqlgMH8bPBe3mYBWl1Moj7KV6RPU+TGZRJCnWiYu31
	k+OgEqs93ln8eufPXTP3NRuYDuaB4VOIJXFm7bOP+ORi3nl60EujkBF3pgpUgmmpKFJ9MK3+33G
	IVBrrwRByx66RYoEOcegw9N13ECSVFrEgriiO7JfvvzbNkSNo=
X-Gm-Gg: ASbGncutiUu7Nj7nv2+JVJiShBu3wyISL6LklhWiWYC9sHun8tjX5WR/vNidxfT7y7n
	WV/QIae89rBBJZm2Oo0A57A5nSkSOn417dMTpSZRJ+vYBx8a9sq9NnGOnAWzTYJHgYQP5n2Rbrl
	KEf42NoBPf3EdQgKeXsddV3wwpEDzZo3tAPkKrciXAtlys7sA4ymc39TA/s+7LUaZ0S3Qgll512
	RxhgpTjd8PA3hQQQfZlvxe231GG27wc7rH7r+9HlNJ3y+7jJEQHe5HMU19NR/ZTanTMMduyF3oY
	8oh+DHzYxmBgELXVvZq2oYJQBt3PVFQKMOSRBOI3zSwKlpBnD6iRPY2YQaRxjcA=
X-Received: by 2002:a17:902:e74e:b0:235:60e:3704 with SMTP id d9443c01a7336-23601cfd8aamr142098905ad.12.1749394710702;
        Sun, 08 Jun 2025 07:58:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6zgFz1OgK7vGhC0J5T7M5M3OsmE5aZevfwZYvpqiu8BnuSlE7/CCItKjGt5ir09qmy7W6wQ==
X-Received: by 2002:a17:902:e74e:b0:235:60e:3704 with SMTP id d9443c01a7336-23601cfd8aamr142098725ad.12.1749394710268;
        Sun, 08 Jun 2025 07:58:30 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603092ed7sm39909135ad.86.2025.06.08.07.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jun 2025 07:58:29 -0700 (PDT)
Date: Sun, 8 Jun 2025 22:58:26 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>
Subject: [xfstests o/012] unexpected failure on latest linux
Message-ID: <20250608145826.s6fnuitdfjb4hldr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

My fstests regression test on overlayfs hit an unknown failure (diff output):

  --- /dev/fd/63	2025-06-07 10:18:01.306026526 -0400
  +++ overlay/012.out.bad	2025-06-07 10:18:00.941720188 -0400
  @@ -1,2 +1,2 @@
   QA output created by 012
  -rm: cannot remove 'SCRATCH_MNT/test': Stale file handle
  +rm: cannot remove 'SCRATCH_MNT/test': Is a directory

Due to I never hit o/012 failed before, but it fails on this regression test.
So I report this to overlay list to double check if it's a overlay regression
or a test bug.

Thanks,
Zorro

