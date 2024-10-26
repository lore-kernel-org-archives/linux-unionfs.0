Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37E6AD51
	for <linux-unionfs@vger.kernel.org>; Sat, 26 Oct 2024 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729966072; cv=none; b=c56sZwxiVYQFLPnLowgluLgfPI5iwMI77o5p1DAwYJOrIknqypcMNJvuCg96j3kR/uCYa2yNxE7rUJ2r9Jb4xizurbOKPQ2Ik0zpMq98lO6ey+w8RNYsnQ6qeT5IXgPxGg8k8BYn6JlJ52hDVd9box4H6wdgNQHpJ433Vz+lb4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729966072; c=relaxed/simple;
	bh=1QFbTwbnSFZIKn76mERT+TPoiRoBmyWsDuqCfRvXIzA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oOWblqTX2htyqMOP9ZOzmClf38MkzjBRmlEw0mHUQPOhsH7bionCo4UWaJZWTa7gy440yic+YaFsfNZmPGjVPQEQswlmValr3alKYxrzEjZ9bf1tagwzL6Jn6znvQ6NeqySVTVW0gcSt2DZZHH7Bu/rbuYrMYk8zvxB1xmbUVXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TaQNFatD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TaQNFatD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729966068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=eW1tcTR3ZT2bXqpdZC6hnHzo6OX3DgG++QMnE6IyOYc=;
	b=TaQNFatDX7PLKbIII7a57mNtWCATfeCHdxwzEdAN8swG4XCB1N5dAW3yRAnI8ujVJK0qch
	I3inXBnLqd+hzRK+XDrvFS3kDQyFaZbns7xL7ynHE35w87txDD1E8Pee7gebha/LNmvKLY
	8axrPZeIuPBGqkNkN+BzUtFKBw/p09o=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-Z7su7CVqPvScdOjUb5zrhw-1; Sat, 26 Oct 2024 14:07:46 -0400
X-MC-Unique: Z7su7CVqPvScdOjUb5zrhw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-7eb07db7812so2209605a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Oct 2024 11:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729966066; x=1730570866;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eW1tcTR3ZT2bXqpdZC6hnHzo6OX3DgG++QMnE6IyOYc=;
        b=JDD7CJiAn0YkdQne609w54g+TJakc1cAabpMo639YmSi31RLQOB0K+iJOongrlVS3Q
         U+SRQZ8GKyDc7TYC2vRWaLNPHMOKls+etodpnPlAxIl2fKij/4q2KXpy9gORvrUGL5UG
         hsqMRwd1kGF0/FJ4L842SP6EC6rpb2+0T/Jy9h5BdpbmN7PX+/LJ6moc+3GmN5ql2+HD
         wGrSW88g1va5wSeNm4+g/og9hpmYa6GgsSZpoNwvVPe1WyMjHmDMqzmxA88Bn4J9ZPWP
         Fql/6EzAhtlO8EgC1nOUt3AXWuir+i45WTgWwE1bx0sANKcqiEq7KNhYFiL+G1N2W2mb
         9oqQ==
X-Gm-Message-State: AOJu0Yx7/aT9bgWGt0Zi1GF0HFqFAu9hQIjqPoD10MhB7RE2FMnWPbbu
	fBhIK2vxX0prNSYjKbb4859jI0ZkADjO3GdWLKaZOqX3FF+29h1Cxadw9/r7S8Alta8a7OZE2pO
	YKslXKar+A8yu0ijpJhfZdMrKK8i82fOm+rja20l6cw1xfdR1gcQzPOlMg6+4wIY=
X-Received: by 2002:a05:6a21:1709:b0:1d9:d5e:8297 with SMTP id adf61e73a8af0-1d9a74df555mr5360960637.6.1729966065683;
        Sat, 26 Oct 2024 11:07:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdreep2PC7L5y0L8vt6dIbMUrtUGJO2dctcc3K8eKSDa5KE/ORzAzSyUXzOTsJGkTvWzZglg==
X-Received: by 2002:a05:6a21:1709:b0:1d9:d5e:8297 with SMTP id adf61e73a8af0-1d9a74df555mr5360933637.6.1729966065352;
        Sat, 26 Oct 2024 11:07:45 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a0cfaasm3064802b3a.98.2024.10.26.11.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 11:07:45 -0700 (PDT)
Date: Sun, 27 Oct 2024 02:07:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: lots of fstests cases fail on overlay with util-linux 2.40.2 (new
 mount APIs)
Message-ID: <20241026180741.cfqm6oqp3frvasfm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Recently, I hit lots of fstests cases fail on overlayfs (xfs underlying, no
specific mount options), e.g.

FSTYP         -- overlay
PLATFORM      -- Linux/s390x s390x-xxxx 6.12.0-rc4+ #1 SMP Fri Oct 25 14:29:18 EDT 2024
MKFS_OPTIONS  -- -m crc=1,finobt=1,rmapbt=0,reflink=1,inobtcount=1,bigtime=1 /mnt/fstests/SCRATCH_DIR
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /mnt/fstests/SCRATCH_DIR /mnt/fstests/SCRATCH_DIR/ovl-mnt

generic/294       [failed, exit status 1]- output mismatch (see /var/lib/xfstests/results//generic/294.out.bad)
    --- tests/generic/294.out	2024-10-25 14:38:32.098692473 -0400
    +++ /var/lib/xfstests/results//generic/294.out.bad	2024-10-25 15:02:34.698605062 -0400
    @@ -1,5 +1,5 @@
     QA output created by 294
    -mknod: SCRATCH_MNT/294.test/testnode: File exists
    -mkdir: cannot create directory 'SCRATCH_MNT/294.test/testdir': File exists
    -touch: cannot touch 'SCRATCH_MNT/294.test/testtarget': Read-only file system
    -ln: creating symbolic link 'SCRATCH_MNT/294.test/testlink': File exists
    +mount: /mnt/fstests/SCRATCH_DIR/ovl-mnt: fsconfig system call failed: overlay: No changes allowed in reconfigure.
    +       dmesg(1) may have more information after failed mount system call.
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/294.out /var/lib/xfstests/results//generic/294.out.bad'  to see the entire diff)
Ran: generic/294
Failures: generic/294
Failed 1 of 1 tests

Similar failures happened on g/294, g/306, g/417, g/599, overlay/035,
o/103~109, o/114, etc.

They all looks like related with new mount APIs of util-linux package.

Not sure if this's an issue of overlay, or overlay test cases, or new mount.
So report to get more attention/review, as some new linux distributions might
start to use new util-linux with new mount APIs.

Thanks,
Zorro

