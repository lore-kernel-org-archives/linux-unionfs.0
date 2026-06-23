Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33100364028
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 09:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782208162; cv=none; b=speVZzKUrm7GwocbKrQvsDzhKh59iurdapxQ8uOr83a49rGtvbTX192S0Sd2olF9Afb92A0jsIPM7HTR4yiGRzHCEira/lWPd7aj34qguE/naqAHDCoGT38OmCUB4K31v/ghnfBCtpQa7Jg+YPwgyI0uLTZvA4sfAew4E8l5xaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782208162; c=relaxed/simple;
	bh=X+LjnAL+NdHQkms6W51UcXAzHuSGJgtNa4HsMaVVofM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPdRDlNr5adwETAOxjCRVwpBW4zGBuzE0BjZoHXHPXLbYbOseVNjbHqLJz9+BAr/2HZenScOHNsbZrhKROZprv0mmSxaSkWUgS467sas0S3wZ1hn0Eji523RASmleYk365k0JEi7XfboPlNNqXXTBntlsfE6933s+P5fLOzFdoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Xi3RsXP/; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Xi3RsXP/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782208156; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PiK26C8m1SuwrrCeNWosUXjR1ZKwhnpxh0tjhAB9RQI=;
	b=Xi3RsXP/eTOxFyIgsbLZw+yZ8VixnowlY++pTu5vIisBU2Y4BBrVLR2OTvplWfTEEySiGTuQUFBa8p73dOaewBUgHYiWbgMGPnD+/CjI2qf76pOxkSwd7c+pF3yRdOTkqARMpfaQBsPloU5lG5XonOQYpPR6F7zW9FVsdAgeqYU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5Ti57d_1782208155;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5Ti57d_1782208155 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 17:49:15 +0800
Message-ID: <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com>
Date: Tue, 23 Jun 2026 17:49:14 +0800
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/23 17:34, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 5:25 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2026/6/23 17:15, Yafang Shao wrote:
>>> On Tue, Jun 23, 2026 at 5:00 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/6/23 16:43, Yafang Shao wrote:
>>>>> We have enabled "volatile" fsync_mode on our Kubernetes production
>>>>> environment to prevent container exit from being blocked when there
>>>>> are many dirty pages to flush. This has worked well without introducing
>>>>> any issues.
>>>>>
>>>>> However, on some of our production servers, upgrading the container
>>>>> runtime to support the "volatile" mount option is not straightforward [0].
>>>>> To address this, we want to enable it by default within the kernel.
>>>>
>>>> Just a side note: "upgrade the container runtime is not
>>>> straightforward", how? it seems that issue is already resolved and
>>>> there is no more discussion.
>>>
>>> We still have many production servers running Docker, while the
>>> "volatile" mount option is only supported by containerd. Upgrading
>>> from Docker to containerd is a difficult process.
>>
>> But docker can be patched too: if upgrading the userspace is
>> hard, why upgrading the linux kernel is easy?
> 
> It is quite easy since the kernel can be livepatched without
> rebooting. My employer is a heavy livepatch user. [1]
> 
> [1]. https://lore.kernel.org/live-patching/

It's just a generic opinion, in general, docker can be live
upgraded without pausing the containers, and upgrading
userspace is easier / safer than patching the kernel.

> 
>>
>>>
>>>>
>>>> Not quite sure applying a default volatile policy is quite feasible,
>>>> especially the issue documented in
>>>> https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
>>>>
>>>> then userspace cannot drop `volatile` option as a somewhat
>>>> workaround now.
>>>
>>> OS vendors can still set "auto" as the default config, while customers
>>> can override it dynamically via sysfs. We have been running with
>>> "volatile" on many production servers across different workloads for
>>> over a year, and it has worked as expected without any issues.
>>
>> but sysfs setting still applies as system-wide, and there
>> are some edge cases that we cannot apply volatile as
>> default, that is my one concern.
> 
> It is unclear whether there are mixed workloads on the same server
> that require both "volatile" and "strict" modes, but we have not
> encountered such use cases across our large fleet of servers.

At least containerd needs to strip out `volatile` in some use cases,
again see:
https://github.com/containerd/containerd/pull/9555
https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33

So set `volatile` as default will break userspace (containerd),
and containerd needs to add another mount option to avoid the
default `volatile` behavior, which is messy and makes the
userspace more harder.

> 
>>
>> The other concern is that since `volatile` omits fsync, so
>> it's a posix violation (even that makes sense for container
>> writable layers), not sure if we have to use it as the
>> system-wide default configuration too.
> 
> We have use cases for setting this as a system-wide configuration. It
> is unclear whether others have similar needs.

While I cannot speak out of overlayfs, but really it depends
on if the use cases is generic.

Usually filesystems need to obey posix semantics as much as
possible, and using specific mount option to relax (violate)
some restriction, but it shouldn't be a system-wide stuff
since otherwise user applications cannot know if they really
live in the posix world.

Thanks,
Gao Xiang


> 

