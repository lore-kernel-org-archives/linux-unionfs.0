Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0602192D8B
	for <linux-unionfs@vger.kernel.org>; Fri, 24 Jan 2025 05:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737697248; cv=none; b=csOzUnZO7C5yXZ/xO/9UH1nypgvnyvQ4pdAOJzuGt/8XObo8AwR3GgnTSmt8XCLrk1YAnWMpwkz0JilGUvEW6uUXBnMPdwiVkTwLhoCKGhxMixGRLGXHNAT6DJI/eB8gzhK3ck0igV+O1eYMct0Dwh1cMJu6ef7RWdPx6CUHAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737697248; c=relaxed/simple;
	bh=ZLiqe0p4ONwr7Pb1+j6Po5Mh/rmsilne8qInEOtePxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FSYCwDvSXO2hD/AZVE0e8vh0VRpB+roECh6AGeBEkD0JoMY/Kdg0v2uPZ6dcMGFPFUW0JoeeJHBEpQf+RZSKdWsSnq6hE/6/NBUNL7wonaB7TwzhuimtBiuzWy02q5yKsi1tJStRxGGI0uMF1tva08D1bwKPIWF2zIqqxb8UAkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=NIsjEChW; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="NIsjEChW"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-851c4f1fb18so47101639f.2
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 21:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1737697245; x=1738302045; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EnAMiQ6FrKoOi7BfbYz1A6tobcMOXcN/EpR0AD4yLlA=;
        b=NIsjEChWcoavu+qJIXl/aUCWBkUn64PGimR2x4UD3mkf/Ve1nYnxmkmwfbsuxibu/d
         jmF+BJESvzIiRDfFLK0CIKgFuZeKYfvQcM1FvLj7oIsIRWU3iVszGFaUHgPDCFJ+G4Lc
         G4XWL4bq0EE0EWg7n7nAe8FfAmf/jGM6CK4rIgmT0yPcZUZaM/+vopDnZBplQ+VJ+yw+
         IzCGR1yMM1cbXxA2R6G7E98dKan/iDHdWGJ+unqb0eL1r6drUhLADuqSlLkQ3bdZIdvT
         FI2DGj7Lll8BbdceF1+KovPkaOs6tAdJvwJeOEVY/rZI5x/ZvwyHexfGyOtHQOOi/F3p
         cSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737697245; x=1738302045;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EnAMiQ6FrKoOi7BfbYz1A6tobcMOXcN/EpR0AD4yLlA=;
        b=Yj8SCNoSXBc9Rk3H7tZ/AIGOCQAzQS71kbdZWukbtM/m6rXIQp6WPqrIehMP9sCwaz
         wQSmXY4SjjHiQAOMhb1UsnBDB5gwNzUTWuj+W6kDf2skQP08g5E2ux3eOwYLXXn4gwBx
         6jIw4EdJnl2sl81pWHKMimOL/bEYb5NsU2CB6xUNwlpfVYK4ce1R0ERtIHZ+TtwWF6T8
         wFscD2fOLdHco5YXKEdyMmDbvsCKxKnxdnrEchxRvLUmBmY4mAt+y9Oyk3s+5XN4wvGa
         UKO2z98IV9Lv+pdhHNwRCuzV5r/TiLqY5S0ZEkMoPX53CaTbg9dks/jM0Z+arryQY9sg
         xb6A==
X-Gm-Message-State: AOJu0YxHHu/4okqpbc6dxJXL9RHE/DVlPdtruJAIEezEUF/lUfMSodjc
	bTVUFLERhsVqM8fEkM6N6TrGemg55185pf0JR6j7pkBf/BK4bAmG4g1E7EE7Sjo=
X-Gm-Gg: ASbGncvMbaNxKouBXF4Zk4dUCI3g78e5RwsdRYyuQpqBsdGwdtJasevGlPLNiVhluXq
	2detQZE6IrZEr+m3xz/HyEaP7VNe8d1JScbzqsPqULo1J5fCwoVx9XJJbZudTGQnHfLXpSd98NF
	8tuAadpubDwj6RUC9odH98Uq2jmZSGvXEhY6OCw8+zyibaE+n67/DshHer/K1MlNAtj3SjZ7LzC
	lW9RhFAIy5Z8g4i3hPovWsYAOXDMnxHewWEg3Vv/iHyyFdziF15ujGs2DnHTQVp1d6EP9TXse+q
	1sjaALBZu+qvSJoglJOUmbm+OsjR55XdX2KIE7X8teEQ
X-Google-Smtp-Source: AGHT+IFL1+FHADZjO7EcqpJuV8xMADHyeqrDx6Eno0dhmWXKENFc4bRKPPvqgKaLxnYTdC0efu5BIQ==
X-Received: by 2002:a92:c245:0:b0:3cf:bc71:94ee with SMTP id e9e14a558f8ab-3cfbc719535mr42861195ab.14.1737697244776;
        Thu, 23 Jan 2025 21:40:44 -0800 (PST)
Received: from ?IPV6:2601:444:600:440:56ac:fee5:d1d1:52d3? ([2601:444:600:440:56ac:fee5:d1d1:52d3])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cfc740f7a7sm4106725ab.6.2025.01.23.21.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 21:40:43 -0800 (PST)
Message-ID: <e7733291-48a4-4b65-bbdb-8462b9708af9@mbaynton.com>
Date: Thu, 23 Jan 2025 23:40:41 -0600
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ovl: Allow layers from anonymous mount namespaces?
To: Christian Brauner <brauner@kernel.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
References: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
 <20250123-senkung-spangen-c0aabc251c65@brauner>
Content-Language: en-US
From: Mike Baynton <mike@mbaynton.com>
In-Reply-To: <20250123-senkung-spangen-c0aabc251c65@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 13:21, Christian Brauner wrote:
> On Wed, Jan 22, 2025 at 10:18:17PM -0600, Mike Baynton wrote:
>> Hi,
>> I've been eagerly awaiting the arrival of lowerdir+ by file handle, as
>> it looks likely to be well-suited to simplifying the task a container
>> runtime must take on in order to provide a set of properly idmapped
>> lower layers for a user namespaced container. Currently in containerd,
>> this is done by creating bindmounts for each required lower layer in
>> order to apply idmapping to them. Each of these bindmounts must be
>> briefly attached to some path-resolvable mountpoint before the overlay
>> is created, which seems less than ideal and is contributing to some
>> cleanup headaches e.g. when other software that may be present jumps on
>> the new mount and starts security scanning it or whatnot.
>>
>> In order to better isolate the idmap bindmounts I was hoping to do
>> something like:
>>
>> ovl_ctx = fsopen("overlay", FSOPEN_CLOEXEC);
>>
>> opfd = open_tree(-1, "/path/to/unmapped/layer",
>> OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC);
>> mount_setattr(opfd, "", AT_EMPTY_PATH, /* attrs to set a userns_fd */);
>> dfd = openat(opfd, ".", O_DIRECTORY, mode);
> 
> Unless I forgot detaile, openat() shouldn't be needed as speciyfing
> layers via O_PATH file descriptors should just work.

O_PATH ones currently result in EBADF, iirc just because fsconfig with
FSCONFIG_SET_FD looks up the file descriptor in a way that masks O_PATH.
This took some time to work out too, but doesn't strike me as a huge
deal. Although I suppose it's one of those things that if it were
improved far down the road would probably lead to next to nobody
removing the openat().

> 
>>
>> fsconfig(ovl_ctx, FSCONFIG_SET_FD, "lowerdir+", dfd);
>> // ...other ovl_ctx fsconfigs...
>> fsconfig(ovl_ctx, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
>>
>> ...and this *almost* works in 6.13. The result of something like this is
>> that the FSCONFIG_CMD_CREATE fails, with "overlayfs: failed to clone
>> lowerpath" in dmesg. Investigating a bit, the cause is that the mount
>> represented by opfd is placed in a newly allocated mount namespace
>> containing only itself. When overlayfs then tries to make its own
>> private copy of that mount, it uses clone_private_mount() which subjects
>> any source mount to a test that its mount namespace is the task's mount
>> namespace. If I just remove this one check, then userspace code like the
>> above seems to happily work.
>>
>> I've tried various things in userspace to move opfd to the task's mount
>> namespace _without_ also attaching it to a directory tree somewhere as
>> we do today, but have come up short on a way to do that.
>>
>> Assuming what I'm trying to do is in line with the intended use case for
>> these new(er) APIs, I'm wondering if some relatively small kernel change
>> might be the best way to enable this? Perhaps clone_private_mount(),
>> which seems to only be used in-tree by overlayfs, could also tolerate
>> mounts in "anonymous" (when created by alloc_mnt_ns) mount namespaces or
>> something?
> 
> This should be doable but requires some changes to
> clone_private_mount(). I just sent an RFC patchset.
> The patchset is entirely untested as of now.

That's awesome, I really appreciate your prompt attention to this!
Applied and confirmed your patch works for my use case.

Thanks
Mike
