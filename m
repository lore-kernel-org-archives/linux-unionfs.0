Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E6E2F546D
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 05:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468242; cv=none; b=bRCZMdNhhaNth2AYiNmrHKRAXqKXD9pW/FyNea6TNWWmjarNJzHQA5JTuprtZnIszFJPL6BCpTwtUDmemrMDosYp0QOYxJfd0bdZvM+GzaUYtSOJshRuKiA/9mfR8cprQM1sClyVUAjN019KZdi5BcI2AEb6Nag2637PfftAiNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468242; c=relaxed/simple;
	bh=PhRs88mwlwkazk+ENj6MoiJDiZn71PTbJFD0EWthhgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SofpC52g4DAykYo4BvSTGGNdAtT0gywyfoUPsXFdmiqvjpwyyy5++RrgmbEcsyg00lwPgH4qT1lx6fBvdlbpo7pMB8vNNXiYriOqtdUjnMltWCcRzy+RV2FMUxLOPuLdnILQXw95/k9wL3ZtuDPu4A2RKQmKz7kWhVg1n38E884=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1L+FowU; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1L+FowU"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f30233d8aso57588865ad.0
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Dec 2025 21:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468238; x=1767073038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A82QF1EkZtulULncIKG5BayS1YlCBJFC1tpTXCRjsWA=;
        b=m1L+FowUPIMlYK4jS0rqd66lJOxSEu9UNgALQ5BaPsZY0mYIff/6weYhiZEE+MrrkM
         9aobe9ahzY2NcVvdmuxqVWtMOkmapJ04qlH+b0btXifJRKnEEtPaUiqLsELDhj6jt70w
         EK7sGlcQ5d76EwzvypNKWSgDYHmPE+8BHcUbIBj4EI4NxbY3KKCwI4ZDp1KQgpy98Bs5
         C6GPDqRf9SXQuuaRHvzF4K3LE21rBYkM/shcj4phJZQDM3tLR9Z+daG+i6MPaX8M21Le
         aEgz9SUcfIi+tbtgXj18ewhgT+GqS2CX4Nhkk1K9SsmOF/RYGt1NhIV1GMZhSPb1cXVy
         zIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468238; x=1767073038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A82QF1EkZtulULncIKG5BayS1YlCBJFC1tpTXCRjsWA=;
        b=CSnahTU5t4TFPk/AOlEMc5H3zbz26QaZao/c5EgGhjlf4NaUCOkYccUHaubkRyZWmE
         AYxt5U5IsK5SRcCirqbc40anVdCZx8VgMAWQPW4/e+qG9dUPWcmCTaaQECqlkyfJBeMA
         kLNPZFOGDrvkYf0av+3xCmy6uaGsMAAWy9PckTOiD2kt+hxRA3VJM+lm0RetxOXqZrqA
         h2FpjCtF26i6K6GRQI1ChLMZ174mQ8uGaeafzQYlifaB3guQiOeSGGiqyLuXR0qhLseg
         m0OkKI6PZiZnXGpulgRTtmblbsRLg/GUC9Rvja8yC+2sFXi80yqf6TgmXt2MTzt8TfZ/
         lWxg==
X-Forwarded-Encrypted: i=1; AJvYcCWoCwNGCkVr/q4QYzOr8nnC/v3rtXHkEByAtUE2Ei9F6EDz39DtiQQiHWg90ZcW1gkticPXqatxuB73mKQh@vger.kernel.org
X-Gm-Message-State: AOJu0YwQmDUtk4oHfOwxOPaItfGKxCkNEjAeKRYWoZTNzsI4MPkHDriI
	OGMxoVNvnHiB3+e4PSZSEYpFo+NvMO5Lp8nsyDDsn5S6G3Qb8IfZ4TI/
X-Gm-Gg: AY/fxX7xEB/Fw8vfJlP1qiaqsAo1Hxl7Z278J/2eWRHyCIgAYtT6G1qGe7qS1JttPdf
	t4pg5ABHmqBrd9ltWj8kr+VCid9mgkIVmubKKE/IaqiTKoVc5f4OoxGBWrjnNGPxPN2Ga0juhN2
	Zb4re6LE/A/SYlOpQLvm2cQh4ce+g8rWllaSsWb+C0yfZvTfKQ+C5vF27cSkfOQFt1PzzzdD6T+
	9fNBJmCOuP0jFoz0i56uBgE+rPK1Ra73llUeM1VQ+BuDTU4fH+/YRRwasyG6fZV6hpKoD2/92nk
	4/z32JxrajS/wai4CHtNwnXxNdWqe6Zv6lu2vpHumznffkSaF/9vajtKZdf17PfoQ6XekAemr1K
	mE2uQODpk3rVz5t3RWHPLrXkdn4qMbYH69AUQvgRZeLt+3AwmWHmt3v55EYHgjeFiKuikvLpk7q
	7exFIGbaSKRKuyBNtVJSKXCujaynM1V8k3VpA+afVgemof1veEBYCj3+QGzH5cyi9xpMuCMPqAt
	PQ=
X-Google-Smtp-Source: AGHT+IFuAa1bEi9iXQ/fVsFOwY92P7NTqag0Itb/bLEcgCW/+Bj05+w6CIPRTwzaf559s5BnxudUFg==
X-Received: by 2002:a05:7022:1e01:b0:11a:5ee1:fd8a with SMTP id a92af1059eb24-121722ab372mr13830811c88.13.1766468237569;
        Mon, 22 Dec 2025 21:37:17 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm52514131c88.1.2025.12.22.21.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:37:17 -0800 (PST)
Message-ID: <5789c903-d3f6-4c41-b342-8d29387688e5@gmail.com>
Date: Mon, 22 Dec 2025 21:37:16 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] fs: add a ->sync_lazytime method
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
 <20251223003756.409543-8-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Allow the file system to explicitly implement lazytime syncing instead
> of pigging back on generic inode dirtying.  This allows to simplify
> the XFS implementation and prepares for non-blocking lazytime timestamp
> updates.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

