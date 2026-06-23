Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D923D5660
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 11:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215966; cv=none; b=evP4fJ7fhS+2lMdDm7j5xABfOoY+CV85huzdZCT3VGCiAzlBTP/NyccEJHBJIlHsJKdBoLfL1ef8H6bwOFntXS1Y7JUY4avwiuFt5zxLEo0mFQTomopbGPV8//BOzzLzld0ACP358xpCK2wcQZb5huisOOB877/lLym5RyuQZ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215966; c=relaxed/simple;
	bh=rwDSFrm8YGfVdIZnuElmZf1LT6AgXzYYNzgg2zMqcKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bZRpdOABYff4IFShLmzr2vL5mul+85HcS0/p/Y/TzS+GY+4aIxxA88w5vnktaMnEprNrk1SvM4dDFImFerv/IuRxXRzDBK0uhnVuGeq7K+L7aJ7q0BmpuPwbvsm5+PGSJIuLB/n6mXNXjNYU8FmCZKdlgLIzpvNNyta2CFG7h14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aqVnQGOj; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aqVnQGOj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782215951; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uWuusYigIaa2o9oUAuPJQd3Qjw+qoDdwk3dZsAIv9eM=;
	b=aqVnQGOji7qD5l76/JsFIlqkRQV3vTEP0L9eLtdDjntafrIySKEkbbJqSFLxaFTMcHrCSjKWcwtjKqxMI77DKr+6AHKjQmqxt0xCQpaEcaykupJXESTgYGBJRHO5kpbKNTen4IjSt1nk3hNVzX6d1m85VpqlgDztFEPWAPfm2lU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5UBqIk_1782215949;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5UBqIk_1782215949 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 19:59:10 +0800
Message-ID: <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com>
Date: Tue, 23 Jun 2026 19:59:09 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 fuweid89@gmail.com
References: <20260623084337.54344-1-laoar.shao@gmail.com>
 <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com>
 <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com>
 <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com>
 <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com>
 <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/23 19:38, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 6:25 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2026/6/23 18:18, Yafang Shao wrote:
>>> On Tue, Jun 23, 2026 at 6:12 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>
>>
>> ...
>>
>>>>
>>>> Again, I don't want such customized messy breaks userspace
>>>> again; with that patch, container runtime needs to consider
>>>> if `volatile` is the default which just breaks the existing
>>>> containerd versions.
>>>
>>> I'll leave this debate to the overlayfs maintainers ;)
>>
>> On my own perspective and be responsible for common users
>> (and as a containerd maintainer [1]),
> 
> No wonder containerd is getting harder and harder to use ;)

What do you mean, can you explain exactly?

You're just adding a new way to break the existing
applications, no? You just breaks previous shipped
containerd.

Add a way to change the default behavior is fine, but
the new default behavior should be worked with the
same functionality and compatible, but switching to
`volatile` feature is non-compatible and what is why
containerd dropped volatile.

I've explained the technical reasons, can you also
show your technical argument why you cannot patch
docker with a very little change (if you can
livepatch the kernel) and just restart the docker
daemon, is that hard?  -- Also, is that requirement
common?

How pre-existing container runtime versions know
their default option is not "auto", how do they add
mount option "fsync=auto"? and how do they know there
is a new sysfs knob to work around incompatible
behavior?  there are so many container runtime
"docker", "containerd", "crio", how to make sure
all these container runtime aware of the new
default may not be "auto"?

Thanks,
Gao Xiang
