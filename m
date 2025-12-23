Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0390B145348
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 05:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468350; cv=none; b=efZRh5/Iy+jyRp6W+O3pptvrk8xvCb7gnxhrvyYX4XQgd9MQ9b9v1EUb1GRxb7GL1XxXOQPsjadADjYfY2W2zIxdUMGBQAKY5sZOwQ4DyNPfwunSoqX71jvlyeApM9a9jaLuJ/lDACikmqcm57lTCDuRkvf80/axnxBYg00UhgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468350; c=relaxed/simple;
	bh=4EYwI5dt6aXRXkl+FSZUrQuoyCBEuH9OaUQ78T0nqW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UyXCFGsWDSXZvkz/M6tmmTCR956I4V627Z6kfFvtmHEbceX0K0bt8QcJsS6wLbTiXqcJoj970QaYSJhAQMWhdMHoKdVX44het/TQi2SA9Kzza5B30cImNCszZH3C0/64F8JirdjGy3+X8h49JDpZA0UQteNw2+iWdJ8sa3BLUt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AmuGU0S3; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmuGU0S3"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0834769f0so46360265ad.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Dec 2025 21:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468347; x=1767073147; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V0Oa5NOGMRC1AJFdH7RGft89mUSkkZqf9Qovy9KVtFo=;
        b=AmuGU0S3tNTq4XtJ8CPVuHsrup5GslR4U1PsfZM5q7Es9j9PRoBOtcmrNZjZY9bYX2
         UKR+5USfuLaeedQBq8VdFeWlSpdtJwj9cUx0XSPWF6iw2+/Dx0Y5UVucH/qMMErYNCo2
         DmPMJSCgLNX8OFyioDFMPSDOCAjVz+YVUY/Iz/KUSFGJ2xhlgSyingmuGzIf1Ot4VcrN
         bRMe9e6HU5DXOTn41IlUPOezYioUBfH4sOmBJ/VJV2wbgRChwx/8WJgiqq1vVmt2UJG1
         sPq57LHY2hmsktX2yrFZnu8K5GlUfYr80BrqjJruZXf92pssdcqPz8wFkvEzjVdz2E5K
         tIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468347; x=1767073147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V0Oa5NOGMRC1AJFdH7RGft89mUSkkZqf9Qovy9KVtFo=;
        b=mXe+ewMT2Ailw8ZPiwGN3HMi6G8u2I+KKlgYOE+D8rRvAAvxs+EUGc5iyXr2fdA3eo
         ZPHJoWljKMzRo3CeMFlaWWtXTI/26XuOgWU4ViubyBisnOQbw5aeh/ihoGbTzGWEjM9u
         MrIceRbXldP7LXK2BF4zvHiC8bp4J1vxypLmgzFfw0s2QnQ2BLaY2ET3MPIoab8NHddM
         6roaZbHvAdspXjzMfkCZSikHljfSuUDTXXWBzGTjMRhzjZWPVpOwGhOyvtgW/1Q8JQpM
         Aj8vPHSgY4+Sw/u0AO6cjSgDySC41+Wqc1P7UEUW5FvgaJFcbLjWZp+bWzEqACsWFmWi
         vUwA==
X-Forwarded-Encrypted: i=1; AJvYcCV5D/CdmHmcbADB3sk6zC+Afp+Pats14GdIaeTR4YefckVrVu1swPsWEJemQMXbbpFCj+rf7HHbLeJFtadN@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6pO2SGV1l2paE3DEqHL5uWPMvN2smNlyvLVtXPU+f1zObztRK
	FS5QETSrOgwt74i8F3CpoIN24mOqbolQ5JWB3x2ci+MwNUzH8JzYmhNN
X-Gm-Gg: AY/fxX404ymfayUfjRUcugg0wd4v6ilu35e6g34eOWI8Svqz6RzY5iyZ+0lfZJ1OWpb
	vCQn7GkPaUzKLUFo9XWUediV+mtM05fh3gEyfY6E0lWDmKiuB4K8QCNuwO/puCF2cs3pkVSYCXL
	vGrNI2KQewj8IYCtwTZfNFcjGo50uQHz5DnZghvf+EaVPGnoyAa8EHzJrKRhsWPDm7i2ClrvKcZ
	5mUR/1SI/tt8axzWzybkR0bOY1FYG2nbqHkdgJwU9x+X2joLss4jQkiih847hIaVv5XkONV86N0
	hO2PdmlmE1KB16A5jpA3+gmYm6K//bVqfELOS6DRKGJNuAws4taiN1JIrdJ6s88skI78anKWlCR
	3paz3d2Wt9fmSK8EA9wEbRllt78Qr+dL6r/ilOUXToI83LnTDrr7nBP1+cl3fLmT/gv4cqnfb04
	XRp2jI0Fx6+AcNw2bqQhTrI2Q9YDBvp4wOGNofkCmfxLbD8GLFN5Ia0amrX5RdgnXD
X-Google-Smtp-Source: AGHT+IFzlCLo+BvPmOwaQvXqt6LlTFpUSJebHNJribHXa7k68xn/ydFompByNLrYdKm0zAa3YWAnPw==
X-Received: by 2002:a05:7022:793:b0:11b:9386:8257 with SMTP id a92af1059eb24-12172302180mr11142291c88.44.1766468347292;
        Mon, 22 Dec 2025 21:39:07 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm40285157c88.8.2025.12.22.21.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:39:06 -0800 (PST)
Message-ID: <bc999618-1f1a-4ae7-a81c-57062d57614d@gmail.com>
Date: Mon, 22 Dec 2025 21:39:05 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] xfs: enable non-blocking timestamp updates
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-12-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> The lazytime path using the generic helpers can never block in XFS
> because there is no ->dirty_inode method that could block.  Allow
> non-blocking timestamp updates for this case by replacing
> generic_update_time with the open coded version without the S_NOWAIT
> check.
>
> Fixes: 66fa3cedf16a ("fs: Add async write file modification handling.")
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


