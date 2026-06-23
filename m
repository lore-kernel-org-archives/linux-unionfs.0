Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C91336E498
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 10:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209526; cv=none; b=Z1JvxJLjG7aHmkOBAoVQ8G/oXBBmGLFI4KlUsk514h+9WHdCUfrqWIURFUfV1vQQn9smhYYOrO7I4aLishcTtvin9iFAUhY8vkbYn2TZqOaXcZ9yYu0XUuLNU5YxjnGqGEUQrmzb6Zg1v8Y0Uv+CvPGotaQ3ZozsBsqQf28QB1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209526; c=relaxed/simple;
	bh=GKWhxnmin9C8KXDCB0s8f8XY1VjFSulvTHn1/woT5fU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n8aBCdSb51OCN1rcckytit9IbdFVE5aOgyydNhiTvJ3M0ToLVWRadQIw48+9HD+FG+93GE9xpKYoPOmmPmxmAISQZZm/m74mesgOLv3dcIqPc2bWYE88raGCywD4R1QUqZqHQ1iSWzVEAwlY3n0pqmxqFzrh4S+s/hXw5QD2tVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pR5meXF2; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pR5meXF2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782209522; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gbhjrVUba6vrOJZoU2T57dkDjF3VKrHb52fpIyBFEf0=;
	b=pR5meXF2kJ+t6tlu5J8Yj/c3X4tdBFcrx6Ii6lyFXs54rmwfSa/PJNe+bfprBRkrlJO7sPlwpdog5SRboR7Gg0VY3zSb+Uz8fFtUFo7Tee8AR+PBxRfPZfDr418n2F1sHTJQB6L3Lg6gI2X55SQ8K6i2rWJsACOLhuF2zvAV0XY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5TqL7-_1782209520;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5TqL7-_1782209520 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 18:12:01 +0800
Message-ID: <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com>
Date: Tue, 23 Jun 2026 18:12:00 +0800
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/6/23 17:59, Yafang Shao wrote:
> On Tue, Jun 23, 2026 at 5:49 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2026/6/23 17:34, Yafang Shao wrote:
>>> On Tue, Jun 23, 2026 at 5:25 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/6/23 17:15, Yafang Shao wrote:
>>>>> On Tue, Jun 23, 2026 at 5:00 PM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2026/6/23 16:43, Yafang Shao wrote:
>>>>>>> We have enabled "volatile" fsync_mode on our Kubernetes production
>>>>>>> environment to prevent container exit from being blocked when there
>>>>>>> are many dirty pages to flush. This has worked well without introducing
>>>>>>> any issues.
>>>>>>>
>>>>>>> However, on some of our production servers, upgrading the container
>>>>>>> runtime to support the "volatile" mount option is not straightforward [0].
>>>>>>> To address this, we want to enable it by default within the kernel.
>>>>>>
>>>>>> Just a side note: "upgrade the container runtime is not
>>>>>> straightforward", how? it seems that issue is already resolved and
>>>>>> there is no more discussion.
>>>>>
>>>>> We still have many production servers running Docker, while the
>>>>> "volatile" mount option is only supported by containerd. Upgrading
>>>>> from Docker to containerd is a difficult process.
>>>>
>>>> But docker can be patched too: if upgrading the userspace is
>>>> hard, why upgrading the linux kernel is easy?
>>>
>>> It is quite easy since the kernel can be livepatched without
>>> rebooting. My employer is a heavy livepatch user. [1]
>>>
>>> [1]. https://lore.kernel.org/live-patching/
>>
>> It's just a generic opinion, in general, docker can be live
>> upgraded without pausing the containers, and upgrading
>> userspace is easier / safer than patching the kernel.
> 
> Are you sure? How would one change an already mounted overlayfs that
> was not enabled with "volatile"?
> 
I don't see how your patch can apply to already mounted
overlayfs.

Again, I don't want such customized messy breaks userspace
again; with that patch, container runtime needs to consider
if `volatile` is the default which just breaks the existing
containerd versions.

Thanks,
Gao Xiang

