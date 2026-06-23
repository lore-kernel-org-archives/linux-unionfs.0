Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F50E2E7389
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209186; cv=none; b=SOUdrlnYYFJQjwQIsr0sFlaZDY8iLDIQOxZCzeGFFUnt9KFts+Ol3+T29RPYwS+rCXTf5t1eNNeZVOEQ6nDcB9QBrumwPUm/A6C1vkaIhSnq4fyO/mRSLPHyxrcLwCfgWWtdZqRoltDw2AZn5DPIeuPg5rJUIhJqBgp9Y3Rw9cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209186; c=relaxed/simple;
	bh=oi56KBaqbzfg6s3E/j79ztg7ZIyX9hHzJA4F8XewOYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DC82d72q3vtc/XlamC+strGpk1CvOwIzXCy4oEnsfxNNG70qRZ37tioopjPHFyPnIYnPFukSfR9SPbyHtjRFslDf9H8ZdYGOYnocu25eeCduZMtcRz6OVvwsZV/NCKoykK1OGHEcstljBKpOudxS95ez1yLsBWb+L707E3JYaFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Apz3RqL3; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Apz3RqL3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782209181; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WErfCvaSUgxBk9m9gVXBzacpG2P/70h0KHE31dDn0Q0=;
	b=Apz3RqL3zaw1HxaBR3kawXodTOQ4QcXrakQFLdWvlSHfz4ZniCl0GlCgtXgwgJ5rX7YmiDV0Hi58KWvOkjVxyv2IPrDa1ti/Vy+oRNZq+Uy7iwMv8XOUb8RskdGbF+PBnh3tloAMXA+DrrO5QONe0Bmzgo8XWGhJXLaJWaCTzPk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5TuQSt_1782209179;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5TuQSt_1782209179 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 18:06:20 +0800
Message-ID: <7985d6d1-a7ce-430a-9a06-9bbf95b1be2f@linux.alibaba.com>
Date: Tue, 23 Jun 2026 18:06:19 +0800
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
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>> Not quite sure applying a default volatile policy is quite feasible,
>>>>>> especially the issue documented in
>>>>>> https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
>>>>>>
>>>>>> then userspace cannot drop `volatile` option as a somewhat
>>>>>> workaround now.
>>>>>
>>>>> OS vendors can still set "auto" as the default config, while customers
>>>>> can override it dynamically via sysfs. We have been running with
>>>>> "volatile" on many production servers across different workloads for
>>>>> over a year, and it has worked as expected without any issues.
>>>>
>>>> but sysfs setting still applies as system-wide, and there
>>>> are some edge cases that we cannot apply volatile as
>>>> default, that is my one concern.
>>>
>>> It is unclear whether there are mixed workloads on the same server
>>> that require both "volatile" and "strict" modes, but we have not
>>> encountered such use cases across our large fleet of servers.
>>
>> At least containerd needs to strip out `volatile` in some use cases,
>> again see:
>> https://github.com/containerd/containerd/pull/9555
>> https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33
>>
>> So set `volatile` as default will break userspace (containerd),
>> and containerd needs to add another mount option to avoid the
>> default `volatile` behavior, which is messy and makes the
>> userspace more harder.
> 
> However, our userspace is easier with it ;)

It depends on how you define "our", if your docker can be
upgraded, why bothering kernel?

As I said, common existing applications (like containerd) will
break since they already assume "OVL_FSYNC_AUTO" is the default
behavior, and explicitly use mount options to override the
default "OVL_FSYNC_AUTO" behavior.

But with the patch, it just breaks the application assumption
and userspace application needs to change again.

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

Here, I'm strongly against this, again: especially it
just breaks application which implies "OVL_FSYNC_AUTO" is
the default, and we shouldn't ask userspace to handle this
to deal with the fact that the "volatile" could become
the default again and again.

Thanks,
Gao Xiang

> 

