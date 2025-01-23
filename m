Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D71C01
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 04:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737605905; cv=none; b=BEaS0xOGxju46CHqL2KcN9WLY6JrNZmKEveOM31nt8mH1t8qnJ2Aym+eMoT1gA+w/OimDgYNWIl1hn0OFv3UC7cE/homk7O7x5KOTeMc/lJT0cA+X/SyYjKe1jwL6xuR6SJvtL0LlcItv2qefNKc8Xf6r1KCMWJ93QbL9idxwnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737605905; c=relaxed/simple;
	bh=IuDKnVyTBJUlbxR6Qyu+qG5o81YYoVI6kHdSpf1vWw8=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=oZma/V48VFwZhbWzTiYDUaObJq2V0fvTSyk7zPPDj1fyOiVT+2MWZc4M4kG+p914o7uDZCufAGvuav+qscUtPBKXSiRoPR/GBLyvdJlM+9whHCImiIXeo2WbIPZChP3UInf7djaGqU29xXKPGha9EF/P8gLUvnlcHno4w/DFkzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=oF5yWTq7; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="oF5yWTq7"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-852050432a8so16123139f.1
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Jan 2025 20:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1737605901; x=1738210701; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:to:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuDKnVyTBJUlbxR6Qyu+qG5o81YYoVI6kHdSpf1vWw8=;
        b=oF5yWTq7XDLhpMH1b7eDF5/p0ougyPVe0z+OYNede7YHyqWOLfjsqTWvGOhK375riP
         GWo+pZNAQKttvmr1sAB7f7+ZIb8UPN3MH02Gg0QGYh5/0S3BXi5TDJoD8fveZE8p2SCV
         MxwKlZhzJ9my0JdwKVv9MhwhY/MF/EcC2aF9HT+5TlUUFUTZaGR34nv0+ykOB6cKjwye
         20CZX+NKINlKfw5oViKqTOhILF7c6og+u9x6evXNqcGlR1mTga7xI2LaZwrlvl8aIAGt
         krwS6aZIvv7QExh8BF6u58EEQB+mL94imh7HuS8v8LQRkqZ5fXXKfWeudNAFBJ2N9v1s
         CUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737605901; x=1738210701;
        h=content-transfer-encoding:subject:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IuDKnVyTBJUlbxR6Qyu+qG5o81YYoVI6kHdSpf1vWw8=;
        b=Xp8Ubl8/3JlK/YUr3MCDS08EBB2fKeRpEYlPdlfLaigTIUCY4iBzEtIUbcXvG2Yz3L
         yG0HylcaWb17cz0Aih28ZBCKco3So1eyzLydKm+JbMnhj0mle57Fd2zd3ynYhlAnrohX
         mdHRkbejBtnvIRdzgMTLBzNTCBW5vGP4Ytmk7eNBDlSVMil+WWCwaKmOSdYjq/rhmzN0
         8bMPCnycvwYsZnkA/WtYk63ALNY/AZfglZ2iByYkU9NLA/5MnSkLsmQYVXGAYBHXJYh/
         8gv2L08bvEKZzrLEk1gbxVhFh30uthdEgXQf+t9GQVsrsAeJVdigqGfcAVgsSWIFuD53
         P3uA==
X-Gm-Message-State: AOJu0Yx2dAW+HSgto4Q8iw1X1F0VXb3uBuCzRkVLFgS0WBfowHCC6//I
	QoeS2p30I/Q1MGD32otQSrcfXl0fxzPPXflx2WXHmn7UkymCqbW5ENun6NIKgGq4wp+7qmnk/sI
	t
X-Gm-Gg: ASbGncv4KdTnfpPzQIN7eX2pUYTd77DpMUK6cvu96VQM/UmsILZh4axq2KcXuOe32NH
	j5FP/7IdCy9jmVxq3iSC9rdjoHIuZ5typTtjxDx7/5sdYV+BYoTnFZ85UT9WN8sI5SY3B/Mlknj
	sa57A9TVzLiQIglb/WU1cjkP0vk1PCDQxH2TH2B7GZp6st2qGDcdl/kkwkHEDPUzBxFCvBYQyI7
	Cgb947iimCt0aaLB53Kb6yX1XvqRMM1GMD58fecDgyUux8AaihQaWEd07vQKnaPnVW1EBLg25HB
	4J8FmNv2OrS/U3IUQOydg7xiuru1iFcgAjUofZPqG8RDVP0W4hvNt48=
X-Google-Smtp-Source: AGHT+IF4Uzu2DgOlt1wdZehxojE1gUs/ZU5QMU77+HkJlcgzxFn2BdALX7G/Vqr0UQyDdejhwp9gtQ==
X-Received: by 2002:a05:6602:3f07:b0:82a:a4e7:5539 with SMTP id ca18e2360f4ac-8520bd34c60mr183992339f.2.1737605901358;
        Wed, 22 Jan 2025 20:18:21 -0800 (PST)
Received: from ?IPV6:2601:444:600:440:cc67:99cc:311b:bb17? ([2601:444:600:440:cc67:99cc:311b:bb17])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b04f7107sm418992539f.39.2025.01.22.20.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 20:18:19 -0800 (PST)
Message-ID: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
Date: Wed, 22 Jan 2025 22:18:17 -0600
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
To: overlayfs <linux-unionfs@vger.kernel.org>, brauner@kernel.org
Subject: ovl: Allow layers from anonymous mount namespaces?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
I've been eagerly awaiting the arrival of lowerdir+ by file handle, as
it looks likely to be well-suited to simplifying the task a container
runtime must take on in order to provide a set of properly idmapped
lower layers for a user namespaced container. Currently in containerd,
this is done by creating bindmounts for each required lower layer in
order to apply idmapping to them. Each of these bindmounts must be
briefly attached to some path-resolvable mountpoint before the overlay
is created, which seems less than ideal and is contributing to some
cleanup headaches e.g. when other software that may be present jumps on
the new mount and starts security scanning it or whatnot.

In order to better isolate the idmap bindmounts I was hoping to do
something like:

ovl_ctx = fsopen("overlay", FSOPEN_CLOEXEC);

opfd = open_tree(-1, "/path/to/unmapped/layer",
OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC);
mount_setattr(opfd, "", AT_EMPTY_PATH, /* attrs to set a userns_fd */);
dfd = openat(opfd, ".", O_DIRECTORY, mode);

fsconfig(ovl_ctx, FSCONFIG_SET_FD, "lowerdir+", dfd);
// ...other ovl_ctx fsconfigs...
fsconfig(ovl_ctx, FSCONFIG_CMD_CREATE, NULL, NULL, 0);

...and this *almost* works in 6.13. The result of something like this is
that the FSCONFIG_CMD_CREATE fails, with "overlayfs: failed to clone
lowerpath" in dmesg. Investigating a bit, the cause is that the mount
represented by opfd is placed in a newly allocated mount namespace
containing only itself. When overlayfs then tries to make its own
private copy of that mount, it uses clone_private_mount() which subjects
any source mount to a test that its mount namespace is the task's mount
namespace. If I just remove this one check, then userspace code like the
above seems to happily work.

I've tried various things in userspace to move opfd to the task's mount
namespace _without_ also attaching it to a directory tree somewhere as
we do today, but have come up short on a way to do that.

Assuming what I'm trying to do is in line with the intended use case for
these new(er) APIs, I'm wondering if some relatively small kernel change
might be the best way to enable this? Perhaps clone_private_mount(),
which seems to only be used in-tree by overlayfs, could also tolerate
mounts in "anonymous" (when created by alloc_mnt_ns) mount namespaces or
something?

Thanks
Mike
