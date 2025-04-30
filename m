Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5543E19048A;
	Wed, 30 Apr 2025 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746006982; cv=none; b=k4LLR9ePyoniAQ83+ZThaArb+oUX/GssTneHLJplbGIjjP3FDQSg0+s2SYLjqaOlJEmzlKsS9Zl9zPI4jlvdjyXxsZBWRNN3tF8k5UVcevw4+icmqtlEbiURXETGwCys52I+i4KRFRmIP/aHOgG84c/6UuCM/Lmjv/ofzaGURqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746006982; c=relaxed/simple;
	bh=NnGrytTwTZHQleCYZ8rAXg134++vlxbWC85ARLru5Eo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F4LquosavSDFbNY739mTbGJQz4lIw8k3HbPq9dpBQt3L0kqzJpcshPNaFVA9WoZ6YcTyztRws9OnkfuLPpcgMS3Zj1GLOrn1KgL9j4vJCgCrWtcyhT7Bau9Jb2Ol1/0qw8FgQbKsOx0F/o0PqB7Al6upse839S1+mRzRtnKEZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZnXf208G3z27hV7;
	Wed, 30 Apr 2025 17:56:58 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C11F140295;
	Wed, 30 Apr 2025 17:56:13 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 30 Apr 2025 17:56:12 +0800
Message-ID: <8f76ec4f-fb8e-46cf-b59f-ef95c500a85a@huawei.com>
Date: Wed, 30 Apr 2025 17:56:12 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] overlayfs: fix potential NULL pointer dereferences in
 file handle code
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <amir73il@gmail.com>, <linux-unionfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
References: <20250429001308.370040-1-wangzhaolong1@huawei.com>
 <CAJfpegvKvHwU69F0wazk_TyrKPCcrcVU+Z+5=UNpg29CJGH84w@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAJfpegvKvHwU69F0wazk_TyrKPCcrcVU+Z+5=UNpg29CJGH84w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500010.china.huawei.com (7.202.181.71)



Thank you for your valuable feedback.

> On Tue, 29 Apr 2025 at 02:13, Wang Zhaolong <wangzhaolong1@huawei.com> wrote:
>>
>> Several locations in overlayfs file handle code fail to check if a file
>> handle pointer is NULL before accessing its members. A NULL file handle
>> can occur when the lower filesystem doesn't support export operations,
>> as seen in ovl_get_origin_fh() which explicitly returns NULL in this case.
> 
> Have you tried to trigger these conditions?
> 
> If you find a bug by code inspection, try to recreate it, by that you
> can also verify that the patch works.  If you cannot reproduce it, at
> least prove that triggering the bug is possible.
> 
> Without a proof the patch may turn out to do nothing at best and
> introduce new bugs at worst.
> 

I haven't yet been able to reproduce these conditions in a live environment.

My analysis started when I noticed the inconsistency in ovl_set_origin_fh()
where it accesses fh->buf without checking if fh is NULL, but then immediately
checks "fh ?" in the next parameter. Following the code paths, I found that
ovl_get_origin_fh() can explicitly return NULL when the lower filesystem
doesn't support export operations.

>>
>> The following locations are vulnerable to NULL pointer dereference:
>>
>> 1. ovl_set_origin_fh() accesses fh->buf without checking if fh is NULL
> 
> Hint: fh->buf is equivalent to &fh->buf in this case, the latter
> obviously not being a dereference.
> 
>> 2. ovl_verify_fh() uses fh->fb members without NULL check
>> 3. ovl_get_index_name_fh() accesses fh->fb.len without NULL check
> 
> These are called in the "index=on" case, which verifies at mount time
> that all layers support file handles.
> 
> Thanks,
> Miklos

Thank you for pointing out that. I'll work on creating test cases to verify
whether these NULL dereferences can actually occur in practice.

Thanks again for the guidance.

Regards,
Wang Zhaolong

