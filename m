Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FC02F3609
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468186; cv=none; b=jYBuTJ+Pe86tNL2shWnoNbWgntTvyHkvAMmyr4Ce015Si8Wj8WASecEiZh4ipSwpvGB8Kj5XRtg05nmpjtxKx892eGmJwFh3A8vVlyWKS/hWlajg+oQWBFz/Hp4slU5K1WRRFQOkfPjjpwipQ8FQ4d295qQttVnikNoG7w9f9W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468186; c=relaxed/simple;
	bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5J0O8oEZAhugHGpN9b+lr/1TLcO3InXvIT1u5kK7uqXdUMaLylABdDx6jxWjeP8QXkP7GScmus3/LzK1NZwX23ddOX50QRFByCxg09ma7r1HAjMornyDPqCG84xejI15t72iJU3OIGCeZ8Bt49K05j8iSnKAIi5kOLWGY87k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KAaAzbrs; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAaAzbrs"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a099233e8dso40135315ad.3
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Dec 2025 21:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468184; x=1767072984; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
        b=KAaAzbrsGMa/yJ+ZeX66ACX313azU6u48dvdzrBwSic4HN62sJmYDXTq+VchukDU1L
         8sG8trF29f9VOcpuO7lWFH+BtnrkVzkWLbshB/5Fh07Cpq7NqkxHa1xuesIgnE8tH8Qo
         c3+byqUdmpSNC/AP16Hdfch35yejCD2kiF38JOHoQK6gtdj4WyMVRlnjcQ++8plqDvIq
         NINaKHODJxbdRib8oUYW69eNX7+AvJttzXqe0FP4ujNyHKM+xMXIBDuh4kEtf5cTmD4y
         0aVURA8jPi1DS5UAj6B/qSuo7DCtY/esApe51d34XyvYMy48PHQzwV0SOMUwYx1DdqtY
         fU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468184; x=1767072984;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
        b=xHAMpUa7fQ9rFbfsxR2pndW32Cy/0NnLk98ax0RFnYsKxS5WMGNvX7VGUoafW5fsvo
         0dcMXT4NYVHPoOaPYCNLsYn+pvP2uKMdGYCslGqYdWPXEnj5L0+bcP9ZB03MU/oIWY1u
         wAh+ODX7fz2VzNuvl5t12pMpO8NOTXetIpLREJykKZi5T/3RmzTrDZ3/wEMYMYRcPwG3
         Y3cjse+OHJ+5PKQ7UrTnlwu71pg7RTcS00S8LrWLHDqfK4ih+SCrdeMao917fBFQXQzs
         6W9VJWlqjWvMuKd+0BN6BQRw2f392BHdOOovK9+dl0Qw96Ik9ESgXHrb0tfCFYRqI+Et
         Bmgw==
X-Forwarded-Encrypted: i=1; AJvYcCVqxirfklONABQ2nTEwv0ipOm9ILFq09lglaplCC6Zx9Ph72NowfHP2Nk8KqTebE6I38Id/1YU2ow7Hluhy@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9U23LnA9U/LZz/DTFZgEy458MCPTzWqxpYCMqPfrQfg3dL6HG
	SDKLWefRZLc4gNqYY6rMgv/zbOOk+YLolX5lZ6mn/ucQvO7FTXSGYmUS
X-Gm-Gg: AY/fxX7rkccUMD77f94Lc3tZ7mrh/MDnD2tx9kv4a3sUAsKojgAoiYiPOUq30ZeryOK
	ZWa+utpSum5N+zjapYJJrFZMIFy5huGcDu16fYWFBZ87Kd/I+TqgoJgoFZBKF0BqZKHinNUVYVs
	LxrcNY+jCEwYgmmJCIQ6yKOPlYDCziMgDLZXEragKF8v5wJrtlCad2wHDjKN9/xzsHfMbYENQPa
	Q9yUiYsGWZ932cREyIBBa8Efz/SkuXqeQEnbUUjbhIDFVgyngpXWqfR86Sm8sUY1vX3o4Uh+MqG
	74xd7NFLdSdTBGfIOTkFM7Bt5yUGPICLA4dOx+dhHAnohtN9oeqwlP3gfU5lHVqu3PYYZO1VB/w
	CLszNLJofbNRYm8Ss47Hl+TVJAiUjYQgdipIevfCLvNFaRRF+IiRKCnZNEFdpIftYRtMdDytcRo
	bLcOmn0X7tJ7FqeEW8/Jza/gbNxmRvHvAaYEDxTq4s0K6uOUNaEZmuBm3QHU9ijuR8
X-Google-Smtp-Source: AGHT+IFX/6+bwcWXg/4km6FqYdkuwnUGcop1hJcfw4hTgcVNu0v2yNrPtPf/mgK+hd5hIFUJyC/N+g==
X-Received: by 2002:a05:7022:3705:b0:119:e56b:91e9 with SMTP id a92af1059eb24-121722dff1cmr11158229c88.26.1766468183950;
        Mon, 22 Dec 2025 21:36:23 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217243bbe3sm54039368c88.0.2025.12.22.21.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:36:23 -0800 (PST)
Message-ID: <4e5f6df4-b446-4ec0-a0d9-231756ee934c@gmail.com>
Date: Mon, 22 Dec 2025 21:36:22 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] fs: factor out a sync_lazytime helper
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
 <20251223003756.409543-7-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Centralize how we synchronize a lazytime update into the actual on-disk
> timestamp into a single helper.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jan Kara<jack@suse.cz>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


