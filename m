Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2477C288C96
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 13:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219846; cv=none; b=mWUqsCjK/0uc2Kqjnz+7zWdZoCRBWy5AL5lit5UJLjAX0xEnK33sM7s1UM81QjPPqsIH8kn9xia1tbmGfbUl087oW5EgVUR1z7VJEWp4elP0HzDjBl+AfBoHqB6cvLIexf0rqWFMWvHukXC2yNPONhBfI8SX/XnMBU7DvmUREs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219846; c=relaxed/simple;
	bh=pBfXgRONjrnPDaB/5kxMybcWS6x1UWysOwrN6gXOXUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dsS9Ogj7bSn/JC8TwJVgvoxrKrD8ceBFCtQ3/gY5tzGlmr9YFWJPX08lsQP5+NBAQzCZgjdKu2ZmmTgFA7ouyOJevJPGXw+z0zvohEysbpvEXpjQmRTO3ZShV/jw8Fdh8bJVsi+6JfGGtjJz4rO0bLzpEYQby9Dn3cT63SGMzyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=vRGNvkLd; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="vRGNvkLd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782219840; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oR6ZDjz7ctHIVDo07/vsRLPZIP5uMU6Ji8emenam08c=;
	b=vRGNvkLdYpH4KdwAd2gu+N1M5c+apd1f6yaAUD2g4IfTWNbzOmKDUQoIKaKvMVXwb7w1ZtEoCFB0MKA0k44klE4M8g0VsaF16+uL8yRQPaliK8uo5mXPzzanfezKLEl5qCgUtZFpYF+eaTn9XeCWpZoxqUEIWvRJ+rX3hyCwM/A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5UH-im_1782219838;
Received: from 30.180.134.80(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5UH-im_1782219838 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 21:03:59 +0800
Message-ID: <7b4443de-e91b-49b4-b27d-8113f0832a8a@linux.alibaba.com>
Date: Tue, 23 Jun 2026 21:03:58 +0800
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

...

> 
>>
>>>
>>>>
>>>> The other concern is that since `volatile` omits fsync, so
>>>> it's a posix violation (even that makes sense for container
>>>> writable layers), not sure if we have to use it as the
>>>> system-wide default configuration too.
>>>
>>> We have use cases for setting this as a system-wide configuration. It
>>> is unclear whether others have similar needs.
>>
>> While I cannot speak out of overlayfs, but really it depends
>> on if the use cases is generic.
>>
>> Usually filesystems need to obey posix semantics as much as
>> possible, and using specific mount option to relax (violate)
>> some restriction, but it shouldn't be a system-wide stuff
>> since otherwise user applications cannot know if they really
>> live in the posix world.
> 
> AFAICS, the Linux kernel does not strictly follow POSIX in a number of areas.
> 
> BTW,
> 1. The "volatile" is not the default option.
> 2. Even when the system-wide default is set to "volatile", users can
> still change it per mount.

"
When overlay is mounted with "volatile" option, the directory
"$workdir/work/incompat/volatile" is created.  During next mount,
overlay checks for this directory and refuses to mount if present.
This is a strong indicator that the user should discard upper and
work directories and create fresh ones.
"

When the system-wide default is set to "volatile", it will become
a systemwide maintenance/compatiblity nightmare, at the very least,
if any overlayfs mount that needs to be remountable on these
systems (even something as small as a bash script that mounts an
overlayfs which must be remountable) they have to add "fsync=",
that needs application changes.

In my opinion, the argument "volatile is not the default option"
is not valid, since any reasonably robust userspace application
has to deal with _every visible Kconfig_ that could change the
kernel's default incompatible behavior. Otherwise, users who run
such applications on these kernels will inevitably complain.

On the other hand, I think the kernel itself should also be
responsible for ensuring that a new opt-in default remains
compatible with most existing userspace applications, regardless
of whether it is gated behind a Kconfig.

I don't think exposing incompatible default behavior, even behind
a new Kconfig, is okay without first reaching a sufficiently broad
audience.

Thanks,
Gao Xiang
